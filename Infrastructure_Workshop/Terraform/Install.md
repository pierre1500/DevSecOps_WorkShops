# 🌍 Installation Guide for Terraform and Azure CLI

This guide covers how to install Terraform and configure Azure CLI for credential management on both Windows and Linux.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installing Terraform on Windows](#installing-terraform-on-windows)
3. [Installing Terraform on Linux](#installing-terraform-on-linux)
4. [Installing Azure CLI](#installing-azure-cli)
5. [Authenticating Terraform with Azure CLI](#authenticating-terraform-with-azure-cli)
6. [Verifying the Installation](#verifying-the-installation)

---

### Prerequisites

- **Windows**: Administrator privileges.
- **Linux**: Root privileges.

Terraform and Azure CLI require the following:

- A 64-bit architecture.
- No additional software dependencies.

---

## Installing Terraform on Windows

1. **Download the Terraform ZIP**:

   - Go to the [Terraform Downloads page](https://www.terraform.io/downloads.html).
   - Download the **Windows 64-bit** zip archive.

2. **Extract the ZIP**:

   - Right-click on the downloaded `.zip` file and choose **Extract All**.
   - Extract the contents to a directory of your choice (e.g., `C:\terraform`).

3. **Add Terraform to System PATH**:

   - Open the **Start Menu** and search for "Environment Variables".
   - Select **Edit the system environment variables**.
   - In the **System Properties** window, click on **Environment Variables...**.
   - Under **System variables**, find and select the `Path` variable, then click **Edit**.
   - Click **New** and enter the path to the directory where you extracted Terraform (e.g., `C:\terraform`).
   - Click **OK** to close all windows.

4. **Verify the Installation**:
   - Open **Command Prompt** and run:
     ```bash
     terraform -v
     ```
   - You should see the Terraform version information if the installation was successful.

---

## Installing Terraform on Linux

1. **Download the Terraform Binary**:

   - Open a terminal and download the latest version of Terraform:
     ```bash
     curl -LO https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)_linux_amd64.zip
     ```

2. **Install Unzip (if not installed)**:

   - Install unzip to extract the downloaded file:
     ```bash
     sudo apt-get install unzip -y        # For Debian/Ubuntu
     sudo yum install unzip -y            # For CentOS/RHEL
     ```

3. **Unzip the Terraform Binary**:

   - Unzip the Terraform package and move it to `/usr/local/bin`:
     ```bash
     unzip terraform_*.zip
     sudo mv terraform /usr/local/bin/
     ```

4. **Set Executable Permissions** (if necessary):

   - Ensure Terraform has the correct permissions:
     ```bash
     sudo chmod +x /usr/local/bin/terraform
     ```

5. **Verify the Installation**:
   - Run the following command to verify the installation:
     ```bash
     terraform -v
     ```
   - You should see the installed Terraform version if everything was successful.

---

## Installing Azure CLI

### Windows

1. **Download the Azure CLI Installer**:

   - Go to the [Azure CLI Downloads page](https://aka.ms/installazurecliwindows) and download the installer.

2. **Run the Installer**:
   - Follow the on-screen instructions to complete the installation.

### Linux

1. **Install via Script**:

   - Open a terminal and run the following command:
     ```bash
     curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash    # For Debian/Ubuntu
     curl -sL https://aka.ms/InstallAzureCLIRpm | sudo bash    # For CentOS/RHEL
     ```

2. **Verify the Installation**:
   - Run the following command to verify:
     ```bash
     az --version
     ```

---

## Authenticating Terraform with Azure CLI

After installing Terraform and Azure CLI, authenticate to your Azure subscription to enable Terraform to manage resources.

1. **Sign in to Azure**:

   - Run the following command in a terminal:
     ```bash
     az login
     ```
   - Follow the on-screen instructions to sign in. After signing in, you will see details about your subscriptions.

2. **Set the Desired Subscription** (if you have multiple subscriptions):

   - To list all subscriptions:
     ```bash
     az account list --output table
     ```
   - Set the active subscription with:
     ```bash
     az account set --subscription "Your Subscription ID or Name"
     ```

3. **Integrate Azure CLI Credentials with Terraform**:
   - In your `main.tf` file or Terraform configuration, set up the Azure provider to use the CLI for authentication:
     ```hcl
     provider "azurerm" {
       features {}
     }
     ```
   - Terraform will now use the credentials from the Azure CLI session.

---

## Verifying the Installation

To ensure that both Terraform and Azure CLI are installed and configured correctly, you can run the following commands:

```bash
terraform -v
az account show
```
