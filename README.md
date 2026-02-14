<div align="center">

<img src="https://img.shields.io/badge/Terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform"/>
<img src="https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazonaws&logoColor=white" alt="AWS"/>
<img src="https://img.shields.io/badge/Azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white" alt="Azure"/>
<img src="https://img.shields.io/badge/HCL-%23430098.svg?style=for-the-badge&logo=hashicorp&logoColor=white" alt="HCL"/>

<br/><br/>

# My Terraform Work

### Lessons, Projects, and Reusable Modules for AWS & Azure

<br/>

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=500&size=20&pause=1000&color=7B42BC&center=true&vCenter=true&repeat=true&width=600&height=50&lines=9+Lessons+%2B+4+Projects+%F0%9F%9A%80;34+Reusable+Modules+for+AWS+%26+Azure+%F0%9F%93%A6;Infrastructure+as+Code+%7C+Production+Ready" alt="Typing SVG" />

<br/>

<img src="https://img.shields.io/badge/Lessons-9-blue?style=flat-square" alt="Lessons"/>
<img src="https://img.shields.io/badge/Mini_Projects-3-orange?style=flat-square" alt="Mini Projects"/>
<img src="https://img.shields.io/badge/Intermediate_Projects-1-326CE5?style=flat-square" alt="Intermediate Projects"/>
<img src="https://img.shields.io/badge/Reusable_Modules-34-2ea44f?style=flat-square" alt="Modules"/>
<img src="https://img.shields.io/badge/Terraform-%3E%3D1.9.0-purple?style=flat-square&logo=terraform" alt="Terraform"/>

</div>

<br/>

---

## 📁 Repository Structure

```bash
📦 My-Terraform-Work/
 ┣ 📂 azure-terraform/          # Lessons, Mini Projects, and Intermediate Projects
 ┃  ┣ 📂 1 to 9 Lessons/        # Terraform fundamentals with Azure
 ┃  ┣ 📂 Mini-Project-1/        # Scalable Web App with VMSS and Load Balancer
 ┃  ┣ 📂 Mini-Project-2/        # VNet Peering and VM Connectivity
 ┃  ┣ 📂 Mini-Project-3/        # App Service with Deployment Slots
 ┃  ┣ 📂 Intermediate-Project-1/ # AKS Cluster with Key Vault and Modules
 ┃  ┗ 📄 README.md
 ┣ 📂 Modules/                  # Reusable Terraform modules
 ┃  ┣ 📂 AWS/                   # 18 AWS modules
 ┃  ┣ 📂 Azure/                 # 16 Azure modules
 ┃  ┗ 📄 README.md
 ┗ 📄 README.md
```

---

## ☁️ Azure Terraform

All lessons, mini projects, and intermediate projects live in the [`azure-terraform/`](./azure-terraform/) folder.

👉 **[View Full Details](./azure-terraform/README.md)**

### Lessons (9)

| # | Topic |
|:---:|:---|
| 1 | Creating Resource Group and Storage Account |
| 2 | StateFile Management with Azure Storage |
| 3 | Modular Terraform File Structure |
| 4 | Variable Type Constraints |
| 5 | Resource Meta Arguments |
| 6 | Lifecycle Rules |
| 7 | Terraform Expressions |
| 8 | Terraform Functions |
| 9 | Terraform Data Sources |

### Projects (4)

| # | Project | Type |
|:---:|:---|:---:|
| 1 | Scalable Web App with VMSS and Load Balancer | Mini |
| 2 | VNet Peering and VM Connectivity | Mini |
| 3 | App Service with Deployment Slots | Mini |
| 4 | AKS Cluster with Key Vault and Modules | Intermediate |

---

## 📦 Reusable Modules

A library of **34 production ready** Terraform modules for AWS and Azure. Each module has `main.tf`, `variables.tf`, and `outputs.tf`.

👉 **[View All Modules](./Modules/README.md)**

### AWS (18 Modules)

`vpc` · `ec2` · `security-group` · `s3` · `rds` · `iam-role` · `alb` · `eks` · `ecs` · `lambda` · `cloudfront` · `route53` · `asg` · `sns` · `sqs` · `dynamodb` · `secrets-manager` · `elasticache`

### Azure (16 Modules)

`resource-group` · `vnet` · `nsg` · `linux-vm` · `storage-account` · `key-vault` · `aks` · `app-service` · `sql-database` · `load-balancer` · `container-registry` · `bastion` · `application-gateway` · `dns-zone` · `log-analytics` · `cosmos-db`

---

## 📚 References

| Resource | Link |
|:---|:---|
| Terraform Documentation | [developer.hashicorp.com/terraform](https://developer.hashicorp.com/terraform/docs) |
| AzureRM Provider | [registry.terraform.io/providers/hashicorp/azurerm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) |
| AWS Provider | [registry.terraform.io/providers/hashicorp/aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) |

---

<div align="center">

<img src="https://img.shields.io/badge/Made%20with-%E2%9D%A4%EF%B8%8F-red?style=for-the-badge" alt="Made with Love"/>
<img src="https://img.shields.io/badge/Powered%20by-Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Powered by Terraform"/>

<br/><br/>

**⭐ Star this repo if you found it helpful!**

</div>
