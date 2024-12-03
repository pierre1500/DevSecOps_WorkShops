# 🛰️ **Mission 2: Mars Data Systems Deployment** - _Step 1: Establish the Core Database Infrastructure_

**Mission Date**: 2055, _Mars Command Center_

---

### **Mission Overview**

Building on your foundational infrastructure from Mission 2, Mission 3 focuses on deploying a managed database system to support Mars's operations and communications with Earth. This database will be a critical component, storing and managing essential data to facilitate seamless and secure interplanetary communications and operations.

---

## **Step 1: Deploy the Managed Database – Core of Mars Data Operations**

**Objective:** Your first task is to deploy a managed **Azure SQL Database** to handle and secure Mars-Earth data exchanges.

**Details:**

- **Resource Group:** 
- **SQL Server Name:** 
- **Location:** 
- **Database Name:** 
- **Pricing Tier:** 
- **Firewall Rules:** 

> **Mission Directive:** Ensure that the SQL Server and database are secure, and configure access controls to prevent unauthorized access.

<details>
  <summary>🚀 Step 1 - Define Azure SQL Server</summary>

  ```hcl
  resource "azurerm_sql_server" "mars_sql_server" {
  name                         = "marsqlserver2055"
  resource_group_name          = azurerm_resource_group.mars_command_rg.name
  location                     = azurerm_resource_group.mars_command_rg.location
  version                      = "12.0"
  administrator_login          = "azureuser"
  administrator_login_password = "<YourComplexPassword>"
  }

  resource "azurerm_sql_database" "mars_comm_db" {
  name                = "MarsCommDB"
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  location            = azurerm_resource_group.mars_command_rg.location
  server_name         = azurerm_sql_server.mars_sql_server.name
  sku {
      name     = "S2"
      tier     = "Standard"
      capacity = 50
  }
  }

  resource "azurerm_sql_firewall_rule" "mars_command_center_access" {
  name                = "MarsCommandCenterAccess"
  resource_group_name = azurerm_resource_group.mars_command_rg.name
  server_name         = azurerm_sql_server.mars_sql_server.name
  start_ip_address    = "203.0.113.0"
  end_ip_address      = "203.0.113.255"
  }
  ```

</details>

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

Attempt to configure the security settings using Terraform based on the details above. If you need help, reveal the solution by expanding the section below.

<details>
  <summary>🚀 Security Configuration Solution for Step 2</summary>

1. **Enable Transparent Data Encryption (TDE):** Ensure data is encrypted at rest:

  ```hcl
  resource "azurerm_mssql_database" "mars_comm_db" {
    name           = "MarsCommDB"
    server_id      = azurerm_mssql_server.earth_sql_server.id
    transparent_data_encryption {
      status = "Enabled"
    }
  }
  ```

2. **Enable Advanced Threat Protection:** Configure alerts for potential security threats:

  ```hcl
  resource "azurerm_mssql_server_security_alert_policy" "mars_comm_security_alert" {
    server_id                    = azurerm_mssql_server.earth_sql_server.id
    state                        = "Enabled"
    email_account_admins         = trueaq
    storage_endpoint             = azurerm_storage_account.earth_storage.primary_blob_endpoint
    storage_account_access_key   = azurerm_storage_account.earth_storage.primary_access_key
  }
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

Attempt to enable monitoring and alerting for the database using Terraform based on the details above. If you need guidance, reveal the solution by expanding the section below.

<details>
  <summary>🚀 Monitoring and Alerts Solution for Step 3</summary>

1. **Set Up Log Analytics Workspace:** Create a workspace to collect monitoring data:

  ```hcl
  resource "azurerm_log_analytics_workspace" "earth_data_workspace" {
    name                = "EarthData_Workspace"
    location            = "Central US"
    resource_group_name = azurerm_resource_group.Earth_command_rg.name
    sku                 = "PerGB2018"
  }
  ```

2. **Enable Monitoring for the SQL Database:** Link the database to Azure Monitor:

  ```hcl
  resource "azurerm_monitor_diagnostic_setting" "earth_data_monitor" {
    name                       = "EarthDataMonitor"
    target_resource_id         = azurerm_mssql_database.mars_comm_db.id
    log_analytics_workspace_id = azurerm_log_analytics_workspace.earth_data_workspace.id

    metric {
      category = "AllMetrics"
      enabled  = true
    }

    log {
      category = "SQLInsights"
      enabled  = true
    }
  }
  ```

3. **Set Up Alert for High CPU Usage:** Configure an alert for CPU usage exceeding 80%:

  ```hcl
  resource "azurerm_monitor_metric_alert" "high_cpu_alert" {
    name                = "HighCPUAlert"
    resource_group_name = azurerm_resource_group.Earth_command_rg.name
    scopes              = [azurerm_mssql_database.mars_comm_db.id]
    description         = "Alert for CPU usage exceeding 80%"
    criteria {
      aggregation        = "Average"
      metric_name        = "cpu_percent"
      operator           = "GreaterThan"
      threshold          = 80
    }
    frequency           = "PT1M"
    window_size         = "PT5M"
  }
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

1. **Connectivity Test:** Verify the database can be accessed from Earth Command Center. You can configure a Terraform resource to test connectivity using Azure SQL's built-in capabilities and output results:

  ```hcl
  resource "azurerm_mssql_firewall_rule" "earth_command_center_access" {
    name                = "EarthCommandCenterAccess"
    resource_group_name = azurerm_resource_group.Earth_command_rg.name
    server_name         = azurerm_mssql_server.earth_sql_server.name
    start_ip_address    = "203.0.113.0"
    end_ip_address      = "203.0.113.0"
  }

  output "database_connection_test" {
    value = "Database connection test: Access granted for Earth Command Center IP range."
  }
  ```

2. **Simulate Load Test:** While Terraform does not natively support load testing, you can set up load testing services or scripts as part of the infrastructure. Here’s a
