# 🛰️ **Mission 3: Secure Secret Management with Key Vault** - _Step 1: Implement Key Vault for Sensitive Data_

**Mission Date**: 2055, _Mars Command Center_

---

### **Mission Overview**

Mission 3 builds upon the existing Mars Data Systems by introducing a dedicated **Key Vault** for secure storage of sensitive information. This mission focuses on setting up Azure Key Vault to store and manage secrets critical to Mars operations, ensuring enhanced security for interplanetary communications.

---

## **Step 1: Deploy Key Vault for Mars Command Center**

**Objective:** Deploy an **Azure Key Vault** to securely manage secrets like database passwords required for Mars-Earth data exchange.

**Details:**

- **Resource Group:** MarsCommand_RG
- **Key Vault Name:** MarsKeyVault
- **Location:** Central US
- **Tags:**
  - **Owner:** Maxime Gaspard
  - **Project:** Phoenix Mission Mars
  - **End Date:** 2025-12-31

> **Mission Directive:** Ensure the Key Vault is deployed with restricted access and stores essential secrets securely.

---

### **🚀 Step 1 - Define Azure Key Vault**

#### Terraform Configuration:

<details>
  <summary>🔍 Explanation</summary>

```hcl
resource "azurerm_key_vault" "mars_key_vault" {
  name                = "MarsKeyVault"
  location            = azurerm_resource_group.mars_command_rg.location
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  sku_name            = "standard"
  tenant_id           = var.tenant_id
  tags = {
    asset_owner        = "NAME SURNAME"
    asset_project_desc = "Phoenix Mission mars"
    asset_project_end  = "2025-12-31"
  }
}
```

</details>

---

## **Step 2: Store Secrets in Key Vault**

**Objective:** Store the SQL database administrator password in Key Vault for enhanced security and manage access through Key Vault policies.

**Details:**

- **Secret Name:** sql-admin-password
- **Secret Value:** Encrypted database administrator password for Mars-Earth communications.

#### Terraform Configuration:

2. **Define Key Vault Secret** to securely store the SQL admin password:

<details>
  <summary>🔍 Explanation</summary>

```hcl
    resource "azurerm_key_vault_secret" "sql_admin_password" {
    name         = "sql-admin-password"
    value        = var.sql_admin_password
    key_vault_id = azurerm_key_vault.mars_key_vault.id
    }

```

</details>

---

### **🔒 Security Checkpoint**

Before proceeding:

- Confirm that the Key Vault and secrets are accessible only to authorized identities.
- Verify that secrets are encrypted and can be retrieved securely through approved access policies.

---

### **Step 3: Enable Diagnostic Monitoring for Key Vault**

**Objective:** Establish monitoring for Key Vault to log access patterns and alert on any unusual activity.

#### Terraform Configuration:

3. **Configure Diagnostic Settings** to monitor Key Vault usage and detect potential security threats:

<details>
  <summary>🔍 Explanation</summary>

- **Log Analytics Workspace**:

  ```hcl
  resource "azurerm_monitor_diagnostic_setting" "mars_data_monitor_key_vault" {
    name                       = "MarsDataMonitor"
    target_resource_id         = azurerm_key_vault.mars_key_vault.id
    log_analytics_workspace_id = azurerm_log_analytics_workspace.mars_log_analytics.id

    metric {
      category = "AllMetrics"
      enabled  = true
    }
  }
  ```

</details>

---

### **🔒 Security Checkpoint**

Before concluding the mission:

- Verify that diagnostics for Key Vault are active and logs are accessible in the Log Analytics workspace.
- Confirm that monitoring captures access attempts and alerts administrators to any suspicious activity.

