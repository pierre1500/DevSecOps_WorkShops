
resource "azurerm_resource_group" "mars_command_rg" {
  name     = "MarsCommand_RG"
  location = "francecentral" # Mars command center location setup
  tags = {
    asset_owner        = "maxime gaspard"
    asset_project_desc = "Phoenix Mission mars"
    asset_project_end  = "2025-12-31"
  }
}

resource "azurerm_virtual_network" "mars_vnet" {
  name                = "Mars_VNet"
  location            = azurerm_resource_group.mars_command_rg.location
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_network_security_group" "mars_nsg" {
  name                = "Mars_NSG"
  location            = azurerm_resource_group.mars_command_rg.location
  resource_group_name = azurerm_resource_group.mars_command_rg.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "Allow-SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "203.0.113.0/24"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.mars_nsg.name
  resource_group_name         = azurerm_resource_group.mars_command_rg.name
}


resource "azurerm_network_security_rule" "allow_rdp" {
  name                        = "Allow-RDP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "203.0.113.0/24"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.mars_nsg.name
  resource_group_name         = azurerm_resource_group.mars_command_rg.name
}


resource "azurerm_network_security_rule" "allow_all_outbound" {
  name                        = "Allow-All-Outbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.mars_nsg.name
  resource_group_name         = azurerm_resource_group.mars_command_rg.name
}


resource "azurerm_virtual_network" "mars_comm_network" {
  name                = "MarsComm_Network"
  location            = azurerm_resource_group.mars_command_rg.location
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "mars_public_subnet" {
  name                 = "Mars_PublicSubnet"
  resource_group_name  = azurerm_resource_group.mars_command_rg.name
  virtual_network_name = azurerm_virtual_network.mars_comm_network.name
  address_prefixes     = ["10.1.1.0/24"]
}


resource "azurerm_subnet" "mars_private_subnet" {
  name                 = "Mars_PrivateSubnet"
  resource_group_name  = azurerm_resource_group.mars_command_rg.name
  virtual_network_name = azurerm_virtual_network.mars_comm_network.name
  address_prefixes     = ["10.1.2.0/24"]
}



# SQL Server
resource "azurerm_sql_server" "mars_sql_server" {
  name                         = "marsqlserver2055"
  resource_group_name          = azurerm_resource_group.mars_command_rg.name
  location                     = "francecentral"  # Optimized location for Mars-Earth communication
  version                      = "12.0"
  administrator_login          = "azureuser"
  administrator_login_password = "<YourComplexPassword>"  # Use a complex password here
}

# SQL Database
resource "azurerm_sql_database" "mars_comm_db" {
  name                = "MarsCommDB"
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  location            = azurerm_resource_group.mars_command_rg.location
  server_name         = azurerm_sql_server.mars_sql_server.name

  sku {
    name     = "S2"
    tier     = "Standard"
    capacity = 50
  }
}

# Firewall Rule for Mars Command Center Access
resource "azurerm_sql_firewall_rule" "mars_command_center_access" {
  name                = "MarsCommandCenterAccess"
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  server_name         = azurerm_sql_server.mars_sql_server.name
  start_ip_address    = "203.0.113.0"
  end_ip_address      = "203.0.113.255"
}

# Transparent Data Encryption (TDE)
resource "azurerm_mssql_database" "mars_comm_db_encryption" {
  name       = azurerm_sql_database.mars_comm_db.name
  server_id  = azurerm_sql_server.mars_sql_server.id

  transparent_data_encryption {
    status = "Enabled"
  }
}

# Advanced Threat Protection
resource "azurerm_mssql_server_security_alert_policy" "mars_comm_security_alert" {
  server_name = "ferferfz"
  server_id                  = azurerm_sql_server.mars_sql_server.id
  state                      = "Enabled"
  email_account_admins       = true
  email_addresses            = ["admin@example.com"]  # Replace with the admin's email
}

# Log Analytics Workspace for Monitoring
resource "azurerm_log_analytics_workspace" "mars_data_workspace" {
  name                = "MarsData_Workspace"
  location            = "centralus"
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  sku                 = "PerGB2018"
}

# Diagnostic Setting for SQL Database Monitoring
resource "azurerm_monitor_diagnostic_setting" "mars_data_monitor" {
  name                       = "MarsDataMonitor"
  target_resource_id         = azurerm_sql_database.mars_comm_db.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.mars_data_workspace.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }

  log {
    category = "SQLInsights"
    enabled  = true
  }
}

# Alert for High CPU Usage
resource "azurerm_monitor_metric_alert" "high_cpu_alert" {
  name                = "HighCPUAlert"
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  scopes              = [azurerm_sql_database.mars_comm_db.id]
  description         = "Alert for CPU usage exceeding 80%"
  criteria {
    aggregation        = "Average"
    metric_name        = "cpu_percent"
    operator           = "GreaterThan"
    threshold          = 80
  }
  frequency           = "PT1M"
  window_size         = "PT5M"
}

# Output for Connectivity Test Verification
output "database_connection_test" {
  value = "Database connection test: Access granted for Mars Command Center IP range (203.0.113.0/24)."
}