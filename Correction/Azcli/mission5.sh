az group create --name MarsAks_RG --location "francecentral" --tags asset_owner="$(az account show --query 'user.name' -o tsv)" asset_project_desc="Phoenix Mission mars" asset_project_start="2024-10-16" asset_project_end="2025-05-05"



az network vnet create --name MarsAksVNet --resource-group MarsAks_RG --address-prefix "10.1.0.0/16" --location "francecentral"



az network vnet subnet create --name MarsAksSubnet --vnet-name MarsAksVNet --resource-group MarsAks_RG --address-prefixes "10.1.1.0/24"



az monitor log-analytics workspace create --resource-group MarsAks_RG --location "francecentral" --name MarsAKSLogWorkspace --sku PerGB2018



az aks create --name MarsAKSCluster --resource-group MarsAks_RG --location "francecentral" --dns-name-prefix "marsaks" --node-count 3 --node-vm-size "Standard_DS3_v2" --vnet-subnet-id "$(az network vnet subnet show --name MarsAksSubnet --vnet-name MarsAksVNet --resource-group MarsAks_RG --query id -o tsv)" --enable-managed-identity --network-plugin azure --network-policy azure --tags asset_owner="$(az account show --query 'user.name' -o tsv)" asset_project_desc="Phoenix Mission mars" asset_project_start="2024-10-16" asset_project_end="2025-12-31" availability1=1 availability2=15 maintenance1="monday" maintenance2="friday" shutdownaftermaintenance="no" barcode="${barcode}" autostart="no" Auto-shutdown="no" autoshutdown="no"



az aks nodepool add --cluster-name MarsAKSCluster --resource-group MarsAks_RG --name batchpool --node-count 1 --node-vm-size "Standard_DS2_v2" --labels purpose=batch-jobs



az aks get-credentials --resource-group MarsAks_RG --name MarsAKSCluster

# ------------------------------------------------------------------------------------------------------------

# az aks show --resource-group MarsAks_RG --name MarsAKSCluster --query name -o tsv

# ------------------------------------------------------------------------------------------------------------

# az aks show --resource-group MarsAks_RG --name MarsAKSCluster --query "kubeConfig" -o tsv


