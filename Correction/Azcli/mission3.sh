az keyvault create --name earthtestkvadminusetest2 --location francecentral --resource-group EarthCommand_RG --tenant-id "<tenant_id>" --sku standard --enable-soft-delete true --soft-delete-retention-days 90 --enable-rbac-authorization true --enabled-for-deployment true --enabled-for-disk-encryption true --enabled-for-template-deployment true --tags asset_owner="maxime gaspard" asset_project_desc="Phoenix Mission earth" asset_project_end="01-01-2025"


vm_principal_id=$(az vm show --name EarthVM --resource-group EarthCommand_RG --query "identity.principalId" -o tsv)


az keyvault set-policy --name earthtestkvadminusetest2 --resource-group EarthCommand_RG --tenant-id "<tenant_id>" --object-id "$vm_principal_id" --secret-permissions get list


az keyvault secret set --vault-name earthtestkvadminusetest2 --name sql-admin-password --value "<sql_admin_password>"


az monitor diagnostic-settings create --name EarthDataMonitorKeyVault --resource "$(az keyvault show --name earthtestkvadminusetest2 --resource-group EarthCommand_RG --query id -o tsv)" --workspace "$(az monitor log-analytics workspace show --name EarthLogAnalyticsWorkspace --resource-group EarthCommand_RG --query id -o tsv)" --metrics '[{"category":"AllMetrics","enabled":true}]'


az monitor diagnostic-settings create --name EarthDataMonitorSQL --resource "$(az sql db show --name earthqlserver2055 --server earthqlserver2055 --resource-group EarthCommand_RG --query id -o tsv)" --workspace "$(az monitor log-analytics workspace show --name EarthLogAnalyticsWorkspace --resource-group EarthCommand_RG --query id -o tsv)" --metrics '[{"category":"AllMetrics","enabled":true}]'
