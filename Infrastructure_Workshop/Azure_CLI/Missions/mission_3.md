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

### **Exercises**

#### **Exercise 1: Create the Key Vault**
Your first task is to create a Key Vault for Earth Command, ensuring it is configured to store sensitive data securely.

<details>
<summary>💡 Show Solution</summary>

```bash
az keyvault create --name earthtestkvadminusetest2 --location francecentral --resource-group EarthCommand_RG --tenant-id "<tenant_id>" --sku standard --enable-soft-delete true --soft-delete-retention-days 90 --enable-rbac-authorization true --enabled-for-deployment true --enabled-for-disk-encryption true --enabled-for-template-deployment true --tags asset_owner="maxime gaspard" asset_project_desc="Phoenix Mission earth" asset_project_end="01-01-2025"
```

</details>

---

#### **Exercise 2: Retrieve the Virtual Machine Principal ID**
Now, retrieve the **principal ID** of the Earth Command VM to set access policies for it in the Key Vault.

<details>
<summary>💡 Show Solution</summary>

```bash
vm_principal_id=$(az vm show --name EarthVM --resource-group EarthCommand_RG --query "identity.principalId" -o tsv)
```

</details>

---

#### **Exercise 3: Set Key Vault Access Policy**
Set an access policy for the Earth Command VM to allow it to retrieve and list secrets stored in the Key Vault.

<details>
<summary>💡 Show Solution</summary>

```bash
az keyvault set-policy --name earthtestkvadminusetest2 --resource-group EarthCommand_RG --tenant-id "<tenant_id>" --object-id "$vm_principal_id" --secret-permissions get list
```

</details>

---

#### **Exercise 4: Store SQL Admin Password in Key Vault**
Next, store the SQL admin password in the Key Vault for secure retrieval by authorized entities.

<details>
<summary>💡 Show Solution</summary>

```bash
az keyvault secret set --vault-name earthtestkvadminusetest2 --name sql-admin-password --value "<sql_admin_password>"
```

</details>

---

#### **Exercise 5: Enable Monitoring for Key Vault**
Enable diagnostic settings to send monitoring data for your Key Vault to a Log Analytics workspace, ensuring that all key activities are tracked.

<details>
<summary>💡 Show Solution</summary>

```bash
az monitor diagnostic-settings create --name EarthDataMonitorKeyVault --resource "$(az keyvault show --name earthtestkvadminusetest2 --resource-group EarthCommand_RG --query id -o tsv)" --workspace "$(az monitor log-analytics workspace show --name EarthLogAnalyticsWorkspace --resource-group EarthCommand_RG --query id -o tsv)" --metrics '[{"category":"AllMetrics","enabled":true}]'
```

</details>

---

#### **Exercise 6: Enable Monitoring for SQL Database**
Lastly, configure monitoring for the Earth Command SQL Database to ensure that its performance and health metrics are captured for analysis.

<details>
<summary>💡 Show Solution</summary>

```bash
az monitor diagnostic-settings create --name EarthDataMonitorSQL --resource "$(az sql db show --name earthqlserver2055 --server earthqlserver2055 --resource-group EarthCommand_RG --query id -o tsv)" --workspace "$(az monitor log-analytics workspace show --name EarthLogAnalyticsWorkspace --resource-group EarthCommand_RG --query id -o tsv)" --metrics '[{"category":"AllMetrics","enabled":true}]'
```

</details>

---

### **🎖️ Mission Debrief**
With the Key Vault and monitoring configurations now in place, Earth Command is well-equipped to securely manage sensitive information and track the health of its critical resources. This will help ensure the smooth running of operations as the Phoenix Mission progresses.

🚀 **Next Steps:** Proceed to **[Mission_4.md](mission_4.md)** to continue your training and tackle further challenges.
