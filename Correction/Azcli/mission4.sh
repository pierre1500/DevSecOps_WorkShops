az backup vault create --name EarthBackupVault --location francecentral --resource-group EarthCommand_RG --sku Standard


az backup policy create --name EarthVMBackupPolicy --vault-name EarthBackupVault --resource-group EarthCommand_RG --backup-management-type AzureIaasVM --policy "$(az backup policy get-default --vault-name EarthBackupVault --resource-group EarthCommand_RG --query properties -o json | jq '.schedulePolicy.scheduleRunFrequency="Daily" | .schedulePolicy.scheduleRunTimes=["2023-10-21T12:00:00Z"] | .retentionPolicy.dailySchedule.retentionDurationCount=7')"


vm_id=$(az vm show --name EarthVM --resource-group EarthCommand_RG --query id -o tsv)

az backup protection enable-for-vm --vault-name EarthBackupVault --resource-group EarthCommand_RG --vm "$vm_id" --policy-name EarthVMBackupPolicy

