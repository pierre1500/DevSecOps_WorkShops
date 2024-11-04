# 🛰️ **Mission 2: Earth Data Systems Deployment** - *Step 2: Establish the Core Database Infrastructure*

**Mission Date**: 2055, *Earth Command Center*

---

### **Mission Overview**

Building on your foundational infrastructure from Mission 1, Mission 2 focuses on deploying a managed database system to support Earth's command and communication with Mars. This database will be a critical component, storing and managing essential data to facilitate seamless and secure interplanetary communications and operations.

---

### **Step 1: Deploy the Managed Database – Core of Earth Data Operations**

**Objective:** Your first task is to deploy a managed **Azure SQL Database** to handle and secure Earth-Mars data exchanges.

**Details:**
- **Resource Group:** EarthCommand_RG
- **SQL Server Name:** earthsqlserver2055
- **Location:** Central US (optimized for real-time Mars-Earth communication)
- **Database Name:** MarsCommDB
- **Pricing Tier:** Standard S2 (to balance cost and performance)
- **Firewall Rules:** Allow access only from authorized IP addresses (e.g., Earth Command Center IP range: `203.0.113.0/24`)

> **Mission Directive:** Ensure that the SQL Server and database are secure, and configure access controls to prevent unauthorized access.

---

### **🛠️ Database Deployment Task Brief**

Attempt to deploy the managed database using Azure CLI commands based on the details above. If you need guidance, reveal the solution by expanding the section below.

<details>
  <summary>🚀 Step 1 Deployment Solution</summary>

  1. **Create the SQL Server:** Begin by setting up the SQL Server in Azure:
     ```bash
     az sql server create --name earthsqlserver2055 --resource-group EarthCommand_RG --location centralus --admin-user azureuser --admin-password '<YourComplexPassword>'
     ```

  2. **Create the SQL Database:** Deploy the database within the newly created server:
     ```bash
     az sql db create --resource-group EarthCommand_RG --server earthsqlserver2055 --name MarsCommDB --service-objective S2
     ```

  3. **Configure Firewall Rules:** Allow access from the Earth Command Center:
     ```bash
     az sql server firewall-rule create --resource-group EarthCommand_RG --server earthsqlserver2055 --name EarthCommandCenterAccess --start-ip-address 203.0.113.0 --end-ip-address 203.0.113.255
     ```

  4. **Verify Deployment:** Confirm that the SQL Database and firewall rules have been correctly set up:
     ```bash
     az sql db show --resource-group EarthCommand_RG --server earthsqlserver2055 --name MarsCommDB
     ```
</details>

---

### **🔒 Security Checkpoint**

Before proceeding to the next step:
- Verify that the SQL Database is accessible only to authorized IP ranges.
- Review firewall settings to ensure no unauthorized access is permitted.

---

### **Step 2: Configure Database Security Settings**

**Objective:** Strengthen database security by enabling data encryption and setting up advanced threat protection features.

**Details:**
- **Encryption:** Enable Transparent Data Encryption (TDE) for the database.
- **Threat Detection:** Enable Advanced Threat Protection to alert on suspicious activities.

> **Mission Directive:** Ensure encryption is active and configure alerts for any unusual activity to safeguard the database.

---

### **🛠️ Security Configuration Task Brief**

Attempt to configure the security settings using Azure CLI commands based on the details above. If you need help, reveal the solution by expanding the section below.

<details>
  <summary>🚀 Security Configuration Solution for Step 2</summary>

  1. **Enable Transparent Data Encryption (TDE):** Ensure data is encrypted at rest:
     ```bash
     az sql db tde set --resource-group EarthCommand_RG --server earthsqlserver2055 --database MarsCommDB --status Enabled
     ```

  2. **Enable Advanced Threat Protection:** Configure alerts for potential security threats:
     ```bash
     az sql db threat-policy update --resource-group EarthCommand_RG --server earthsqlserver2055 --database MarsCommDB --state Enabled --email-account-admins Enabled --storage-account <YourStorageAccount>
     ```
</details>

---

### **🔒 Security Checkpoint**

Before proceeding:
- Verify that **TDE** is active.
- Ensure Advanced Threat Protection is configured to alert the admin in case of threats.

---

### **Step 3: Set Up Database Monitoring and Performance Metrics**

**Objective:** Integrate monitoring tools to track database performance and capture any anomalies.

**Details:**
- **Monitoring Service:** Enable Azure Monitor and Log Analytics for database activity.
- **Alerts:** Configure alerts for high CPU usage and unusual query response times.

> **Mission Directive:** Ensure monitoring is enabled to capture data performance metrics and to promptly notify of any performance issues.

---

### **🛠️ Monitoring Configuration Task Brief**

Attempt to enable monitoring and alerting for the database using Azure CLI commands based on the details above. If you need guidance, reveal the solution by expanding the section below.

<details>
  <summary>🚀 Monitoring and Alerts Solution for Step 3</summary>

  1. **Set Up Log Analytics Workspace:** Create a workspace to collect monitoring data:
     ```bash
     az monitor log-analytics workspace create --resource-group EarthCommand_RG --workspace-name EarthData_Workspace --location centralus
     ```

  2. **Enable Monitoring for the SQL Database:** Link the database to Azure Monitor:
     ```bash
     az monitor diagnostic-settings create --resource "/subscriptions/<SubscriptionID>/resourceGroups/EarthCommand_RG/providers/Microsoft.Sql/servers/earthsqlserver2055/databases/MarsCommDB" --workspace EarthData_Workspace --name EarthDataMonitor --metrics "allMetrics"
     ```

  3. **Set Up Alert for High CPU Usage:** Configure an alert for CPU usage exceeding 80%:
     ```bash
     az monitor metrics alert create --resource-group EarthCommand_RG --name HighCPUAlert --scopes "/subscriptions/<SubscriptionID>/resourceGroups/EarthCommand_RG/providers/Microsoft.Sql/servers/earthsqlserver2055/databases/MarsCommDB" --condition "avg CPU > 80" --window-size 5m --evaluation-frequency 1m
     ```
</details>

---

### **🔒 Security Checkpoint**

Before concluding the mission:
- Confirm that monitoring and alerts are configured correctly.
- Ensure that alerts are set up to notify the admin in case of anomalies.

---

### **Step 4: Test Database Connectivity and Performance**

**Objective:** The final step is to verify that the database is operational, secure, and performing as expected under simulated load conditions.

**Details:**
- **Connectivity Test:** Confirm the database can be accessed securely from authorized sources.
- **Load Testing:** Run a performance test to simulate Mars-Earth communication load.

> **Mission Directive:** Ensure that the database can handle expected traffic volumes and that performance remains optimal under load.

---

### **🛠️ Testing Task Brief**

Attempt to run connectivity and performance tests. If you need help, reveal the solution by expanding the section below.

<details>
  <summary>🚀 Testing Solution for Step 4</summary>

  1. **Connectivity Test:** Verify the database can be accessed from Earth Command Center:
     ```bash
     # Use a SQL client or script to connect to the database and check connectivity
     ```

  2. **Simulate Load Test:** Use Azure tools or external testing scripts to simulate database load:
     ```bash
     # Run a load testing script targeting MarsCommDB to simulate real-world traffic
     ```
</details>

---

### **🔒 Security Checkpoint**

Before concluding:
- Confirm that connectivity is secured.
- Ensure performance tests meet operational benchmarks.

---
