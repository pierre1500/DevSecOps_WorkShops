# **🌌 Mission 4: Backup and Protection for Earth Command**

### **📝 Mission Brief**
In this mission, you are tasked with setting up backup and protection for critical virtual machines in Earth Command. You will configure a backup vault, create a backup policy, and apply that policy to the virtual machine to ensure its protection. This will ensure that Earth Command's data remains safe and recoverable in case of an emergency.

---

## **Objectives**
- Deploy a backup vault for secure and reliable data protection.
- Configure a backup policy for daily VM snapshots.
- Enable backup protection for critical virtual machines.

---

### **Exercises**

#### **Exercise 1: Create a Backup Vault**

Your first task is to create a backup vault to store backup data for Earth Command.  
- Use the `az backup vault create` command to set up the vault.  
- Replace the placeholders in the command with the appropriate values for your setup.

<details>
<summary>💡 Show Solution</summary>

```bash
az backup vault create --name EarthBackupVault --location francecentral --resource-group EarthCommand_RG --sku Standard
```

</details>

---

#### **Exercise 2: Create a Backup Policy**

Next, create a backup policy for Earth Command's virtual machines. This policy will define the frequency and retention of backups.  
- Use the `az backup policy create` command to set up the policy.  
- Replace the placeholders with the appropriate values for your backup policy setup.

<details>
<summary>💡 Show Solution</summary>

```bash
az backup policy create --name EarthVMBackupPolicy --vault-name EarthBackupVault --resource-group EarthCommand_RG --backup-management-type AzureIaasVM --policy "$(az backup policy get-default --vault-name EarthBackupVault --resource-group EarthCommand_RG --query properties -o json | jq '.schedulePolicy.scheduleRunFrequency="Daily" | .schedulePolicy.scheduleRunTimes=["2023-10-21T12:00:00Z"] | .retentionPolicy.dailySchedule.retentionDurationCount=7')"
```

</details>

---

#### **Exercise 3: Enable Backup Protection for the VM**

Finally, enable backup protection for the Earth Command virtual machine using the policy you just created.  
- First, retrieve the VM ID using the `az vm show` command.
- Then, use the `az backup protection enable-for-vm` command to enable backup protection for the virtual machine.

<details>
<summary>💡 Show Solution</summary>

```bash
vm_id=$(az vm show --name EarthVM --resource-group EarthCommand_RG --query id -o tsv)

az backup protection enable-for-vm --vault-name EarthBackupVault --resource-group EarthCommand_RG --vm "$vm_id" --policy-name EarthVMBackupPolicy
```

</details>

---

### **🎖️ Mission Debrief**
With backup protection successfully configured, Earth Command now has reliable protection in place to safeguard its virtual machines. Your efforts will help ensure that critical data remains secure and recoverable, even in the event of a disaster.

🚀 **Next Steps:** Proceed to **[Mission_5.md](mission_5.md)** to continue your training and tackle new challenges.
