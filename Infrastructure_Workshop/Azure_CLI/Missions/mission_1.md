# **🌌 Mission 1: Establishing Earth Command Infrastructure**

**Mission Date**: 2055, _Earth Command Center_

---

### **Mission Overview**

In this mission, you will complete a series of critical steps to establish Earth’s core infrastructure for secure and efficient communication with the Martian outpost. This infrastructure will serve as the backbone of Earth-Mars operations, ensuring resilient and secure systems that support humanity’s interplanetary mission.

---

### **Step 1: Deploy the Resource Group – Foundation of Earth’s Operations**

## **Objectives**

- Create and configure the resource group for the mission.
- Set up a virtual network and subnets for communication.
- Implement robust security measures using Network Security Groups (NSGs).
- Deploy a virtual machine as the cornerstone of Earth Command operations.

---

### **Exercises**

#### **Exercise 1: Create the Resource Group**

Create a dedicated resource group to organize all mission-related resources.  
- The resource group must be named `EarthCommand_RG`.  
- It should be deployed in the `francecentral` region.  
- Use the following tags:  
   - `asset_owner` : Your email address.  
   - `asset_project_desc` : "Phoenix Mission earth".  
   - `asset_project_end` : "2025-12-31".

<details>
<summary>💡 Show Solution</summary>

```bash
az group create --name EarthCommand_RG --location francecentral --tags asset_owner="email@test.com" asset_project_desc="Phoenix Mission earth" asset_project_end="2025-12-31"
```

</details>

---

#### **Exercise 2: Deploy the Virtual Network**

Set up a virtual network to establish communication channels for Earth Command.  
- The virtual network must be named `EarthComm_Network`.  
- It should be deployed in the existing resource group `EarthCommand_RG`.  
- Use the `francecentral` location.  
- Define the address space as `10.1.0.0/16`.

<details>
<summary>💡 Show Solution</summary>

```bash
az network vnet create --name EarthComm_Network --resource-group EarthCommand_RG --location francecentral --address-prefixes 10.1.0.0/16
```

</details>

---

#### **Exercise 3: Configure Network Security**

To ensure the network is secure, create a **Network Security Group (NSG)** and define rules for SSH, RDP, and outbound communication.  

**Step 1:** Create a Network Security Group named `Earth_NSG`.  
- Use the existing resource group `EarthCommand_RG`.  
- Deploy it in the `francecentral` location.

<details>
<summary>💡 Show Solution</summary>

```bash
az network nsg create --name Earth_NSG --resource-group EarthCommand_RG --location francecentral
```

</details>

**Step 2: Add Rules**

1. **Allow SSH:**

<details>
<summary>💡 Show Solution</summary>

```bash
az network nsg rule create --name Allow-SSH --nsg-name Earth_NSG --resource-group EarthCommand_RG --priority 100 --direction Inbound --access Allow --protocol Tcp --source-port-range "*" --destination-port-range 22 --source-address-prefix 203.0.113.0/24 --destination-address-prefix "*"
```

</details>

2. **Allow RDP:**

<details>
<summary>💡 Show Solution</summary>

```bash
az network nsg rule create --name Allow-RDP --nsg-name Earth_NSG --resource-group EarthCommand_RG --priority 110 --direction Inbound --access Allow --protocol Tcp --source-port-range "*" --destination-port-range 3389 --source-address-prefix 203.0.113.0/24 --destination-address-prefix "*"
```

</details>

3. **Allow All Outbound Traffic:**

<details>
<summary>💡 Show Solution</summary>

```bash
az network nsg rule create --name Allow-All-Outbound --nsg-name Earth_NSG --resource-group EarthCommand_RG --priority 100 --direction Outbound --access Allow --protocol "" --source-port-range "" --destination-port-range "" --source-address-prefix "" --destination-address-prefix "*"
```

</details>

---

#### **Exercise 4: Create Subnets**

Divide the virtual network `EarthComm_Network` into public and private subnets.  

1. **Create the Public Subnet:**  
   - Name: `Earth_PublicSubnet`  
   - Address range: `10.1.1.0/24`  

<details>
<summary>💡 Show Solution</summary>

```bash
az network vnet subnet create --name Earth_PublicSubnet --vnet-name EarthComm_Network --resource-group EarthCommand_RG --address-prefixes 10.1.1.0/24
```

</details>

2. **Create Private Subnet:**
    - Name: `Earth_PrivateSubnet`
    - Address range: `10.1.1.0/24`

<details>
<summary>💡 Show Solution</summary>

```bash
az network vnet subnet create --name Earth_PrivateSubnet --vnet-name EarthComm_Network --resource-group EarthCommand_RG --address-prefixes 10.1.2.0/24
```

</details>

---

#### **Exercise 5: Deploy the Virtual Machine**

Deploy the Earth Command Virtual Machine (VM) and ensure it is ready for operations.  

- The VM should be named `EarthVM`.  
- It should be deployed in the `EarthCommand_RG` resource group.  
- Location: `francecentral`.  
- Use the existing NIC `EarthVM_NIC`.  
- VM size: `Standard_B2ms`.  
- Image: `UbuntuLTS`.  
- Set up an admin username `ubuntuadmin` and password `admin_password123`.  
- Add appropriate tags:  
  - `asset_owner`: your email address.  
  - `asset_project_desc`: "Phoenix Mission earth".  
  - `asset_project_start`: "2024-10-16".  
  - `asset_project_end`: "2025-12-31".  

<details>
<summary>💡 Show Solution</summary>

```bash
az vm create --name EarthVM --resource-group EarthCommand_RG --location francecentral --nics EarthVM_NIC --size Standard_B2ms --image UbuntuLTS --admin-username ubuntuadmin --admin-password "admin_password123" --tags asset_owner="un email" asset_project_desc="Phoenix Mission earth" asset_project_start="2024-10-16" asset_project_end="2025-12-31" availability1=1 availability2=15 maintenance1=monday maintenance2=friday shutdownaftermaintenance=no barcode="barcode" autostart=no Auto-shutdown=no autoshutdown=no --assign-identity --os-disk-name EarthVM_OSDisk --os-disk-caching ReadWrite --os-disk-storage-account-type Standard_LRS
```

</details>

---

#### **Exercise 6: Retrieve Public IP Address**

Verify the public IP address of the deployed VM to confirm external access capabilities.

<details>
<summary>💡 Show Solution</summary>

```bash
az network public-ip show --name EarthVM_PublicIP --resource-group EarthCommand_RG --query ipAddress --output tsv
```

</details>

---

### **🎖️ Mission Debrief**

Once you've completed all exercises, you will have established a secure, functional infrastructure for Earth Command. This foundation will support future missions and pave the way for the success of the Phoenix Mission.

🚀 **Next Steps:** Proceed to **[Mission_2.md](mission_2.md)** to continue your training and face new challenges.
