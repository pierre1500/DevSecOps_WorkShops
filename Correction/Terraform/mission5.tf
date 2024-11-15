resource "azurerm_resource_group" "aks_rg_mars" {
  name     = "MarsAks_RG"
  location = "france central"
  tags = {
    asset_owner         = "maxime.gaspard@cgi.com"
    asset_project_desc  = "Phoenix Mission mars"
    asset_project_start = "2024-10-16"
  }
}

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

# analytics 
resource "azurerm_log_analytics_workspace" "mars_workspace" {
  name                = "MarsAKSLogWorkspace"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  sku                 = "PerGB2018"
}

resource "azurerm_kubernetes_cluster_node_pool" "batch_pool" {
  name                  = "batchpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.mars_aks_cluster.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  min_count             = 1
  max_count             = 3
  node_labels = {
    "purpose" = "batch-jobs"
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.mars_aks_cluster.kube_config_raw
  sensitive = true
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.mars_aks_cluster.name
}
