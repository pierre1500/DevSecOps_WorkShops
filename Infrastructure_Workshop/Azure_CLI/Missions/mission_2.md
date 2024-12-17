# **🌌 Mission 2: Database and Monitoring Setup for Earth Command**

### **📝 Mission Brief**
As a member of Earth Command, you are tasked with setting up the necessary database infrastructure and enabling monitoring for mission-critical data. This mission involves deploying an SQL Server, configuring its firewall, setting up a private endpoint, and enabling diagnostic logging. Your actions will ensure that Earth Command operations remain secure and resilient in the face of potential incidents.

---

## **Objectives**
- Deploy an SQL Server and Database.
- Configure firewall rules for secure access.
- Set up a private DNS zone and endpoint for secure database communication.
- Enable monitoring and diagnostics to track performance and health.

---

### **Exercises**

#### **Exercise 1: Create the SQL Server**
Your first task is to create the SQL Server that will host Earth Command's mission-critical database.

<details>
<summary>💡 Show Solution</summary>

```bash
az sql server create --name earthqlserver2055 --resource-group EarthCommand_RG --location francecentral --admin-user azureuser --admin-password "strong sql password" --version 12.0
```

</details>

---

#### **Exercise 2: Create the Database**
Next, create a database on the newly deployed SQL Server to handle the storage needs for Earth Command.

<details>
<summary>💡 Show Solution</summary>

```bash
az sql db create --name earthqlserver2055 --server earthqlserver2055 --resource-group EarthCommand_RG --edition GeneralPurpose --service-objective GP_S_Gen5_1 --max-size 32GB --zone-redundant false --collation SQL_Latin1_General_CP1_CI_AS
```

</details>

---

#### **Exercise 3: Set Firewall Rules for Database Access**
Ensure that only authorized IP addresses can access the SQL Server by configuring firewall rules.

<details>
<summary>💡 Show Solution</summary>

```bash
az sql server firewall-rule create --name EarthCommandCenterAccess --server earthqlserver2055 --resource-group EarthCommand_RG --start-ip-address 203.0.113.0 --end-ip-address 203.0.113.255
```

</details>

---

#### **Exercise 4: Set Up Private DNS Zone**
Set up a private DNS zone to enable secure and consistent name resolution for your database services.

<details>
<summary>💡 Show Solution</summary>

```bash
az network private-dns zone create --name privatelink.database.windows.net --resource-group EarthCommand_RG
```

</details>

---

#### **Exercise 5: Create a Private Endpoint for Secure Database Access**
Now, create a private endpoint to securely connect to the database over the private network.

<details>
<summary>💡 Show Solution</summary>

```bash
az network private-endpoint create --name earth-private-endpoint --resource-group EarthCommand_RG --location francecentral --subnet Earth_PrivateSubnet --private-connection-resource-id "$(az sql server show --name earthqlserver2055 --resource-group EarthCommand_RG --query id -o tsv)" --connection-name database-connection --group-ids sqlServer
```

</details>

---

#### **Exercise 6: Set Up Log Analytics Workspace**
Create a Log Analytics workspace to collect and analyze diagnostic data for the database.

<details>
<summary>💡 Show Solution</summary>

```bash
az monitor log-analytics workspace create --name EarthLogAnalyticsWorkspace --resource-group EarthCommand_RG --location francecentral --sku PerGB2018
```

</details>

---

#### **Exercise 7: Configure Diagnostic Settings for SQL Database Monitoring**
Finally, enable monitoring for your database by configuring diagnostic settings to send metrics to the Log Analytics workspace.

<details>
<summary>💡 Show Solution</summary>

```bash
az monitor diagnostic-settings create --name EarthDataMonitor --resource "$(az sql db show --name earthqlserver2055 --server earthqlserver2055 --resource-group EarthCommand_RG --query id -o tsv)" --workspace "$(az monitor log-analytics workspace show --name EarthLogAnalyticsWorkspace --resource-group EarthCommand_RG --query id -o tsv)" --metrics '[{"category":"AllMetrics","enabled":true}]'
```

</details>

---

### **🎖️ Mission Debrief**
With the database and monitoring infrastructure in place, Earth Command is now ready to handle and securely store mission-critical data. Your efforts ensure that the system will remain secure, resilient, and performant as the mission progresses.

🚀 **Next Steps:** Proceed to **[Mission_3.md](mission_3.md)** to continue your training and take on new challenges.
