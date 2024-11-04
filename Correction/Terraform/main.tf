
resource "azurerm_resource_group" "mars_command_rg" {
  name     = "MarsCommand_RG"
  location = "Central US" # Mars command center location setup
  tags = {
    Mission  = "Phoenix"
    Priority = "Alpha"
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

# Inbound Rule - Allow RDP
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

# Outbound Rule - Allow All Outbound
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

# Step 4 - Enable Network Watcher and Monitoring for Mars
resource "azurerm_network_watcher" "mars_network_watcher" {
  name                = "Mars_Network_Watcher"
  location            = azurerm_resource_group.mars_command_rg.location
  resource_group_name = azurerm_resource_group.mars_command_rg.name
}

resource "azurerm_log_analytics_workspace" "mars_workspace" {
  name                = "Mars-Workspace"
  location            = azurerm_resource_group.mars_command_rg.location
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Step 5 - Define Secure Network Infrastructure for Mars
resource "azurerm_virtual_network" "mars_comm_network" {
  name                = "MarsComm_Network"
  location            = azurerm_resource_group.mars_command_rg.location
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  address_space       = ["10.1.0.0/16"]
}

# Public Subnet
resource "azurerm_subnet" "mars_public_subnet" {
  name                 = "Mars_PublicSubnet"
  resource_group_name  = azurerm_resource_group.mars_command_rg.name
  virtual_network_name = azurerm_virtual_network.mars_comm_network.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Private Subnet
resource "azurerm_subnet" "mars_private_subnet" {
  name                 = "Mars_PrivateSubnet"
  resource_group_name  = azurerm_resource_group.mars_command_rg.name
  virtual_network_name = azurerm_virtual_network.mars_comm_network.name
  address_prefixes     = ["10.1.2.0/24"]
}
