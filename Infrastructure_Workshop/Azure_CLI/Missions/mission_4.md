# 🛠 **Mission 4: Automate Security Responses** - _Step 4: Implement Automatic Security Responses to Protect Critical Resources_

**Mission Date:** 2055 , _Mars Datacenter_

### **Mission Overview**

Mission 5 involves setting up a secure **Azure Container Registry (ACR)** to store container images required for Mars Command operations. This ACR will have restricted access to enhance security, ensuring only authorized resources and networks can interact with the registry. to receive the image DOcker from the earth

---

## **Step 5: Deploy ACR with Network Restrictions and Role-Based Access Control**

**Objective:** Deploy an Azure Container Registry with network restrictions, ensuring secure storage for Mars application container images. Additionally, assign the necessary roles to enable only specific resources to push images to the registry.

---

### **🚀 Step 1 - Define Azure Container Registry (ACR)**

#### Terraform Configuration:

<details>
  <summary> Correction below </summary>
    ```hcl
    resource "azurerm_container_registry" "mars_acr_advanced" {
      name                = "marsacrsecure"
      location            = azurerm_resource_group.mars_command_rg.location
      resource_group_name = azurerm_resource_group.mars_command_rg.name
      sku                 = "Premium"

      tags = {
        asset_owner        = "maxime gaspard"
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
      principal_id         = azurerm_linux_virtual_machine.mars_vm.identity[0].principal_id
    }
    ```

</details>
