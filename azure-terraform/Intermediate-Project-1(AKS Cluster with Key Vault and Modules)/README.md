<div align="center">

<img src="https://img.shields.io/badge/Terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform"/>
<img src="https://img.shields.io/badge/Azure_Kubernetes_Service-%230078D4.svg?style=for-the-badge&logo=kubernetes&logoColor=white" alt="AKS"/>
<img src="https://img.shields.io/badge/Key_Vault-%23FFB900.svg?style=for-the-badge&logo=microsoftazure&logoColor=black" alt="Key Vault"/>
<img src="https://img.shields.io/badge/Azure_AD-%230078D4.svg?style=for-the-badge&logo=microsoftazure&logoColor=white" alt="Azure AD"/>

<br/><br/>

# 🚀 AKS Cluster with Key Vault and Modules

### Intermediate Project 1 — Modular Infrastructure for Kubernetes on Azure

<br/>

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=500&size=18&pause=1000&color=326CE5&center=true&vCenter=true&repeat=true&width=550&height=40&lines=AKS+%2B+Key+Vault+%2B+Service+Principal;Modular+Terraform+Architecture;Production+Ready+Kubernetes+on+Azure" alt="Typing SVG" />

<br/>

<img src="https://img.shields.io/badge/Resources-8+-326CE5?style=flat-square" alt="Resources"/>
<img src="https://img.shields.io/badge/Modules-3-orange?style=flat-square" alt="Modules"/>
<img src="https://img.shields.io/badge/Providers-2-purple?style=flat-square" alt="Providers"/>

</div>

<br/>

---

## 📌 About This Project

This project deploys a **production style AKS (Azure Kubernetes Service) cluster** using a modular Terraform architecture. It creates an Azure AD Service Principal, stores its credentials securely in Key Vault, and provisions a multi zone Kubernetes cluster with autoscaling.

> **This project combines concepts from all 9 lessons and the previous mini projects — modular file structure, variables, data sources, expressions, functions, and lifecycle management.**

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Azure Subscription                      │
│                                                              │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                   Resource Group                       │  │
│  │                                                        │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌─────────────┐ │  │
│  │  │   Azure AD    │  │   Key Vault   │  │    AKS      │ │  │
│  │  │              │  │              │  │   Cluster    │ │  │
│  │  │  Application │  │  SP Client   │  │             │ │  │
│  │  │  Service     │──│  ID (secret) │  │  Default    │ │  │
│  │  │  Principal   │  │  SP Password │  │  Node Pool  │ │  │
│  │  │  Password    │  │  (secret)    │  │  (1-3 nodes)│ │  │
│  │  └──────┬───────┘  └──────────────┘  │  Zones 1,2,3│ │  │
│  │         │                             │  Autoscale  │ │  │
│  │         │  Contributor Role           │             │ │  │
│  │         └─────────────────────────────│  Azure CNI  │ │  │
│  │                                       │  Standard LB│ │  │
│  │                                       └─────────────┘ │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌───────────────────────────────────────────────────────┐  │
│  │             Node Resource Group (auto created)         │  │
│  │  VMSS (nodes) │ Load Balancer │ NSG │ Public IPs      │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘

Output: kubeconfig file → kubectl access
```

---

## 📂 Project Structure

```bash
📦 Intermediate-Project-1(AKS Cluster with Key Vault and Modules)/
 ┣ 📂 modules/
 ┃   ┣ 📂 service_principal/
 ┃   ┃   ┣ 📄 main.tf          # Azure AD App + SP + Password
 ┃   ┃   ┣ 📄 variables.tf     # Module input variables
 ┃   ┃   ┗ 📄 output.tf        # SP object ID, client ID, secret
 ┃   ┣ 📂 keyvault/
 ┃   ┃   ┣ 📄 main.tf          # Key Vault with RBAC authorization
 ┃   ┃   ┣ 📄 variables.tf     # Module input variables
 ┃   ┃   ┗ 📄 output.tf        # Vault ID, name, URI
 ┃   ┗ 📂 aks/
 ┃       ┣ 📄 main.tf          # AKS cluster with autoscaling
 ┃       ┣ 📄 variables.tf     # Module input variables
 ┃       ┗ 📄 output.tf        # Cluster name, FQDN, kubeconfig
 ┣ 📄 provider.tf              # AzureRM + AzureAD providers
 ┣ 📄 backend.tf               # Remote state in Azure Storage
 ┣ 📄 variables.tf             # Root level input variables
 ┣ 📄 terraform.tfvars         # Variable values
 ┣ 📄 local.tf                 # Common tags
 ┣ 📄 main.tf                  # Root module orchestration
 ┣ 📄 output.tf                # Root level outputs
 ┗ 📄 .gitignore               # Ignore state, kubeconfig, keys
```

---

## 🔧 Resources Created

| # | Resource | Type | Purpose |
|:---:|:---|:---|:---|
| 1 | Resource Group | `azurerm_resource_group` | Container for all project resources |
| 2 | Azure AD Application | `azuread_application` | Identity for the service principal |
| 3 | Service Principal | `azuread_service_principal` | Authentication for AKS cluster |
| 4 | SP Password | `azuread_service_principal_password` | Auto generated credential for SP |
| 5 | Role Assignment | `azurerm_role_assignment` | Contributor role on subscription |
| 6 | Key Vault | `azurerm_key_vault` | Secure storage for SP credentials |
| 7 | KV Secret (Client ID) | `azurerm_key_vault_secret` | SP client ID stored in vault |
| 8 | KV Secret (Client Secret) | `azurerm_key_vault_secret` | SP password stored in vault |
| 9 | AKS Cluster | `azurerm_kubernetes_cluster` | Managed Kubernetes cluster |
| 10 | Kubeconfig File | `local_file` | Local file for kubectl access |

---

## 🧩 Module Details

### Service Principal Module

Creates an Azure AD application registration and a linked service principal with an auto generated password. The SP is used by AKS to manage Azure resources (create load balancers, manage networking, pull images).

### Key Vault Module

Provisions an Azure Key Vault with RBAC authorization enabled. The SP client ID and client secret are stored as vault secrets, following best practices for credential management.

### AKS Module

Deploys a Kubernetes cluster with:
- **Latest stable Kubernetes version** (auto detected via data source)
- **Autoscaling** from 1 to 3 nodes
- **Multi zone deployment** across availability zones 1, 2, and 3
- **Azure CNI** networking with a Standard Load Balancer
- **SSH access** configured via public key

---

## ⚡ How to Deploy

### Prerequisites

- Azure CLI installed and logged in (`az login`)
- Terraform >= 1.9.0
- SSH key pair (`ssh-keygen -t rsa -b 4096`)
- Sufficient permissions (Contributor + Azure AD Application Admin)

### Steps

```bash
# Navigate to the project folder
cd "Intermediate-Project-1(AKS Cluster with Key Vault and Modules)"

# Update terraform.tfvars with your values
vim terraform.tfvars

# Update backend.tf with your storage account details
vim backend.tf

# Initialize Terraform
terraform init

# Preview the deployment
terraform plan

# Deploy
terraform apply

# Configure kubectl
export KUBECONFIG=./kubeconfig
kubectl get nodes
```

### After Deployment

```bash
# Verify the cluster
kubectl get nodes -o wide
kubectl get namespaces
kubectl cluster-info

# Or use az aks to get credentials
az aks get-credentials --resource-group aks-intermediate-rg --name aks-cluster
```

---

## 📤 Outputs

| Output | Description |
|:---|:---|
| `resource_group_name` | Name of the resource group |
| `aks_cluster_name` | Name of the AKS cluster |
| `aks_cluster_fqdn` | FQDN of the AKS API server |
| `kubernetes_version` | Kubernetes version on the cluster |
| `keyvault_name` | Name of the Key Vault |
| `keyvault_id` | Resource ID of the Key Vault |
| `service_principal_name` | Display name of the SP |
| `client_id` | Application (Client) ID |
| `client_secret` | SP password (sensitive) |
| `kube_config_command` | az aks get-credentials command |

---

## 🧠 Concepts Used

| Concept | Where |
|:---|:---|
| **Terraform Modules** | 3 custom modules (service_principal, keyvault, aks) |
| **Data Sources** | `azurerm_kubernetes_service_versions`, `azurerm_client_config`, `azuread_client_config`, `azurerm_subscription` |
| **Variable Types** | string, number, map, bool with defaults and descriptions |
| **Conditional Expressions** | Kubernetes version fallback to latest |
| **Local Values** | Common tags shared across resources |
| **Sensitive Outputs** | Client secret marked as sensitive |
| **depends_on** | Module dependency chain (SP → KV → AKS) |
| **Multiple Providers** | AzureRM + AzureAD in a single configuration |

---

## 📚 References

| Resource | Link |
|:---|:---|
| AKS Terraform Docs | [registry.terraform.io/providers/hashicorp/azurerm/.../kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) |
| Key Vault Terraform Docs | [registry.terraform.io/providers/hashicorp/azurerm/.../key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) |
| AzureAD Provider | [registry.terraform.io/providers/hashicorp/azuread](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs) |
| Terraform Modules | [developer.hashicorp.com/terraform/language/modules](https://developer.hashicorp.com/terraform/language/modules) |
| AKS Best Practices | [learn.microsoft.com/azure/aks/best-practices](https://learn.microsoft.com/en-us/azure/aks/best-practices) |

---

<div align="center">

**🔙 [Back to Main README](../README.md)**

</div>
