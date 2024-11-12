# Provider Configuration
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = "2ce61caf-883c-424a-868d-e94683afc99a"
}
