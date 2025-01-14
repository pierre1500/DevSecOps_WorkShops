# **🌌 Mission 5: Azure Kubernetes Service (AKS) Deployment for Mars Command**

### **📝 Mission Brief**
In this mission, you will deploy an Azure Kubernetes Service (AKS) cluster for the Phoenix Mission to Mars. You will set up the necessary resource group, networking, and create the AKS cluster along with a monitoring solution to ensure the cluster is properly managed and maintained. The mission will require you to create the infrastructure, configure the network, and ensure your AKS cluster is operational and secure.

---

## **Objectives**
- Create a resource group and networking resources for AKS.
- Deploy and configure an AKS cluster.
- Set up monitoring to ensure the cluster is operational and secure.

---

## Technical Documentation References
- [Azure Kubernetes Service (AKS) Overview](https://learn.microsoft.com/en-us/azure/aks/intro-kubernetes)
- [AKS Networking Concepts](https://learn.microsoft.com/en-us/azure/aks/concepts-network)
- [AKS Security Concepts](https://learn.microsoft.com/en-us/azure/aks/concepts-security)
- [AKS Node Pools Overview](https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools)
- [Azure CNI Networking in AKS](https://learn.microsoft.com/en-us/azure/aks/configure-azure-cni)
- [AKS Monitoring with Azure Monitor](https://learn.microsoft.com/en-us/azure/aks/monitor-aks)

---

### **Exercises**

#### **Exercise 1: Create a Resource Group**
Your first task is to create a resource group that will contain all the resources for the Mars AKS cluster.

<details>
<summary>💡 Show Solution</summary>

```bash
az group create --name MarsAks_RG --location "francecentral" --tags asset_owner="$(az account show --query 'user.name' -o tsv)" asset_project_desc="Phoenix Mission mars" asset_project_start="2024-10-16" asset_project_end="2025-05-05"
```

</details>

---

#### **Exercise 2: Create a Virtual Network**
Now, create a virtual network for your AKS cluster in the resource group.

<details>
<summary>💡 Show Solution</summary>

```bash
az network vnet create --name MarsAksVNet --resource-group MarsAks_RG --address-prefix "10.1.0.0/16" --location "francecentral"
```

</details>

---

#### **Exercise 3: Create a Subnet for AKS**
Create a subnet in the virtual network for your AKS cluster to use.

<details>
<summary>💡 Show Solution</summary>

```bash
az network vnet subnet create --name MarsAksSubnet --vnet-name MarsAksVNet --resource-group MarsAks_RG --address-prefixes "10.1.1.0/24"
```

</details>

---

#### **Exercise 4: Create a Log Analytics Workspace**
Set up a Log Analytics workspace to monitor the AKS cluster.

<details>
<summary>💡 Show Solution</summary>

```bash
az monitor log-analytics workspace create --resource-group MarsAks_RG --location "francecentral" --name MarsAKSLogWorkspace --sku PerGB2018
```

</details>

---

#### **Exercise 5: Create the AKS Cluster**
Now, create the AKS cluster using the previously created networking resources.

<details>
<summary>💡 Show Solution</summary>

```bash
az aks create --name MarsAKSCluster --resource-group MarsAks_RG --location "francecentral" --dns-name-prefix "marsaks" --node-count 3 --node-vm-size "Standard_DS3_v2" --vnet-subnet-id "$(az network vnet subnet show --name MarsAksSubnet --vnet-name MarsAksVNet --resource-group MarsAks_RG --query id -o tsv)" --enable-managed-identity --network-plugin azure --network-policy azure --tags asset_owner="$(az account show --query 'user.name' -o tsv)" asset_project_desc="Phoenix Mission mars" asset_project_start="2024-10-16" asset_project_end="2025-12-31" availability1=1 availability2=15 maintenance1="monday" maintenance2="friday" shutdownaftermaintenance="no" barcode="${barcode}" autostart="no" Auto-shutdown="no" autoshutdown="no"
```

</details>

---

#### **Exercise 6: Add a Node Pool to the AKS Cluster**
Next, you will add a new node pool to the AKS cluster to handle batch jobs.

<details>
<summary>💡 Show Solution</summary>

```bash
az aks nodepool add --cluster-name MarsAKSCluster --resource-group MarsAks_RG --name batchpool --node-count 1 --node-vm-size "Standard_DS2_v2" --labels purpose=batch-jobs
```

</details>

---

#### **Exercise 7: Get AKS Cluster Credentials**
Now, get the credentials for the AKS cluster to manage it via kubectl.

<details>
<summary>💡 Show Solution</summary>

```bash
az aks get-credentials --resource-group MarsAks_RG --name MarsAKSCluster
```

</details>

---

#### **Exercise 8: Show AKS Cluster Name**
Display the name of the AKS cluster to verify that it was created successfully.

<details>
<summary>💡 Show Solution</summary>

```bash
az aks show --resource-group MarsAks_RG --name MarsAKSCluster --query name -o tsv
```

</details>

---

#### **Exercise 9: Show AKS Cluster kubeConfig**
Finally, display the kubeConfig details of the AKS cluster to confirm that the configuration is correct.

<details>
<summary>💡 Show Solution</summary>

```bash
az aks show --resource-group MarsAks_RG --name MarsAKSCluster --query "kubeConfig" -o tsv
```

</details>

---

## Additional Resources
- [AKS CLI Reference](https://learn.microsoft.com/en-us/cli/azure/aks)
- [AKS Best Practices](https://learn.microsoft.com/en-us/azure/aks/best-practices)
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [AKS Scaling Strategies](https://learn.microsoft.com/en-us/azure/aks/concepts-scale)
- [AKS Storage Options](https://learn.microsoft.com/en-us/azure/aks/concepts-storage)
- [AKS Cluster Upgrades](https://learn.microsoft.com/en-us/azure/aks/upgrade-cluster)
- [AKS Troubleshooting Guide](https://learn.microsoft.com/en-us/azure/aks/troubleshooting)
- [AKS Network Policies](https://learn.microsoft.com/en-us/azure/aks/use-network-policies)
- [AKS Identity and Access Management](https://learn.microsoft.com/en-us/azure/aks/concepts-identity)

---

### **🎖️ Mission Debrief**
With the AKS cluster successfully deployed and configured, you have ensured that the Phoenix Mission to Mars is supported with scalable infrastructure and monitoring capabilities. 