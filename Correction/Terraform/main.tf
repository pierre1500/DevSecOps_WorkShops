resource "azurerm_resource_group" "mars_command_rg" {
  name     = "MarsCommand_RG"
  location = "francecentral"
  tags = {
    asset_owner        = "maxime gaspard"
    asset_project_desc = "Phoenix Mission mars"
    asset_project_end  = "2025-12-31"
  }
}

resource "azurerm_virtual_network" "mars_comm_network" {
  name                = "MarsComm_Network"
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

resource "azurerm_public_ip" "mars_vm_public_ip" {
  name                = "MarsVM_PublicIP"
  location            = azurerm_resource_group.mars_command_rg.location
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "mars_vm_nic" {
  name                = "MarsVM_NIC"
  location            = azurerm_resource_group.mars_command_rg.location
  resource_group_name = azurerm_resource_group.mars_command_rg.name

  ip_configuration {
    name                          = "MarsVM_IPConfig"
    subnet_id                     = azurerm_subnet.mars_public_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mars_vm_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "mars_vm" {
  name                  = "MarsVM"
  location              = azurerm_resource_group.mars_command_rg.location
  resource_group_name   = azurerm_resource_group.mars_command_rg.name
  network_interface_ids = [azurerm_network_interface.mars_vm_nic.id]
  size                  = "Standard_B2ms"

  admin_username                  = "ubuntuadmin"
  disable_password_authentication = false
  admin_password                  = var.vm_password_admin

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    name                 = "MarsVM_OSDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = {
    asset_owner              = "maxime.gaspard@cgi.com"
    asset_project_desc       = "Phoenix Mission mars"
    asset_project_start      = "2024-10-16"
    asset_project_end        = "2025-12-31"
    availability1            = 1
    availability2            = 15
    maintenance1             = "monday"
    maintenance2             = "friday"
    shutdownaftermaintenance = "no"
    barcode                  = "4464_6144_1409481"
    autostart                = "no"
    Auto-shutdown            = "no"
    autoshutdown             = "no"
  }
}

output "mars_vm_public_ip" {
  value = azurerm_public_ip.mars_vm_public_ip.ip_address
}

