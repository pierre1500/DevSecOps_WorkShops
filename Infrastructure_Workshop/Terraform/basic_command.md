# Terraform Commands - Basic Guide

This README provides a list of basic Terraform commands to help you get started with managing infrastructure as code. Each section outlines a common use case along with the relevant commands.

---

## Prerequisites

- Install Terraform on your machine: https://www.terraform.io/downloads.html
- Initialize your Terraform project (`terraform init`).
- Create a `.tf` configuration file to define your infrastructure.

---

## Terraform Commands

### 1. **Initialize Terraform Working Directory**

Before you can use Terraform, you must initialize your working directory. This command downloads the necessary provider plugins and sets up the working directory for Terraform.

```bash
terraform init
```

---

### 2. **Create an Execution Plan**

This command creates an execution plan, showing what Terraform will do when you apply it. It allows you to preview changes before applying them.

```bash
terraform plan
```

You can also save the plan to a file for later use:

```bash
terraform plan -out=<filename>
```

---

### 3. **Apply Changes**

Once you are satisfied with the plan, apply the changes to your infrastructure. Terraform will create, modify, or destroy resources to match the desired state defined in your configuration.

```bash
terraform apply
```

To apply a saved plan:

```bash
terraform apply <filename>
```

---

### 4. **Destroy Infrastructure**

To destroy the resources defined in your configuration, use the `terraform destroy` command. This will remove all the infrastructure Terraform has created.

```bash
terraform destroy
```

To destroy resources based on a specific plan file:

```bash
terraform destroy -plan=<filename>
```

---

### 5. **Show Current State**

To display the current state of the infrastructure Terraform is managing, use the following command:

```bash
terraform show
```

This will display the latest state of resources managed by Terraform.

---

### 6. **Validate Configuration Files**

Validate the configuration files to check for syntax or configuration errors.

```bash
terraform validate
```

This command checks the `.tf` files for correctness but does not interact with the infrastructure.

---

### 7. **Generate Execution Plan for Destroy**

If you want to see what Terraform will destroy before actually doing it, you can create a plan specifically for destruction:

```bash
terraform plan -destroy -out=destroy.tfplan
```

To apply the destruction plan:

```bash
terraform apply destroy.tfplan
```

---

### 8. **List Resources**

To list all the resources managed by Terraform in your configuration, use:

```bash
terraform state list
```

---

### 9. **Show Detailed State of a Resource**

If you need to inspect a specific resource in your state, use:

```bash
terraform state show <resource_name>
```

Replace `<resource_name>` with the actual name of the resource you want to inspect.

---

### 10. **Get Provider Plugins**

To install the required provider plugins for your configuration (e.g., AWS, Azure), use the following command:

```bash
terraform providers
```

---

### 11. **Upgrade Terraform Version**

To upgrade to the latest version of Terraform, run:

```bash
terraform init -upgrade
```

---

## Additional Commands

### 1. **Refresh State**

Update the local state file with the real-time state of the infrastructure.

```bash
terraform refresh
```

---

### 2. **Output Values**

You can output the values of specific variables or resources:

```bash
terraform output <output_name>
```

---

## Conclusion

These are the basic Terraform commands to help you get started with managing infrastructure. For more detailed information, refer to the [official Terraform documentation](https://www.terraform.io/docs).

---

## Notes

- Always use `terraform plan` before applying changes, especially in production environments.
- Store your Terraform state files securely (e.g., in a remote backend) to avoid accidental deletion or corruption.
