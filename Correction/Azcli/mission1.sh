az group create --name EarthCommand_RG --location francecentral --tags asset_owner="email@test.com" asset_project_desc="Phoenix Mission earth" asset_project_end="2025-12-31"

az network vnet create --name EarthComm_Network --resource-group EarthCommand_RG --location francecentral --address-prefixes 10.1.0.0/16

az network nsg create --name Earth_NSG --resource-group EarthCommand_RG --location francecentral

az network nsg rule create --name Allow-SSH --nsg-name Earth_NSG --resource-group EarthCommand_RG --priority 100 --direction Inbound --access Allow --protocol Tcp --source-port-range "*" --destination-port-range 22 --source-address-prefix 203.0.113.0/24 --destination-address-prefix "*"

az network nsg rule create --name Allow-RDP --nsg-name Earth_NSG --resource-group EarthCommand_RG --priority 110 --direction Inbound --access Allow --protocol Tcp --source-port-range "*" --destination-port-range 3389 --source-address-prefix 203.0.113.0/24 --destination-address-prefix "*"

az network nsg rule create --name Allow-All-Outbound --nsg-name Earth_NSG --resource-group EarthCommand_RG --priority 100 --direction Outbound --access Allow --protocol "*" --source-port-range "*" --destination-port-range "*" --source-address-prefix "*" --destination-address-prefix "*"

az network vnet subnet create --name Earth_PublicSubnet --vnet-name EarthComm_Network --resource-group EarthCommand_RG --address-prefixes 10.1.1.0/24

az network vnet subnet create --name Earth_PrivateSubnet --vnet-name EarthComm_Network --resource-group EarthCommand_RG --address-prefixes 10.1.2.0/24

az network public-ip create --name EarthVM_PublicIP --resource-group EarthCommand_RG --location francecentral --allocation-method Static --sku Standard

az network nic create --name EarthVM_NIC --resource-group EarthCommand_RG --location francecentral --subnet Earth_PublicSubnet --vnet-name EarthComm_Network --public-ip-address EarthVM_PublicIP

az vm create --name EarthVM --resource-group EarthCommand_RG --location francecentral --nics EarthVM_NIC --size Standard_B2ms --image Ubuntu2404 --admin-username ubuntuadmin --admin-password "admin_password123" --tags asset_owner="un email" asset_project_desc="Phoenix Mission earth" asset_project_start="2024-10-16" asset_project_end="2025-12-31" availability1=1 availability2=15 maintenance1=monday maintenance2=friday shutdownaftermaintenance=no barcode="barcode" autostart=no Auto-shutdown=no autoshutdown=no --assign-identity --os-disk-name EarthVM_OSDisk --os-disk-caching ReadWrite --storage-sku Standard_LRS

az network public-ip show --name EarthVM_PublicIP --resource-group EarthCommand_RG --query ipAddress --output tsv
 