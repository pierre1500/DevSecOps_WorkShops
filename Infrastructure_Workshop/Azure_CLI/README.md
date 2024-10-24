# Workshop Phoenix – Azure CLI Mission (Earth Infrastructure)

## Introduction

Welcome to the Azure CLI mission for the Earth-based infrastructure as part of the Phoenix project by the European Space Agency (ESA). Your team is responsible for setting up and securing the Earth infrastructure using Azure CLI. You will deploy advanced monitoring systems, implement high-level security solutions, and ensure resilient communications with the Martian infrastructure, which is managed by the Terraform team.

The final goal of your mission is to successfully establish a secure connection between the Earth (Azure) and Martian infrastructures, allowing data exchange, such as a successful ping or message reception.

## Missions

### Step 1 – Deployment of the Earth Infrastructure

1. **Creation of Critical Monitoring Systems:**
   - Use Azure CLI to deploy an advanced **Azure Monitor** setup to track the health of the Martian infrastructure, receiving telemetry data in real time.
   - Ensure **high availability** for the monitoring systems through **autoscaling** and **zone redundancy** to withstand unexpected high loads.

2. **Deploy a Centralized Log Management System:**
   - Implement **Azure Log Analytics** to collect and analyze logs from both Earth and Mars infrastructures.
   - Set up queries to detect unusual activities or errors in the Martian environment, providing real-time insights for security analysis.

### Step 2 – Advanced Security Measures

1. **Identity and Access Management (IAM):**
   - Set up **Conditional Access** policies to control who can access the Earth infrastructure. Enforce access restrictions based on location (Earth or Mars) and the level of sensitivity of the systems.
   - Implement **privileged access management** using Azure CLI to control high-privilege roles with **Just-In-Time (JIT) access**.

2. **Implement Secure Networking and Firewalls:**
   - Use Azure CLI to configure **Private Link** for services, ensuring that the Earth infrastructure communicates with Martian services without exposure to the public internet.
   - Set up **Azure Firewall** to filter and monitor all inbound and outbound traffic between Earth and Mars, applying custom security rules.

3. **Data Encryption & Key Management:**
   - Deploy **Azure Key Vault** to manage encryption keys, certificates, and secrets for secure communication between Earth and Mars.
   - Ensure all data transmissions are encrypted using **end-to-end encryption** with SSL/TLS and manage encryption keys dynamically.

### Step 3 – Resilience to Simulated Cyberattacks

1. **Protection Against Phishing Attacks:**
   - Set up **Azure Defender for Identity** to detect potential identity-based attacks such as phishing attempts aimed at stealing access credentials for critical systems.
   - Ensure that identity protection measures are enforced across users, including Mars-based systems, using **Azure Active Directory Identity Protection**.

2. **Simulate a Cyberattack Drill:**
   - Prepare the infrastructure for a simulated breach by setting up **Azure Sentinel** to monitor suspicious activities.
   - Automate responses with **Azure Logic Apps** to isolate compromised resources, rotate security credentials, and alert the appropriate teams.

3. **Recovery from Ransomware Attacks:**
   - Deploy a **backup and recovery** strategy using **Azure Backup** to regularly back up key data and system configurations.
   - Test the ability to restore Earth systems in case of a ransomware attack by performing a recovery drill.

### Step 4 – Interconnection with Martian Infrastructure

1. **Creating a Secure Communication Tunnel to Mars:**
   - Use **Azure VPN Gateway** and **Azure ExpressRoute** to set up a secure, high-bandwidth connection between Earth and the Martian infrastructure.
   - Configure an **Active-Active VPN** setup for redundancy, ensuring a stable connection in case of failure of one VPN endpoint.

2. **Data Synchronization Between Earth and Mars:**
   - Set up **Azure File Sync** to synchronize critical mission data between Earth-based storage accounts and the Martian environment.
   - Use **Geo-Replication** in Azure to ensure that important data is replicated between Earth and Mars, maintaining a backup on both ends.

3. **Test Inter-System Communication:**
   - Perform an **end-to-end ping test** or exchange a small data file to ensure that the Martian and Earth infrastructures are fully connected and operational.
   - Monitor the latency, packet loss, and security of the connection via **Azure Network Watcher**.

### Step 5 – Advanced Monitoring and Automation

1. **Deploy an Incident Response System:**
   - Set up **Azure Automation** to handle routine infrastructure tasks, such as patch management and backup verification, to reduce human error.
   - Automate responses to security incidents by integrating **Azure Logic Apps** with **Azure Sentinel** for triggering automatic isolation of systems during a breach.

2. **Proactive Monitoring with Alerts:**
   - Configure **Azure Monitor** with custom metrics and alerts to detect anomalies in communication between Earth and Mars, such as high latency or packet drops.
   - Set up an **Azure Event Grid** for real-time notifications to the team when specific security events or performance thresholds are breached.

3. **Cost Monitoring and Optimization:**
   - Use **Azure Cost Management + Billing** to track resource usage across Earth and Martian infrastructure, optimizing the costs associated with data transfer, compute resources, and storage.
   - Identify and shut down underutilized resources using **Azure Advisor** recommendations, helping to reduce mission expenses.

## Objectives to Achieve

- Deploy a **secure, scalable** Earth infrastructure using Azure CLI.
- Implement robust identity management, network security, and data encryption.
- Protect the Earth infrastructure from cyberattacks such as phishing, ransomware, and simulated breaches.
- Establish a **redundant and secure communication link** between Earth and Mars.
- Perform a final test with a **ping** or data exchange to validate successful interconnection.
- Ensure proactive monitoring, response automation, and cost optimization for long-term success.

---

Good luck with your mission! Troups 
