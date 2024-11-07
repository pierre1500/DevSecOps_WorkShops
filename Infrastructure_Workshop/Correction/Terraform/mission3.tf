resource "azurerm_key_vault" "mars_key_vault" {
  name                = "MarsKeyVault"
  location            = azurerm_resource_group.mars_command_rg.location
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  sku_name            = "standard"
  tenant_id           = var.tenant_id
  tags = {
    asset_owner        = "maxime gaspard"
    asset_project_desc = "Phoenix Mission mars"
    asset_project_end  = "2025-12-31"
  }
}

resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-password"
  value        = var.sql_admin_password
  key_vault_id = azurerm_key_vault.mars_key_vault.id
}




resource "azurerm_monitor_diagnostic_setting" "mars_data_monitor_key_vault" {
  name                       = "MarsDataMonitor"
  target_resource_id         = azurerm_mssql_database.mars_comm_db.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.mars_log_analytics.id
  #   storage_account_id         = azurerm_storage_account.audit_storage.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

