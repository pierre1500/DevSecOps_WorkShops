# **🌌 Mission 3: Key Vault and Monitoring for Earth Command**

### **📝 Mission Brief**
As a crucial member of Earth Command, your mission is to implement security best practices for managing secrets and keys through Azure Key Vault. In addition, you will integrate monitoring for both Key Vault and SQL Database services to track metrics and potential issues. This will ensure the safety and integrity of sensitive information in the Phoenix Mission.

---

## **Objectives**
- Deploy an Azure Key Vault for secure storage and access management.
- Set access policies for Virtual Machine identities.
- Store and manage secrets (like SQL admin passwords) securely.
- Enable diagnostic monitoring for Key Vault and SQL Database services.

---

## Technical Documentation References
- [Azure Key Vault Overview](https://learn.microsoft.com/en-us/azure/key-vault/general/overview)
- [Key Vault Access Policies](https://learn.microsoft.com/en-us/azure/key-vault/general/assign-access-policy)
- [Key Vault Soft Delete](https://learn.microsoft.com/en-us/azure/key-vault/general/soft-delete-overview)
- [Managed Identities Overview](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview)
- [Azure Monitor Diagnostic Settings](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/diagnostic-settings)
- [Key Vault Security Features](https://learn.microsoft.com/en-us/azure/key-vault/general/security-features)

---


### **Exercises**

#### **Exercise 1: Create the Key Vault**

Your first task is to create a Key Vault for Earth Command, ensuring it is configured to store sensitive data securely.  
- Create a Key Vault named `earthtestkvadminusetest2` in the `EarthCommand_RG` resource group.  
- Set the location to `francecentral`.  
- Enable soft-delete with a retention period of 90 days.  
- Use the standard SKU for the Key Vault.  
- Enable RBAC authorization and deployment, disk encryption, and template deployment.  
- Add tags such as asset_owner and asset_project_desc.

<details>
<summary>💡 Show Solution</summary>

```bash
az keyvault create --name earthtestkvadminusetest2 --location francecentral --resource-group EarthCommand_RG --sku standard --enable-soft-delete true --soft-delete-retention-days 90 --enabled-for-deployment true --enabled-for-disk-encryption true --enabled-for-template-deployment true --tags asset_owner="maxime gaspard" asset_project_desc="Phoenix Mission earth" asset_project_end="01-01-2025"
```

</details>

---

#### **Exercise 2: Retrieve the Virtual Machine Principal ID**

Now, retrieve the **principal ID** of the Earth Command VM to set access policies for it in the Key Vault.  
- Use the `az vm show` command to fetch the `principalId` of the `EarthVM`.  
- Store the result in the `vm_principal_id` variable for use in future Key Vault configuration.

<details>
<summary>💡 Show Solution</summary>

```bash
vm_principal_id=$(az vm show --name EarthVM --resource-group EarthCommand_RG --query "identity.principalId" -o tsv)
```

</details>

---

#### **Exercise 3: Set Key Vault Access Policy**

Set an access policy for the Earth Command VM to allow it to retrieve and list secrets stored in the Key Vault.  
- Use the `az keyvault set-policy` command to grant the VM's principal ID the `get` and `list` permissions for secrets.  
- Replace the `<tenant_id>` placeholder with the actual tenant ID.  
- Apply the policy to the `earthtestkvadminusetest2` Key Vault.

<details>
<summary>💡 Show Solution</summary>

```bash
az keyvault set-policy --name earthtestkvadminusetest2 --resource-group EarthCommand_RG --tenant-id "<tenant_id>" --object-id "$vm_principal_id" --secret-permissions get list
```

</details>

---

#### **Exercise 4: Store SQL Admin Password in Key Vault**

Next, store the SQL admin password in the Key Vault for secure retrieval by authorized entities.  
- Use the `az keyvault secret set` command to store the `sql-admin-password` in the Key Vault.  
- Replace the `<sql_admin_password>` placeholder with the actual SQL admin password.
<details>
<summary>💡 Show Solution</summary>

```bash
az keyvault secret set --vault-name earthtestkvadminusetest2 --name sql-admin-password --value "<sql_admin_password>"
```

</details>

---

#### **Exercise 5: Enable Monitoring for Key Vault**

Enable diagnostic settings to send monitoring data for your Key Vault to a Log Analytics workspace, ensuring that all key activities are tracked.  
- Use the `az monitor diagnostic-settings create` command to enable monitoring for the Key Vault.  
- Replace the placeholders in the command with the appropriate values for your setup.

<details>
<summary>💡 Show Solution</summary>

```bash
az monitor diagnostic-settings create --name EarthDataMonitorKeyVault --resource "$(az keyvault show --name earthtestkvadminusetest2 --resource-group EarthCommand_RG --query id -o tsv)" --workspace "$(az monitor log-analytics workspace show --name EarthLogAnalyticsWorkspace --resource-group EarthCommand_RG --query id -o tsv)" --metrics '[{"category":"AllMetrics","enabled":true}]'
```

</details>

---

#### **Exercise 6: Enable Monitoring for SQL Database**

Lastly, configure monitoring for the Earth Command SQL Database to ensure that its performance and health metrics are captured for analysis.  
- Use the `az monitor diagnostic-settings create` command to enable monitoring for the SQL Database.  
- Replace the placeholders in the command with the appropriate values for your setup.

<details>
<summary>💡 Show Solution</summary>

```bash
az monitor diagnostic-settings create --name EarthDataMonitorSQL --resource "$(az sql db show --name earthqlserver2055 --server earthqlserver2055 --resource-group EarthCommand_RG --query id -o tsv)" --workspace "$(az monitor log-analytics workspace show --name EarthLogAnalyticsWorkspace --resource-group EarthCommand_RG --query id -o tsv)" --metrics '[{"category":"AllMetrics","enabled":true}]'
```

</details>

---

## Additional Resources
- [Azure Key Vault CLI Reference](https://learn.microsoft.com/en-us/cli/azure/keyvault)
- [Key Vault Best Practices](https://learn.microsoft.com/en-us/azure/key-vault/general/best-practices)
- [Key Vault Monitoring Guide](https://learn.microsoft.com/en-us/azure/key-vault/general/monitor-key-vault)
- [Azure RBAC for Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/rbac-guide)
- [Key Vault Secrets Management](https://learn.microsoft.com/en-us/azure/key-vault/secrets/about-secrets)
- [Azure Monitor Metrics](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported)
- [Key Vault Backup and Recovery](https://learn.microsoft.com/en-us/azure/key-vault/general/backup)
- [Key Vault Security Baseline](https://learn.microsoft.com/en-us/security/benchmark/azure/baselines/key-vault-security-baseline)

---

### **🎖️ Mission Debrief**
With the Key Vault and monitoring configurations now in place, Earth Command is well-equipped to securely manage sensitive information and track the health of its critical resources. This will help ensure the smooth running of operations as the Phoenix Mission progresses.

🚀 **Next Steps:** Proceed to **[Mission_4.md](mission_4.md)** to continue your training and tackle further challenges.
