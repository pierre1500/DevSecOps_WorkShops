az sql server create --name earthqlserver2055 --resource-group EarthCommand_RG --location francecentral --admin-user azureuser --admin-password "K9pLSvU$+K45"



az sql db create --name earthqlserver2055 --server earthqlserver2055 --resource-group EarthCommand_RG --edition GeneralPurpose --service-objective GP_S_Gen5_1 --max-size 32GB --zone-redundant false --collation SQL_Latin1_General_CP1_CI_AS



az sql server firewall-rule create --name EarthCommandCenterAccess --server earthqlserver2055 --resource-group EarthCommand_RG --start-ip-address 203.0.113.0 --end-ip-address 203.0.113.255



az network private-dns zone create --name privatelink.database.windows.net --resource-group EarthCommand_RG



az network private-endpoint create --name earth-private-endpoint --resource-group EarthCommand_RG --location francecentral --subnet Earth_PrivateSubnet --vnet-name EarthComm_Network  --private-connection-resource-id "$(az sql server show --name earthqlserver2055 --resource-group EarthCommand_RG --query id -o tsv)" --connection-name database-connection --group-ids sqlServer



az monitor log-analytics workspace create --name EarthLogAnalyticsWorkspace --resource-group EarthCommand_RG --location francecentral --sku PerGB2018



az monitor diagnostic-settings create --name EarthDataMonitor --resource "$(az sql db show --name earthqlserver2055 --server earthqlserver2055 --resource-group EarthCommand_RG --query id -o tsv)" --workspace "$(az monitor log-analytics workspace show --name EarthLogAnalyticsWorkspace --resource-group EarthCommand_RG --query id -o tsv)" --metrics '[{"category":"AllMetrics","enabled":true}]'
 