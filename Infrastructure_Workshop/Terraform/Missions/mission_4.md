# 🛰️ **Mission 4: Mars Data Systems Deployment** - _Step 1: Establish the Core Database Infrastructure_

**Mission Date**: 2055, _Mars Command Center_

### **Mission Overview**

Building key vault store for the Mars infrastruscture

---

## **Step 1: Deploy the Managed Key vault Store with the right resource**

**Details:**

- **Name** Name the keyvault store
- **location** Put the location of the resource_group
- **resource_group_name** Put the name of the resource_group
- **Sku** Put the right Pricing Tier

<details>
   <summary>Show the solution</summary>
   
```hcl
resource "azurerm_recovery_services_vault" "mars_backup_vault" {
name                = "MarsBackupVault"
location            = azurerm_resource_group.mars_command_rg.location
resource_group_name = azurerm_resource_group.mars_command_rg.name
sku                 = "Standard"
}
```
</details>

## **Step 2: Deploy the azurerm backup policy vm for our a virtual machine**

**Details**

- **You have to deploy a backup policy and protected backup for the vm we created on mission 1. You have to make a backup every day a 12.00 with a retention of 7 days**

<details>
  <summary>Show the solution</summary>

```hcl
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
```

</details>

---

## The end

You arrived at the end of the workshops, tell us more about your feelings on Terraform. Please share with your partner.
