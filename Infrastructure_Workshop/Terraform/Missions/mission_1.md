# 🛰️ **Mission 1: Earth Infrastructure Deployment** - *Step 1: Establish the Foundation*

**Mission Date**: 2055, *Earth Command Center*

---

### **Mission Overview**

In this mission, you will complete a series of critical steps to establish Earth’s core infrastructure for secure and efficient communication with the Martian outpost. This infrastructure will serve as the backbone of Earth-Mars operations, ensuring resilient and secure systems that support humanity’s interplanetary mission.

---

## **Step 1: Deploy the Resource Group – Foundation of Earth’s Operations**

**Objective:** The first step is to create a **Resource Group** to house all essential Earth-based infrastructure. This Resource Group is fundamental for organizing and managing the resources that will support ongoing Mars-Earth collaboration.

**Details:**
- **Resource Group Name:** EarthCommand_RG
- **Location:** Central France (optimized for real-time Mars-Earth communication)
- **Tags:** MissionPhoenix, EarthOps, Priority-Alpha

> **Mission Directive:** Ensure that the Resource Group is secure and appropriately tagged to facilitate tracking and management. Every resource within this group will play a role in safeguarding communication links and operational systems.

```hcl
# Step 1 - Create Resource Group
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "Mars_command_rg" {
  name     = "MarsCommand_RG"
  location = "Central US"
  tags = {
    Mission = "Phoenix"
    Priority = "Alpha"
  }
}

## Step 2: Configure the Virtual Network (VNet) – Secure Communications Between Mars and Earth
**Objective**: Create a Virtual Network (VNet) to ensure secure and isolated communications between Mars's resources and operations on Mars.

**Details**:
- **VNet Name**: Mars_VNet
- **Location**: Central US (to minimize latency)
- **CIDR Address**: 10.0.0.0/16 (allowing for multiple subnets)

```hcl
# Step 2 - Create Virtual Network    
resource "azurerm_virtual_network" "earth_mars_vnet" {
  name                = "EarthMars_VNet"
  location            = azurerm_resource_group.earth_command_rg.location
  resource_group_name = azurerm_resource_group.earth_command_rg.name
  address_space       = ["10.0.0.0/16"]
}


## Step 2: Configure the Virtual Network (VNet) – Secure Communications Between Earth and Mars
**Objective**: Create a Virtual Network (VNet) to ensure secure and isolated communications between Earth's resources and operations on Mars.

**Details**:
- **VNet Name**: EarthMars_VNet
- **Location**: Central US (to minimize latency)
- **CIDR Address**: 10.0.0.0/16 (allowing for multiple subnets)

```hcl
# Step 2 - Create Virtual Network
resource "azurerm_virtual_network" "earth_mars_vnet" {
  name                = "EarthMars_VNet"
  location            = azurerm_resource_group.earth_command_rg.location
  resource_group_name = azurerm_resource_group.earth_command_rg.name
  address_space       = ["10.0.0.0/16"]
}


## Step 3: Implement Security Rules – Protecting Traffic with Network Security Groups (NSGs)
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

```hcl
# Step 3 - Create Network Security Group and Rules
resource "azurerm_network_security_group" "earth_mars_nsg" {
  name                = "EarthMars_NSG"
  location            = azurerm_resource_group.earth_command_rg.location
  resource_group_name = azurerm_resource_group.earth_command_rg.name
}

# Inbound Rule - Allow SSH
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

# Inbound Rule - Allow RDP
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

# Outbound Rule - Allow All Outbound
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


## Step 4: Enable Network Monitoring
**Objective**: Implement monitoring solutions to detect anomalous behaviors on the network and ensure a rapid response in case of issues.

**Details**:
- Integrate Azure Monitor and Azure Network Watcher for real-time analytics.
- Configure alerts for suspicious activities or changes in security rules.

```hcl
# Step 4 - Enable Network Watcher and Monitoring
resource "azurerm_network_watcher" "earth_network_watcher" {
  name                = "Earth_Network_Watcher"
  location            = azurerm_resource_group.earth_command_rg.location
  resource_group_name = azurerm_resource_group.earth_command_rg.name
}

resource "azurerm_log_analytics_workspace" "earth_mars_workspace" {
  name                = "EarthMars_Workspace"
  location            = azurerm_resource_group.earth_command_rg.location
  resource_group_name = azurerm_resource_group.earth_command_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


## Step 5: Establish a Secure Network Infrastructure
**Objective**: Set up a secure network infrastructure to facilitate communication between Earth and Mars.

**Details**:
- **Network Name**: MarsComm_Network
- **Address Space**: Define the IP address range (e.g., 10.1.0.0/16).
- **Subnets**: Create subnets for different purposes (e.g., public and private subnets).

```hcl
# Step 5 - Define Secure Network Infrastructure
resource "azurerm_virtual_network" "mars_comm_network" {
  name                = "MarsComm_Network"
  location            = azurerm_resource_group.earth_command_rg.location
  resource_group_name = azurerm_resource_group.earth_command_rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "public_subnet" {
  name                 = "PublicSubnet"
  resource_group_name  = azurerm_resource_group.earth_command_rg.name
  virtual_network_name = azurerm_virtual_network.mars_comm_network.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "private_subnet" {
  name                 = "PrivateSubnet"
  resource_group_name  = azurerm_resource_group.earth_command_rg.name
  virtual_network_name = azurerm_virtual_network.mars_comm_network.name
  address_prefixes     = ["10.1.2.0/24"]
}