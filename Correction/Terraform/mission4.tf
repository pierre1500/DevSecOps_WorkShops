
resource "azurerm_container_registry" "mars_acr_advanced" {
  name                = "marsacrsecure"
  location            = azurerm_resource_group.mars_command_rg.location
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  sku                 = "Premium"

  tags = {
    asset_owner        = var.email
    asset_project_desc = "Phoenix Mission mars"
  }

  network_rule_set {
    default_action = "Deny"
    ip_rule {
      action   = "Allow"
      ip_range = "203.0.113.0/24"
    }
  }
}

resource "azurerm_role_assignment" "acr_push_role" {
  scope                = azurerm_container_registry.mars_acr_advanced.id
  role_definition_name = "AcrPush"
  principal_id         = var.appId
}
