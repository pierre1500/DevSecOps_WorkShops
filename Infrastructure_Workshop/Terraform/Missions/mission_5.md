# 🛰️ **Mission 5: Mars Command Center AKS Deployment** - Scalable cluster Operations_

**Mission Date**: 2055, _Mars Command Center_

---

### **Mission Overview**

In Mission 5, we enhance the Mars Data Systems infrastructure by deploying an **Azure Kubernetes Service (AKS)** cluster. This service provides scalable and managed container orchestration for Mars operations, supporting data processing, analysis, and communication tasks for the Mars Command Center.

---

## **Step 1: Deploy Azure Kubernetes Service for Mars Command Center**

**Objective:** Deploy an **Azure Kubernetes Service (AKS)** cluster to support containerized workloads crucial for Mars data processing and interplanetary communications.

**Details:**

- **Resource Group:** MarsAks_RG
- **Cluster Name:** MarsAKSCluster
- **Location:** France Central
- **Tags:**
  - **Owner:** Maxime Gaspard
  - **Project:** Phoenix Mission Mars

> **Mission Directive:** Ensure the AKS cluster is deployed with the appropriate scaling and network configuration for secure and efficient operations.

---

### **🚀 Step 1 - Define Resource Group and Virtual Network**

#### Terraform Configuration:

<details>
    <summary> Correction below</summary>

  ```hcl
   resource "azurerm_resource_group" "aks_rg_mars" {
     name     = "MarsAks_RG"
     location = "france central"
     tags = {
       asset_owner         = "maxime.gaspard@cgi.com"
       asset_project_desc  = "Phoenix Mission Mars"
       asset_project_start = "2024-10-16"
     }
   }
   ```
</details>

## **Step 2: Define Virtual Network and Subnet for AKS Communication**

**Objective:** Create a **Virtual Network** and **Subnet** to provide network isolation and connectivity for the Mars AKS cluster.

#### Terraform Configuration:

<details>
    <summary>Correction below </summary>
</details>

```hcl
resource "azurerm_virtual_network" "aks_vnet" {
  name                = "MarsAksVNet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.aks_rg_mars.location
  resource_group_name = azurerm_resource_group.aks_rg_mars.name
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "MarsAksSubnet"
  resource_group_name  = azurerm_resource_group.aks_rg_mars.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}
```

## **Step 3: Define AKS Cluster for Mars Operations**

**Objective:** Deploy an **Azure Kubernetes Service (AKS) Cluster** for managing Mars mission workloads with scalable and secure infrastructure.

#### Terraform Configuration: watch the correction

<details>
    <summary>Correction below </summary>
    ```hcl
    resource "azurerm_kubernetes_cluster" "mars_aks_cluster" {
    name                = "MarsAKSCluster"
    location            = azurerm_resource_group.aks_rg_mars.location
    resource_group_name = azurerm_resource_group.aks_rg_mars.name
    dns_prefix          = "marsaks"

    default_node_pool {
        name           = "primary"
        node_count     = 3
        vm_size        = "Standard_DS3_v2"
        vnet_subnet_id = azurerm_subnet.aks_subnet.id
        min_count      = 2
        max_count      = 5
    }

    lifecycle {
        ignore_changes = [default_node_pool.0.node_count]
    }

    identity {
        type = "SystemAssigned"
    }

    network_profile {
        network_plugin    = "azure"
        network_policy    = "azure"
        load_balancer_sku = "standard"
    }

    tags = {
        project = "Phoenix Mission Mars"
        owner   = "Maxime Gaspard"
    }
    }
    ```
</details>



## **Step 4: Define Log Analytics Workspace for AKS Monitoring**

**Objective:** Deploy an **Azure Log Analytics Workspace** to monitor and analyze logs for the AKS cluster, ensuring visibility into operational metrics and security events.

#### Terraform Configuration:


<details>
    <summary>Correction below </summary>
    ```hcl
    resource "azurerm_log_analytics_workspace" "mars_workspace" {
    name                = "MarsAKSLogWorkspace"
    location            = azurerm_resource_group.aks_rg_mars.location
    resource_group_name = azurerm_resource_group.aks_rg_mars.name
    sku                 = "PerGB2018"
    tags = {
        project = "Phoenix Mission Mars"
        owner   = "Maxime Gaspard"
    }
    }
    ```

</details>


