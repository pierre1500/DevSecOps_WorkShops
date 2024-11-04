# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "TerraformRg"
  location = "France Central"
}

# Availability Set
resource "azurerm_availability_set" "DemoAset" {
  name                = "tf-aset"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "tf-vNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Adress IP public
resource "azurerm_public_ip" "publicip" {
  name                = "tf-publicip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "Internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.0.2.0/24"]
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "tf-vmwin-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "Internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}

# Azure Virtual Machine
resource "azurerm_linux_virtual_machine" "virtualmachine" {
  name                  = "tf-vmwin"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_F2"
  admin_username        = "*********"
  admin_password        = "*********"
  availability_set_id   = azurerm_availability_set.DemoAset.id
  network_interface_ids = [azurerm_network_interface.example.id]
  disable_password_authentication = false
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

data "template_file" "inventory" {
  template = file("inventory.tpl")
  vars = {
    vm_ip = azurerm_linux_virtual_machine.example.public_ip_address
  }
}

resource "local_file" "inventory" {
  content  = data.template_file.inventory.rendered
  filename = "${path.module}/inventory"
}
 
resource "azurerm_linux_function_app" "linux_function_app" {
  tags                       = merge(var.tags, {})
  storage_account_name       = azurerm_storage_account.storageaccount.name
  storage_account_access_key = azurerm_storage_account.storageaccount.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan.id
  resource_group_name        = azurerm_resource_group.rg.name
  name                       = "func1"
  location                   = "France Central"
 
  site_config {
    always_on = true
  }
}
 
data "azurerm_client_config" "client_config" {
}
 
resource "azurerm_service_plan" "service_plan2" {
  tags                = merge(var.tags, {})
  sku_name            = "P1v3"
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  name                = "serverless"
  location            = "+Central"
}
 
resource "azurerm_key_vault" "default" {
  tenant_id                   = data.azurerm_client_config.client_config.tenant_id
  tags                        = merge(var.tags, {})
  sku_name                    = "standard"
  resource_group_name         = azurerm_resource_group.rg.name
  name                        = "keyvault"
  location                    = "France Central"
  enabled_for_disk_encryption = true
 
  access_policy {
    tenant_id = data.azurerm_client_config.client_config.tenant_id
    object_id = data.azurerm_client_config.client_config.object_id
    key_permissions = [
      "List",
      "Create",
      "Delete",
      "Get",
    ]
    secret_permissions = [
      "Delete",
      "List",
      "Get",
      "Set",
    ]
  }
}
 
resource "azurerm_service_plan" "service_plan3" {
  tags                = merge(var.tags, {})
  sku_name            = "P1v3"
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  name                = "serverless"
  location            = "France Central"
}
 
resource "azurerm_linux_function_app" "linux_function_app2" {
  tags                       = merge(var.tags, {})
  storage_account_name       = azurerm_storage_account.storageaccount.name
  storage_account_access_key = azurerm_storage_account.storageaccount.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan2.id
  resource_group_name        = azurerm_resource_group.rg.name
  name                       = "func1"
  location                   = "France Central"
 
  site_config {
    always_on = true
  }
}
 
resource "azurerm_servicebus_namespace" "servicebus_namespace" {
  tags                = merge(var.tags, {})
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.rg.name
  name                = "serverless"
  location            = "France Central"
}
 
resource "azurerm_key_vault_access_policy" "azurerm_key_vault_access_policy-39f86868" {
  tenant_id    = data.azurerm_client_config.client_config.tenant_id
  object_id    = azurerm_linux_function_app.linux_function_app.identity[0].principal_id
  key_vault_id = azurerm_key_vault.default.id
 
  key_permissions = [
    "List",
    "Get",
  ]
 
  secret_permissions = [
    "Get",
    "List",
  ]
}
 
resource "azurerm_service_plan" "service_plan" {
  tags                = merge(var.tags, {})
  sku_name            = "P1v3"
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  name                = "serverless"
  location            = "France Central"
}
 
resource "azurerm_storage_container" "storage_container_jsons" {
  storage_account_name  = azurerm_storage_account.storageaccount.name
  name                  = "jsons"
  container_access_type = "private"
}
 
resource "azurerm_application_insights" "azurerm_application_insights-8e5f013b" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = "app-insights"
  location            = "France Central"
  application_type    = "web"
 
  tags = {
    env      = "development"
    archUUID = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
  }
}
 
resource "azurerm_servicebus_queue" "servicebus_queue" {
  namespace_id = azurerm_servicebus_namespace.servicebus_namespace.id
  name         = "serverless"
}
 
resource "azurerm_storage_account" "storageaccount" {
  resource_group_name      = azurerm_resource_group.rg.name
  name                     = "storageaccount"
  location                 = "France Central"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
 
  tags = {
    env      = "development"
    archUUID = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
  }
}
 
resource "azurerm_key_vault_secret" "basic_authentication" {
  value        = base64encode(format("%s:%s", var.username, var.password))
  name         = "BasicAuthentication"
  key_vault_id = azurerm_key_vault.default.id
 
  tags = {
    env      = "development"
    archUUID = "616357bb-69f5-4b84-8cd5-8490b476dfe1"
  }
}
 
resource "azurerm_linux_function_app" "linux_function_app3" {
  tags                       = merge(var.tags, {})
  storage_account_name       = azurerm_storage_account.storageaccount.name
  storage_account_access_key = azurerm_storage_account.storageaccount.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan3.id
  resource_group_name        = azurerm_resource_group.rg.name
  name                       = "func1"
  location                   = "France Central"
 
  site_config {
    always_on = true
  }
}