# 🛰️ **Mission 1: Earth Infrastructure Deployment** - _Step 1: Establish the Foundation_

**Mission Date**: 2055, _Earth Command Center_

---

### **Mission Overview**

In this mission, you will complete a series of critical steps to establish Earth’s core infrastructure for secure and efficient communication with the Martian outpost. This infrastructure will serve as the backbone of Earth-Mars operations, ensuring resilient and secure systems that support humanity’s interplanetary mission.

---

## **Step 1: Deploy the Resource Group – Foundation of Earth’s Operations**

**Objective:** The first step is to create a **Resource Group** to house all essential Earth-based infrastructure. This Resource Group is fundamental for organizing and managing the resources that will support ongoing Mars-Earth collaboration.

**Details:**

- **Resource Group Name:** EarthCommand_RG
- **Location:** francecentral (optimized for real-time Mars-Earth communication)
- **Tags:** asset_owner, asset_project_desc, asset_project_end

> **Mission Directive:** Ensure that the Resource Group is secure and appropriately tagged to facilitate tracking and management. Every resource within this group will play a role in safeguarding communication links and operational systems.

<details>
  <summary>🚀 Step 1 Deployment Solution</summary>

1. **Authenticate to Azure CLI:**
   Begin by establishing a secure session with Azure:

   ```bash
   az login
   ```

2. **Retrieve the Subcription id** Use the Azure CLI to deploy your Resource Group:
   ```bash
   az account set --subscription "The SUBCRIPTION ID FROM CGI"
   ```

</details>

## Step 2: Configure the Virtual Network (VNet) – Secure Communications Between Mars and Earth

**Objective**: Create a Virtual Network (VNet) to ensure secure and isolated communications between Mars's resources and operations on Mars.

**Details**:

- **VNet Name**: Mars_VNet
- **Location**: Central US (to minimize latency)
- **CIDR Address**: 10.0.0.0/16 (allowing for multiple subnets)

<details>
  <summary>🚀 Step 2 create resource group - Correction</summary>
  
  1. **Ensure the provider** 
  ```hcl
  provider "azurerm" {
    features {}
    subscription_id = "xxxxxxx"
  }
  ```

2. **Create the resource group**

```hcl
resource "azurerm_resource_group" "Mars_command_rg" {
  name     = "MarsCommand_RG"
  location = "Central US"
  tags = {
    Mission = "Phoenix"
    Priority = "Alpha"
  }
}
```

</details>

## Step 3: Configure the Virtual Network (VNet) – Secure Communications Between Earth and Mars

**Objective**: Create a Virtual Network (VNet) to ensure secure and isolated communications between Earth's resources and operations on Mars.

**Details**:

- **VNet Name**: EarthMars_VNet
- **Location**: Central US (to minimize latency)
- **CIDR Address**: 10.0.0.0/16 (allowing for multiple subnets)

<details>
  <summary>🌍 Step 3 create virtual network - Correction</summary>

1. **Create the Virtual Network**

```hcl
resource "azurerm_virtual_network" "earth_mars_vnet" {
  name                = "EarthMars_VNet"
  location            = azurerm_resource_group.Earth_command_rg.location
  resource_group_name = azurerm_resource_group.Earth_command_rg.name
  address_space       = ["10.0.0.0/16"]
}
```

</details>

## Step 4: Implement Security Rules – Protecting Traffic with Network Security Groups (NSGs)

**Objective**: Establish Network Security Groups (NSGs) to control inbound and outbound traffic for your resources, enhancing the security of Earth-Mars communications.

**Details**:

- **NSG Name**: EarthMars_NSG
- **Associated VNet**: EarthMars_VNet
- **Inbound Security Rules**:
  - Allow SSH access from Earth Command Center (IP range: 203.0.113.0/24)
  - Allow RDP access from authorized personnel (IP range: 203.0.113.0/24)
- **Outbound Security Rules**:
  - Allow all outbound traffic to enable communication with Martian resources.
  - Deny all other outbound traffic by default.

<details>
  <summary>🔒 Step 4 create network security group and rules - Correction</summary>

1. **Create the Network Security Group**

```hcl
resource "azurerm_network_security_group" "earth_mars_nsg" {
  name                = "EarthMars_NSG"
  location            = azurerm_resource_group.earth_command_rg.location
  resource_group_name = azurerm_resource_group.earth_command_rg.name
}
```

2. **Inbound Rule - Allow SSH**

```hcl
resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "Allow-SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "203.0.113.0/24"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.earth_mars_nsg.name
  resource_group_name         = azurerm_resource_group.earth_command_rg.name
}
```

3. **Inbound Rule - Allow RDP**

```hcl
resource "azurerm_network_security_rule" "allow_rdp" {
  name                        = "Allow-RDP"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "203.0.113.0/24"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.earth_mars_nsg.name
  resource_group_name         = azurerm_resource_group.earth_command_rg.name
}
```

4. **Outbound Rule - Allow All Outbound**

```hcl
resource "azurerm_network_security_rule" "allow_all_outbound" {
  name                        = "Allow-All-Outbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.earth_mars_nsg.name
  resource_group_name         = azurerm_resource_group.earth_command_rg.name
}
```

</details>

## Step 5: Establish a Secure Network Infrastructure

**Objective**: Set up a secure network infrastructure to facilitate communication between Earth and Mars.

**Details**:

- **Network Name**: MarsComm_Network
- **Address Space**: Define the IP address range (e.g., 10.1.0.0/16).
- **Subnets**: Create subnets for different purposes (e.g., public and private subnets).

<details>
  <summary>🌐 Step 5 define secure network infrastructure - Correction</summary>

1. **Create the Virtual Network**

```hcl
resource "azurerm_virtual_network" "mars_comm_network" {
  name                = "MarsComm_Network"
  location            = azurerm_resource_group.earth_command_rg.location
  resource_group_name = azurerm_resource_group.earth_command_rg.name
  address_space       = ["10.1.0.0/16"]
}
```

2. **Create the Public Subnet**

```hcl
resource "azurerm_subnet" "public_subnet" {
  name                 = "PublicSubnet"
  resource_group_name  = azurerm_resource_group.earth_command_rg.name
  virtual_network_name = azurerm_virtual_network.mars_comm_network.name
  address_prefixes     = ["10.1.1.0/24"]
}
```

3. **Create the Private Subnet**

```hcl
resource "azurerm_subnet" "private_subnet" {
  name                 = "PrivateSubnet"
  resource_group_name  = azurerm_resource_group.earth_command_rg.name
  virtual_network_name = azurerm_virtual_network.mars_comm_network.name
  address_prefixes     = ["10.1.2.0/24"]
}
```
</details>

## Step 6: Create Virtual Machine (Mars VM)

**Objective**: Deploy a Linux virtual machine (VM) in the secure network infrastructure to support Mars communication.

**Details**:

- **VM Name**: MarsVM
- **Location**: Same as the Mars resource group
- **Network Interface**: Connect the VM to the previously created subnets
- **Tags**: Add metadata to the VM to track project details and maintenance parameters:
  - `asset_owner`: The email address of the asset owner (`var.email`)
  - `asset_project_desc`: "Phoenix Mission mars"
  - `asset_project_start`: "start"
  - `asset_project_end`: "end"
  - `availability1`: `1`
  - `availability2`: `15`
  - `maintenance1`: "monday"
  - `maintenance2`: "friday"
  - `shutdownaftermaintenance`: "no"
  - `barcode`: The barcode value (`var.barcode`)
  - `autostart`: "no"
  - `Auto-shutdown`: "no"
  - `autoshutdown`: "no"

<details>
  <summary>💻 Step 6 create virtual machine - Code </summary>

  ```hcl
  resource "azurerm_network_interface" "mars_vm_nic" {
    name                = "MarsVM_NIC"
    location            = azurerm_resource_group.mars_command_rg.location
    resource_group_name = azurerm_resource_group.mars_command_rg.name

    ip_configuration {
      name                          = "MarsVM_NIC_Config"
      subnet_id                     = azurerm_subnet.private_subnet.id
      private_ip_address_allocation = "Dynamic"
    }
  }

  resource "azurerm_linux_virtual_machine" "mars_vm" {
    name                  = "MarsVM"
    location              = azurerm_resource_group.mars_command_rg.location
    resource_group_name   = azurerm_resource_group.mars_command_rg.name
    network_interface_ids = [azurerm_network_interface.mars_vm_nic.id]
    size                  = "Standard_B2ms"

    admin_username                  = "ubuntuadmin"
    disable_password_authentication = false
    admin_password                  = var.vm_password_admin

    source_image_reference {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }

    identity {
      type = "SystemAssigned"
    }

    os_disk {
      name                 = "MarsVM_OSDisk"
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    tags = {
      asset_owner              = var.email
      asset_project_desc       = "Phoenix Mission mars"
      asset_project_start      = "2024-10-16"
      asset_project_end        = "2025-12-31"
      availability1            = 1
      availability2            = 15
      maintenance1             = "monday"
      maintenance2             = "friday"
      shutdownaftermaintenance = "no"
      barcode                  = var.barcode
      autostart                = "no"
      Auto-shutdown            = "no"
      autoshutdown             = "no"
    }
  }
  ```
  
</details>

