resource "azurerm_key_vault" "mars_test_kv_admin" {
  name                            = "marstestkvadminuse"
  location                        = azurerm_resource_group.mars_command_rg.location
  resource_group_name             = azurerm_resource_group.mars_command_rg.name
  tenant_id                       = var.tenant_id
  sku_name                        = "standard"
  soft_delete_retention_days      = 90
  enable_rbac_authorization       = true
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true

  tags = {
    asset_owner        = "maxime gaspard"
    asset_project_desc = "Phoenix Mission mars"
    asset_project_end  = "01-01-2025"
  }

  access_policy {
    tenant_id = var.tenant_id
    object_id = azurerm_linux_virtual_machine.mars_vm.identity[0].principal_id

    secret_permissions = [
      "Get",
      "List"
    ]
  }
}


resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-password"
  value        = var.sql_admin_password
  key_vault_id = azurerm_key_vault.mars_test_kv_admin.id
}


resource "azurerm_monitor_diagnostic_setting" "mars_data_monitor_key_vault" {
  name                       = "MarsDataMonitorKeyVault"
  target_resource_id         = azurerm_key_vault.mars_test_kv_admin.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.mars_log_analytics.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# resource "azurerm_key_vault_access_policy" "mars_kv_policy" {
#   key_vault_id = azurerm_key_vault.mars_key_vault.id
#   tenant_id    = var.tenant_id
#   object_id    = 
#   # Specify permissions for secrets, keys, and certificates
#   secret_permissions = [
#     "get",
#     "list",
#     "set",
#     "delete",
#     "backup",
#     "restore",
#   ]

#   key_permissions = [
#     "get",
#     "list",
#     "encrypt",
#     "decrypt",
#   ]

#   certificate_permissions = [
#     "get",
#     "list",
#     "update",
#     "create",
#   ]
# }


resource "azurerm_monitor_diagnostic_setting" "mars_data_monitor_sql" {
  name                       = "MarsDataMonitorSQL"
  target_resource_id         = azurerm_mssql_database.mars_comm_db.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.mars_log_analytics.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

#not having access to the mode
# resource "azurerm_sentinel_alert_rule_scheduled" "unauthorized_access_alert" {
#   name                       = "UnauthorizedAccessAlert"
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.mars_log_analytics.id
#   display_name               = "Unauthorized Access Alert"
#   severity                   = "High"
#   query                      = <<QUERY
# SigninLogs
# | where ResultType != "0"
# | summarize Count=count() by UserPrincipalName, bin(TimeGenerated, 1h)
# | where Count > 5
# QUERY
#   query_frequency            = "PT1H"
#   query_period               = "PT1H"
#   trigger_operator           = "GreaterThan"
#   trigger_threshold          = 0
#   suppression_enabled        = false
#   description                = "Alert for unauthorized access attempts"
# }
