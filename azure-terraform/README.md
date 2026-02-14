<div align="center">

<img src="https://img.shields.io/badge/Terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform"/>
<img src="https://img.shields.io/badge/Azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white" alt="Azure"/>
<img src="https://img.shields.io/badge/HCL-%23430098.svg?style=for-the-badge&logo=hashicorp&logoColor=white" alt="HCL"/>
<img src="https://img.shields.io/badge/Bash-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="Bash"/>

<br/><br/>

# ☁️ Azure + Terraform

### Infrastructure as Code — From Fundamentals to Real World Projects

<br/>

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=500&size=20&pause=1000&color=0078D4&center=true&vCenter=true&repeat=true&width=600&height=50&lines=Learning+Terraform+with+Azure+%E2%98%81%EF%B8%8F;9+Lessons+%2B+Mini+Projects+%F0%9F%9A%80;34+Reusable+Modules+for+AWS+%26+Azure+%F0%9F%93%A6;Hands+On+%7C+Real+World+%7C+Production+Ready" alt="Typing SVG" />

<br/>

<img src="https://img.shields.io/badge/Lessons-9-blue?style=flat-square" alt="Lessons"/>
<img src="https://img.shields.io/badge/Mini_Projects-3-orange?style=flat-square" alt="Projects"/>
<img src="https://img.shields.io/badge/Intermediate_Projects-1-326CE5?style=flat-square" alt="Intermediate Projects"/>
<img src="https://img.shields.io/badge/Reusable_Modules-34-2ea44f?style=flat-square" alt="Modules"/>
<img src="https://img.shields.io/badge/Terraform-%3E%3D1.9.0-purple?style=flat-square&logo=terraform" alt="Terraform"/>
<img src="https://img.shields.io/badge/AzureRM-~%3E4.8.0-0078D4?style=flat-square&logo=microsoftazure" alt="AzureRM"/>

</div>

<br/>

---

## 📌 About This Repository

This repository documents my **hands on journey** learning Terraform with Microsoft Azure. Each folder covers a specific concept, building progressively from the basics to deploying fully automated, production style infrastructure.

> **Every lesson includes working `.tf` files, detailed explanations, and official documentation references.**

---

## 📚 Lessons

| # | Topic | Description |
|:---:|:---|:---|
| 1 | [**Creating Resource Group and Storage Account**](1-Creating-Resource%20Group%20and%20StorageAccount/) | First steps with Terraform — provisioning a Resource Group and Storage Account on Azure |
| 2 | [**StateFile Management with Azure Storage**](2-StateFile%20Management%20with%20Azure%20Storage/) | Understanding Terraform state, remote backends, and storing state in Azure Blob Storage |
| 3 | [**Modular Terraform File Structure**](3-Modular%20Terraform%20File%20Structure/) | Breaking a single `main.tf` into organized, modular files (`provider.tf`, `variables.tf`, `output.tf`, etc.) |
| 4 | [**Variable Type Constraints**](4-Variable%20Type%20Constraints/) | Exploring `string`, `number`, `bool`, `list`, `set`, `map`, `object`, and `tuple` variable types with validations |
| 5 | [**Resource Meta Arguments**](5-Resource%20Meta%20Arguments/) | Using `depends_on`, `count`, `for_each`, and `provider` to control resource behavior |
| 6 | [**Lifecycle Rules**](6-Lifecycle%20Rules/) | Managing resource lifecycle with `create_before_destroy`, `prevent_destroy`, `ignore_changes`, and `replace_triggered_by` |
| 7 | [**Terraform Expressions**](7-Terraform%20Expressions/) | Conditional expressions, `for` expressions, splat expressions, and dynamic blocks |
| 8 | [**Terraform Functions**](8-Terraform%20Functions/) | Built in functions — `lookup`, `merge`, `file`, `templatefile`, `cidrsubnet`, `format`, and more |
| 9 | [**Terraform Data Sources**](9-Terraform%20Data%20Sources/) | Querying existing infrastructure with data sources to reference resources not managed by Terraform |

---

## 🚀 Mini Projects

| # | Project | Description | Resources |
|:---:|:---|:---|:---:|
| 1 | [**Scalable Web App with VMSS and Load Balancer**](Mini-Project-1(Scalable%20Web%20App%20with%20VMSS%20and%20Load%20Balancer)/) | Production style deployment with VMSS, Load Balancer, NAT Gateway, autoscaling, and NSG — integrating concepts from all 9 lessons | 18 |
| 2 | [**VNet Peering and VM Connectivity**](Mini-Project-2(VNet%20Peering%20and%20VM%20Connectivity)/) | Two VNets, two VMs, Azure Bastion, and conditional VNet Peering — test connectivity before and after peering | 16 |
| 3 | [**App Service with Deployment Slots**](Mini-Project-3(App%20Service%20with%20Deployment%20Slots)/) | Blue/Green deployment with Azure App Service, staging slot, GitHub source control, and conditional slot swap | 7 |

---

## 🔥 Intermediate Projects

| # | Project | Description | Modules | Resources |
|:---:|:---|:---|:---:|:---:|
| 1 | [**AKS Cluster with Key Vault and Modules**](Intermediate-Project-1(AKS%20Cluster%20with%20Key%20Vault%20and%20Modules)/) | Production style AKS deployment using 3 custom Terraform modules — Service Principal, Key Vault, and AKS with autoscaling and multi zone nodes | 3 | 10 |

---

## 📦 Reusable Terraform Modules

A library of **34 production ready** reusable modules for AWS and Azure. Each module follows a consistent structure with `main.tf`, `variables.tf`, and `outputs.tf`.

👉 **[View All Modules](../Modules/)**

### AWS Modules (18)

| # | Module | Description |
|:---:|:---|:---|
| 1 | [vpc](../Modules/AWS/vpc/) | VPC with public/private subnets, IGW, NAT Gateway, route tables |
| 2 | [ec2](../Modules/AWS/ec2/) | EC2 instance with IMDSv2, encrypted root EBS volume |
| 3 | [security-group](../Modules/AWS/security-group/) | Security Group with dynamic ingress and egress rules |
| 4 | [s3](../Modules/AWS/s3/) | S3 bucket with versioning, encryption, lifecycle rules |
| 5 | [rds](../Modules/AWS/rds/) | RDS instance with subnet group, multi AZ support |
| 6 | [iam-role](../Modules/AWS/iam-role/) | IAM role with managed and inline policy attachments |
| 7 | [alb](../Modules/AWS/alb/) | Application Load Balancer with target group and listener |
| 8 | [eks](../Modules/AWS/eks/) | EKS cluster with managed node group and IAM roles |
| 9 | [ecs](../Modules/AWS/ecs/) | ECS Fargate cluster with task definition and service |
| 10 | [lambda](../Modules/AWS/lambda/) | Lambda function with IAM role and CloudWatch logs |
| 11 | [cloudfront](../Modules/AWS/cloudfront/) | CloudFront distribution with S3 or custom origin |
| 12 | [route53](../Modules/AWS/route53/) | Route 53 hosted zone with standard and alias records |
| 13 | [asg](../Modules/AWS/asg/) | Auto Scaling Group with launch template and scaling policy |
| 14 | [sns](../Modules/AWS/sns/) | SNS topic with email, SQS, and Lambda subscriptions |
| 15 | [sqs](../Modules/AWS/sqs/) | SQS queue with dead letter queue and redrive policy |
| 16 | [dynamodb](../Modules/AWS/dynamodb/) | DynamoDB table with GSI, TTL, encryption, PITR |
| 17 | [secrets-manager](../Modules/AWS/secrets-manager/) | Secrets Manager secret with JSON or plaintext value |
| 18 | [elasticache](../Modules/AWS/elasticache/) | ElastiCache Redis/Memcached cluster with subnet group |

### Azure Modules (16)

| # | Module | Description |
|:---:|:---|:---|
| 1 | [resource-group](../Modules/Azure/resource-group/) | Resource Group |
| 2 | [vnet](../Modules/Azure/vnet/) | Virtual Network with subnets, delegations, service endpoints |
| 3 | [nsg](../Modules/Azure/nsg/) | Network Security Group with dynamic rules and subnet associations |
| 4 | [linux-vm](../Modules/Azure/linux-vm/) | Linux Virtual Machine with NIC and optional public IP |
| 5 | [storage-account](../Modules/Azure/storage-account/) | Storage Account with blob properties, versioning, containers |
| 6 | [key-vault](../Modules/Azure/key-vault/) | Key Vault with RBAC authorization and network ACLs |
| 7 | [aks](../Modules/Azure/aks/) | AKS cluster with autoscaling and system assigned identity |
| 8 | [app-service](../Modules/Azure/app-service/) | App Service (Linux/Windows) with service plan and staging slot |
| 9 | [sql-database](../Modules/Azure/sql-database/) | Azure SQL Server and database with firewall rules |
| 10 | [load-balancer](../Modules/Azure/load-balancer/) | Load Balancer with backend pool, probe, and rules |
| 11 | [container-registry](../Modules/Azure/container-registry/) | Azure Container Registry |
| 12 | [bastion](../Modules/Azure/bastion/) | Bastion Host with AzureBastionSubnet and public IP |
| 13 | [application-gateway](../Modules/Azure/application-gateway/) | Application Gateway with routing rules |
| 14 | [dns-zone](../Modules/Azure/dns-zone/) | Public or Private DNS Zone with VNet links and records |
| 15 | [log-analytics](../Modules/Azure/log-analytics/) | Log Analytics Workspace |
| 16 | [cosmos-db](../Modules/Azure/cosmos-db/) | Cosmos DB account with SQL database and geo replication |

---

##  Tech Stack

<div align="center">

| Tool | Version | Purpose |
|:---:|:---:|:---|
| <img src="https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=terraform&logoColor=white"/> | >= 1.9.0 | Infrastructure as Code |
| <img src="https://img.shields.io/badge/Azure-0078D4?style=flat-square&logo=microsoftazure&logoColor=white"/> | — | Cloud Provider |
| <img src="https://img.shields.io/badge/AzureRM-0078D4?style=flat-square&logo=hashicorp&logoColor=white"/> | ~> 4.8.0 | Terraform Azure Provider |
| <img src="https://img.shields.io/badge/Azure_CLI-0078D4?style=flat-square&logo=microsoftazure&logoColor=white"/> | Latest | Authentication & Management |

</div>

---

## ⚡ Quick Start

```bash
# Clone the repository
git clone https://github.com/AbdurRazzaq2004/My-Terraform-Work.git
cd My-Terraform-Work/azure-terraform

# Navigate to any lesson
cd "1-Creating-Resource Group and StorageAccount"

# Initialize and deploy
az login
terraform init
terraform plan
terraform apply
```

---

## 📁 Repository Structure

```bash
📦 My-Terraform-Work/
 ┣ 📂 azure-terraform/
 ┃  ┣ 📂 1-Creating-Resource Group and StorageAccount/
 ┃  ┣ 📂 2-StateFile Management with Azure Storage/
 ┃  ┣ 📂 3-Modular Terraform File Structure/
 ┃  ┣ 📂 4-Variable Type Constraints/
 ┃  ┣ 📂 5-Resource Meta Arguments/
 ┃  ┣ 📂 6-Lifecycle Rules/
 ┃  ┣ 📂 7-Terraform Expressions/
 ┃  ┣ 📂 8-Terraform Functions/
 ┃  ┣ 📂 9-Terraform Data Sources/
 ┃  ┣ 📂 Mini-Project-1(Scalable Web App with VMSS and Load Balancer)/
 ┃  ┣ 📂 Mini-Project-2(VNet Peering and VM Connectivity)/
 ┃  ┣ 📂 Mini-Project-3(App Service with Deployment Slots)/
 ┃  ┣ 📂 Intermediate-Project-1(AKS Cluster with Key Vault and Modules)/
 ┃  ┗ 📄 README.md
 ┣ 📂 Modules/
 ┃  ┣ 📂 AWS/ (18 modules)
 ┃  ┃  ┣ 📂 vpc/   📂 ec2/   📂 security-group/   📂 s3/   📂 rds/
 ┃  ┃  ┣ 📂 iam-role/   📂 alb/   📂 eks/   📂 ecs/   📂 lambda/
 ┃  ┃  ┣ 📂 cloudfront/   📂 route53/   📂 asg/   📂 sns/   📂 sqs/
 ┃  ┃  ┗ 📂 dynamodb/   📂 secrets-manager/   📂 elasticache/
 ┃  ┣ 📂 Azure/ (16 modules)
 ┃  ┃  ┣ 📂 resource-group/   📂 vnet/   📂 nsg/   📂 linux-vm/
 ┃  ┃  ┣ 📂 storage-account/   📂 key-vault/   📂 aks/   📂 app-service/
 ┃  ┃  ┣ 📂 sql-database/   📂 load-balancer/   📂 container-registry/
 ┃  ┃  ┣ 📂 bastion/   📂 application-gateway/   📂 dns-zone/
 ┃  ┃  ┗ 📂 log-analytics/   📂 cosmos-db/
 ┃  ┗ 📄 README.md
 ┗ 📄 README.md
```

---

## 📚 References

| Resource | Link |
|:---|:---|
| Terraform Documentation | [developer.hashicorp.com/terraform](https://developer.hashicorp.com/terraform/docs) |
| AzureRM Provider | [registry.terraform.io/providers/hashicorp/azurerm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) |
| AWS Provider | [registry.terraform.io/providers/hashicorp/aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) |
| Azure Documentation | [learn.microsoft.com/azure](https://learn.microsoft.com/en-us/azure/) |
| AWS Documentation | [docs.aws.amazon.com](https://docs.aws.amazon.com/) |
| Terraform Best Practices | [developer.hashicorp.com/terraform/cloud-docs/recommended-practices](https://developer.hashicorp.com/terraform/cloud-docs/recommended-practices) |

---

<div align="center">

<img src="https://img.shields.io/badge/Made%20with-%E2%9D%A4%EF%B8%8F-red?style=for-the-badge" alt="Made with Love"/>
<img src="https://img.shields.io/badge/Powered%20by-Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Powered by Terraform"/>
<img src="https://img.shields.io/badge/Cloud-Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white" alt="Azure"/>

<br/><br/>

**⭐ Star this repo if you found it helpful!**

</div>
