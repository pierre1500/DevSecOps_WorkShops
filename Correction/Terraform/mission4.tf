resource "azurerm_recovery_services_vault" "mars_backup_vault" {
  name                = "MarsBackupVault"
  location            = azurerm_resource_group.mars_command_rg.location
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  sku                 = "Standard"
}

resource "azurerm_backup_policy_vm" "mars_backup_policy" {
  name                = "MarsVMBackupPolicy"
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  recovery_vault_name = azurerm_recovery_services_vault.mars_backup_vault.name

  backup {
    frequency = "Daily"
    time      = "12:00"
  }
  retention_daily {
    count = 7
  }
}

resource "azurerm_backup_protected_vm" "mars_vm_backup" {
  resource_group_name       = azurerm_resource_group.mars_command_rg.name
  recovery_vault_name       = azurerm_recovery_services_vault.mars_backup_vault.name
  source_vm_id              = azurerm_linux_virtual_machine.mars_vm.id
  backup_policy_id          = azurerm_backup_policy_vm.mars_backup_policy.id
}
