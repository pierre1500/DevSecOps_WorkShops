# 🛰️ **Mission 3: Securing and Optimizing Mars Communication Infrastructure** - *Step 3: Implement Key Vault and Advanced Security Measures*

**Mission Date:** 2055, *Earth Command Center*

---

### **Mission Overview**

Following the deployment of the Earth-to-Mars data system, this mission focuses on securing sensitive information and implementing advanced security features. The first step is to deploy an Azure Key Vault to store sensitive information such as the SQL database password from Mission 2. Additional steps will expand on threat monitoring, resource optimization, and secure access management to enhance the system’s security and efficiency.

---

### **Step 1: Deploy Azure Key Vault for Secure Password Storage**

**Objective:** Create an **Azure Key Vault** to securely store the SQL database password set in Mission 2 and allow managed access for applications requiring it.

**Details:**
- **Resource Group:** EarthCommand_RG
- **Key Vault Name:** MarsKeyVault2055
- **Location:** Central US
- **Access Policies:** Grant read access for Earth-to-Mars data processing applications

> **Mission Directive:** Set up Azure Key Vault and securely store the SQL database password, configuring access permissions to control who can retrieve the credentials.

---

### **🛠️ Task: Set Up Azure Key Vault and Store Database Password**

Attempt to deploy the Azure Key Vault and store the password. If necessary, reveal the solution below.

<details>
  <summary>🚀 Solution for Step 1</summary>

  1. **Create the Key Vault:**
     ```bash
     az keyvault create --name MarsKeyVault2055 --resource-group EarthCommand_RG --location centralus
     ```

  2. **Store the Database Password in Key Vault:**
     ```bash
     az keyvault secret set --vault-name MarsKeyVault2055 --name MarsCommDBPassword --value '<YourDatabasePassword>'
     ```

  3. **Configure Access Policies:** Grant read access to applications or users who need the password:
     ```bash
     az keyvault set-policy --name MarsKeyVault2055 --object-id <AppOrUserObjectId> --secret-permissions get
     ```

  4. **Verify the Secret:** Check that the secret has been stored correctly and is retrievable:
     ```bash
     az keyvault secret show --vault-name MarsKeyVault2055 --name MarsCommDBPassword
     ```
</details>

---

### **🔒 Security Checkpoint**

Before proceeding to the next step:
- Confirm that the Key Vault is accessible only to authorized applications and users.
- Ensure that the password is securely stored and can be retrieved only by applications with the correct permissions.

---

### **Step 2: Implement Conditional Access Policies**

**Objective:** Set up Conditional Access policies to restrict database access based on location and risk level.

**Details:**
- **Access Restriction:** Permit access to the database only from approved locations (e.g., Earth Command Center IP range).
- **Risk-based Access Control:** Enable Multi-Factor Authentication (MFA) for any access attempt from outside the approved location.

> **Mission Directive:** Implement Conditional Access rules to protect against unauthorized database access.

---

### **🛠️ Task: Configure Conditional Access Policies**

Attempt to set Conditional Access policies for the database. Reveal the solution if needed.

<details>
  <summary>🚀 Solution for Step 2</summary>

  1. **Define a Named Location:** Set up Earth Command Center's IP range as a trusted location:
     ```bash
     az ad named-location create --display-name "Earth Command Center" --ip-ranges "203.0.113.0/24"
     ```

  2. **Create Conditional Access Policy:** Configure a policy to restrict access to trusted locations and enable MFA outside of them:
     ```bash
     az ad conditionalaccess policy create --display-name "MarsCommDBAccessPolicy" --state enabled --conditions <SpecifyConditions> --grant-controls <SpecifyGrantControls>
     ```

  3. **Verify Policy Configuration:** Check that the policy is active and enforces the correct access restrictions:
     ```bash
     az ad conditionalaccess policy show --display-name "MarsCommDBAccessPolicy"
     ```
</details>

---

### **🔒 Security Checkpoint**

Before moving to the next step:
- Ensure that access to the database is restricted to trusted IP ranges and that MFA is enabled for all other access attempts.
- Verify that the policy is working as expected.

---

### **Step 3: Monitor and Respond to Threats with Azure Sentinel**

**Objective:** Configure Azure Sentinel to monitor for unusual activity in the Mars communication infrastructure, alerting administrators to potential threats.

**Details:**
- **Resource Group:** EarthCommand_RG
- **Azure Sentinel:** Connect Key Vault and SQL database for threat detection
- **Alert Configuration:** Set up alerts for unauthorized access attempts or high-volume data access

> **Mission Directive:** Integrate Sentinel with your resources and configure threat alerts to respond quickly to security incidents.

---

### **🛠️ Task: Configure Azure Sentinel and Set Up Alerts**

Attempt to configure Azure Sentinel for monitoring. Reveal the solution below if necessary.

<details>
  <summary>🚀 Solution for Step 3</summary>

  1. **Deploy Azure Sentinel Workspace:**
     ```bash
     az sentinel create --resource-group EarthCommand_RG --workspace-name EarthSentinelWorkspace
     ```

  2. **Connect Key Vault and SQL Database to Sentinel:**
     ```bash
     az sentinel connect-resource --workspace EarthSentinelWorkspace --resource "/subscriptions/<SubscriptionID>/resourceGroups/EarthCommand_RG/providers/Microsoft.KeyVault/vaults/MarsKeyVault2055"
     az sentinel connect-resource --workspace EarthSentinelWorkspace --resource "/subscriptions/<SubscriptionID>/resourceGroups/EarthCommand_RG/providers/Microsoft.Sql/servers/earthsqlserver2055/databases/MarsCommDB"
     ```

  3. **Set Up Alert Rules:** Configure alerts for suspicious activities:
     ```bash
     az sentinel alert-rule create --workspace-name EarthSentinelWorkspace --display-name "Unauthorized Access Alert" --severity High --trigger <SpecifyTriggerConditions>
     ```
</details>

---

### **🔒 Security Checkpoint**

Before advancing to the final step:
- Verify that Azure Sentinel is monitoring Key Vault and SQL database activity.
- Ensure alerts are set up correctly and can notify the admin team of suspicious activities.

---

### **Step 4: Optimize Database Performance and Cost Management**

**Objective:** Analyze and optimize database performance while managing costs to ensure efficient resource use.

**Details:**
- **Resource Optimization:** Identify and remove unused indexes, optimize query performance.
- **Cost Management:** Set up cost alert thresholds for the SQL database to avoid unexpected expenses.

> **Mission Directive:** Fine-tune the SQL database configuration to maintain high performance and stay within budget.

---

### **🛠️ Task: Optimize Database and Configure Cost Alerts**

Attempt to analyze and optimize database performance and configure cost alerts. Reveal the solution if necessary.

<details>
  <summary>🚀 Solution for Step 4</summary>

  1. **Analyze Database Performance:** Review performance metrics and optimize queries:
     ```bash
     az sql db query-performance-insight list --resource-group EarthCommand_RG --server earthsqlserver2055 --database MarsCommDB
     ```

  2. **Configure Cost Alerts:** Set a cost alert for the SQL database to manage expenses:
     ```bash
     az monitor budget create --resource-group EarthCommand_RG --name MarsCommDBCostAlert --amount <BudgetAmount> --time-period month
     ```

  3. **Optimize Indexes:** Identify unused indexes and remove them to improve performance:
     ```sql
     -- Example SQL query to identify unused indexes
     SELECT object_id, index_id, user_seeks, user_scans, user_lookups
     FROM sys.dm_db_index_usage_stats
     WHERE database_id = DB_ID('MarsCommDB')
     AND user_updates = 0;
     ```
</details>

---

### **🔒 Final Security Checkpoint**

Before completing the mission:
- Confirm that performance optimizations are applied and cost alerts are active.
- Review database metrics to ensure smooth performance under expected load.

---

