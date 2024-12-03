# 🛰️ **Mission 1: Earth Infrastructure Deployment** - _Step 1: Establish the Foundation_

**Mission Date**: 2055, _Earth Command Center_

---

### **Mission Overview**

In this mission, you will complete a series of critical steps to establish Earth’s core infrastructure for secure and efficient communication with the Martian outpost. This infrastructure will serve as the backbone of Earth-Mars operations, ensuring resilient and secure systems that support humanity’s interplanetary mission.

---

### **Step 1: Deploy the Resource Group – Foundation of Earth’s Operations**

**Objective:** As the first step, your mission is to create a **Resource Group** to house all essential Earth-based infrastructure. This Resource Group is fundamental for organizing and managing the resources that will support ongoing Mars-Earth collaboration.

**Details:**

- **Resource Group Name:** EarthCommand_RG
- **Location:** francecentral (optimized for real-time Mars-Earth communication)
- **Tags:** asset_owner, asset_project_desc, asset_project_end

> **Mission Directive:** Ensure that the Resource Group is secure and appropriately tagged to facilitate tracking and management. Every resource within this group will play a role in safeguarding communication links and operational systems.

---

### **🛠️ Deployment Task Brief**

Attempt to deploy the Resource Group yourself using Azure CLI commands based on the details above. If you need guidance, reveal the solution by expanding the section below.

<details>
  <summary>🚀 Step 1 Deployment Solution</summary>

1. **Authenticate to Azure CLI:**
   Begin by establishing a secure session with Azure:

   ```bash
   az login
   ```

2. **Create the Resource Group:** Use the Azure CLI to deploy your Resource Group:

   ```bash
   az group create --name EarthCommand_RG --location centralus --tags asset_owner="Team_Name" asset_project_desc="Mission Phoenix" asset_project_end="YYYY-MM-DD"
   ```

3. **Confirm Deployment:** Verify the Resource Group’s status to ensure successful deployment:
`bash
     az group show --name EarthCommand_RG
     `
</details>

---

### **🔒 Security Checkpoint**

Before moving to the next step:

- Verify that the **Resource Group** is accessible only to authorized personnel.
- Ensure tags are correctly assigned for efficient management.

---

### **Step 2: Configure the Virtual Network (VNet) – Secure Communications Between Earth and Mars**

**Objective:** Create a **Virtual Network (VNet)** to ensure secure and isolated communications between Earth's resources and operations on Mars. This step is essential to guarantee that all interplanetary communications remain protected from potential threats.

**Details:**

- **VNet Name:** EarthMars_VNet
- **Location:** Central US (to minimize latency)
- **CIDR Address:** 10.0.0.0/16 (allowing for multiple subnets)

> **Mission Directive:** Ensure that the VNet is configured to allow only necessary connections between Earth's resources and those on Mars.

---

### **🛠️ VNet Configuration Task Brief**

Attempt to configure the VNet yourself using Azure CLI commands based on the details above. If you need help, reveal the solution by expanding the section below.

<details>
  <summary>🚀 VNet Configuration Solution for Step 2</summary>

1. **Create the Virtual Network:** Use Azure CLI to create the VNet:

   ```bash
   az network vnet create --name EarthMars_VNet --resource-group EarthCommand_RG --location centralus --address-prefix 10.0.0.0/16
   ```

2. **Verify the VNet Configuration:** Ensure that the VNet was created successfully:
   ```bash
   az network vnet show --name EarthMars_VNet --resource-group EarthCommand_RG
   ```

</details>

---

### **🔒 Security Checkpoint**

Before proceeding to the next step:

- Ensure that the VNet is isolated from unsecured external networks.
- Configure security rules to control inbound and outbound traffic.

---

### **Step 3: Implement Security Rules – Protecting Traffic with Network Security Groups (NSGs)**

**Objective:** Establish Network Security Groups (NSGs) to control inbound and outbound traffic for your resources. This step is critical to ensure that only legitimate traffic can access your Virtual Network and its associated resources, enhancing the security of Earth-Mars communications.

**Details:**

- **NSG Name:** EarthMars_NSG
- **Associated VNet:** EarthMars_VNet
- **Inbound Security Rules:**
  - Allow SSH access from the Earth Command Center (e.g., IP address range: `203.0.113.0/24`).
  - Allow RDP access from authorized personnel (e.g., IP address range: `203.0.113.0/24`).
- **Outbound Security Rules:**
  - Allow all outbound traffic to enable communications with Martian resources.
  - Deny all other outbound traffic by default.

> **Mission Directive:** Ensure that the NSG is applied to the EarthMars_VNet to enforce these rules effectively.

---

### **🛠️ NSG Configuration Task Brief**

Attempt to configure the NSG yourself using Azure CLI commands based on the details above. If you need guidance, reveal the solution by expanding the section below.

<details>
  <summary>🚀 NSG Configuration Solution for Step 3</summary>

1. **Create the Network Security Group:** Use Azure CLI to create the NSG:

   ```bash
   az network nsg create --resource-group EarthCommand_RG --name EarthMars_NSG --location centralus
   ```

2. **Define Inbound Security Rules:** Configure rules to allow SSH and RDP access:

   ```bash
   az network nsg rule create --resource-group EarthCommand_RG --nsg-name EarthMars_NSG --name Allow-SSH --protocol tcp --priority 100 --destination-port-range 22 --source-address-prefix 203.0.113.0/24 --access Allow --direction Inbound
   ```

   ```bash
   az network nsg rule create --resource-group EarthCommand_RG --nsg-name EarthMars_NSG --name Allow-RDP --protocol tcp --priority 110 --destination-port-range 3389 --source-address-prefix 203.0.113.0/24 --access Allow --direction Inbound
   ```

3. **Define Outbound Security Rules:** Allow all outbound traffic while denying all others:

   ```bash
   az network nsg rule create --resource-group EarthCommand_RG --nsg-name EarthMars_NSG --name Allow-All-Outbound --protocol '*' --priority 100 --access Allow --direction Outbound
   ```

   ```bash
   az network nsg rule create --resource-group EarthCommand_RG --nsg-name EarthMars_NSG --name Deny-All-Outbound --protocol '*' --priority 200 --access Deny --direction Outbound
   ```

4. **Associate the NSG with the VNet:** Apply the NSG to the EarthMars_VNet:

   ```bash
   az network vnet update --resource-group EarthCommand_RG --name EarthMars_VNet --network-security-group EarthMars_NSG
   ```

5. **Verify NSG Configuration:** Check that the NSG has been correctly applied:
   ```bash
   az network nsg show --resource-group EarthCommand_RG --name EarthMars_NSG
   ```

</details>

---

### **🔒 Security Checkpoint**

Before proceeding to the next step:

- Review the NSG rules to ensure they align with your security requirements.
- Confirm that only authorized IP ranges are allowed access.


### **Step 4: Deploy the Virtual Machine (VM)**

**Objective:** The final step in establishing a secure network infrastructure is to deploy a **Virtual Machine (VM)** that will serve as a management server for Earth operations. This VM will handle critical applications and processes needed for Earth-Mars communications.

**Details:**

- **VM Name:** EarthOps_VM
- **Resource Group:** EarthCommand_RG
- **Image:** Ubuntu 20.04 LTS (for its reliability and support)
- **VM Size:** Standard D2s v3 (sufficient for managing operations)
- **Location:** Central US
- **Network Interface:** Connect to the **EarthMars_VNet** created earlier.
- **Admin Username:** azureuser
- **Admin Password:** _Ensure that the password complies with Azure's complexity requirements._

> **Mission Directive:** Ensure that the VM is configured for secure access and is monitored for performance and security.

---

### **🛠️ VM Deployment Task Brief**

Attempt to deploy the VM yourself using Azure CLI commands based on the details above. If you need help, reveal the solution by expanding the section below.

<details>
  <summary>🚀 VM Deployment Solution for Step 6</summary>

1. **Create the Virtual Network Interface:** Before creating the VM, set up a network interface that connects to the VNet:

   ```bash
   az network nic create --resource-group EarthCommand_RG --name EarthOps_NIC --vnet-name EarthMars_VNet --subnet default
   ```

2. **Deploy the Virtual Machine:** Use Azure CLI to create the VM with the specified configuration:

   ```bash
   az vm create --resource-group EarthCommand_RG --name EarthOps_VM --image UbuntuLTS --size Standard_D2s_v3 --admin-username azureuser --admin-password '<YourComplexPassword>' --nics EarthOps_NIC --location centralus
   ```

3. **Open Required Ports:** Allow SSH access to the VM:

   ```bash
   az vm open-port --port 22 --resource-group EarthCommand_RG --name EarthOps_VM
   ```

4. **Verify VM Deployment:** Check the status of the VM to ensure it was created successfully:
   ```bash
   az vm show --resource-group EarthCommand_RG --name EarthOps_VM
   ```

</details>

---

### **🔒 Security Checkpoint**

Before concluding your mission:

- Ensure that the VM has the latest security updates and patches applied.
- Verify that access to the VM is restricted to authorized personnel only.
- Configure monitoring on the VM to detect any unusual activities.
