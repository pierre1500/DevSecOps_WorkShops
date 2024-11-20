# SQL Server
resource "azurerm_mssql_server" "mars_sql_server" {
  name                         = "marsqlserver2055"
  resource_group_name          = azurerm_resource_group.mars_command_rg.name
  location                     = azurerm_resource_group.mars_command_rg.location
  version                      = "12.0"
  administrator_login          = "azureuser"
  administrator_login_password = var.sql_admin_password
}


resource "azurerm_mssql_database" "mars_comm_db" {
  name                        = "marsqlserver2055"
  server_id                   = azurerm_mssql_server.mars_sql_server.id
  collation                   = "SQL_Latin1_General_CP1_CI_AS"
  sku_name                    = "GP_S_Gen5_1"
  max_size_gb                 = 32
  zone_redundant              = false
  read_replica_count          = 1
  min_capacity                = 1
  auto_pause_delay_in_minutes = -1
  short_term_retention_policy {
    retention_days = 7
  }
}

resource "azurerm_mssql_firewall_rule" "mars_command_center_access" {
  name             = "MarsCommandCenterAccess"
  server_id        = azurerm_mssql_server.mars_sql_server.id
  start_ip_address = "203.0.113.0"
  end_ip_address   = "203.0.113.255"
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.mars_command_rg.name
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "mars-private-endpoint"
  location            = azurerm_resource_group.mars_command_rg.location
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  subnet_id           = azurerm_subnet.mars_private_subnet.id

  private_service_connection {
    name                           = "database-connection"
    private_connection_resource_id = azurerm_mssql_server.mars_sql_server.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }
}

resource "azurerm_log_analytics_workspace" "mars_log_analytics" {
  name                = "MarsLogAnalyticsWorkspace"
  location            = azurerm_resource_group.mars_command_rg.location
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  sku                 = "PerGB2018"
}

resource "azurerm_monitor_diagnostic_setting" "mars_data_monitor" {
  name                       = "MarsDataMonitor"
  target_resource_id         = azurerm_mssql_database.mars_comm_db.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.mars_log_analytics.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# output "database_connection_test" {
#   value = "Database connection test: Access granted for Mars Command Center IP range (203.0.113.0/24)."
# }
