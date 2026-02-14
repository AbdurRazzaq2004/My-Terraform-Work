# Reusable Terraform Modules

A collection of production ready, reusable Terraform modules for **AWS** and **Azure** cloud providers.

Each module follows a consistent structure with `main.tf`, `variables.tf`, and `outputs.tf`.

## AWS Modules (18)

| # | Module | Description |
|---|--------|-------------|
| 1 | [vpc](./AWS/vpc/) | VPC with public/private subnets, Internet Gateway, NAT Gateway, and route tables |
| 2 | [ec2](./AWS/ec2/) | EC2 instance with IMDSv2, encrypted root EBS volume |
| 3 | [security-group](./AWS/security-group/) | Security Group with dynamic ingress and egress rules |
| 4 | [s3](./AWS/s3/) | S3 bucket with versioning, encryption, lifecycle rules, and public access block |
| 5 | [rds](./AWS/rds/) | RDS instance with subnet group, multi AZ support |
| 6 | [iam-role](./AWS/iam-role/) | IAM role with managed and inline policy attachments |
| 7 | [alb](./AWS/alb/) | Application Load Balancer with target group and listener |
| 8 | [eks](./AWS/eks/) | EKS cluster with managed node group and IAM roles |
| 9 | [ecs](./AWS/ecs/) | ECS Fargate cluster with task definition, service, and CloudWatch logs |
| 10 | [lambda](./AWS/lambda/) | Lambda function with IAM role and CloudWatch log group |
| 11 | [cloudfront](./AWS/cloudfront/) | CloudFront distribution with S3 or custom origin |
| 12 | [route53](./AWS/route53/) | Route 53 hosted zone with standard and alias records |
| 13 | [asg](./AWS/asg/) | Auto Scaling Group with launch template and target tracking policy |
| 14 | [sns](./AWS/sns/) | SNS topic with email, SQS, and Lambda subscriptions |
| 15 | [sqs](./AWS/sqs/) | SQS queue with dead letter queue and redrive policy |
| 16 | [dynamodb](./AWS/dynamodb/) | DynamoDB table with GSI, TTL, encryption, and point in time recovery |
| 17 | [secrets-manager](./AWS/secrets-manager/) | Secrets Manager secret with JSON or plaintext value |
| 18 | [elasticache](./AWS/elasticache/) | ElastiCache Redis/Memcached cluster with subnet group |

## Azure Modules (16)

| # | Module | Description |
|---|--------|-------------|
| 1 | [resource-group](./Azure/resource-group/) | Resource Group |
| 2 | [vnet](./Azure/vnet/) | Virtual Network with subnets, delegations, and service endpoints |
| 3 | [nsg](./Azure/nsg/) | Network Security Group with dynamic rules and subnet associations |
| 4 | [linux-vm](./Azure/linux-vm/) | Linux Virtual Machine with NIC and optional public IP |
| 5 | [storage-account](./Azure/storage-account/) | Storage Account with blob properties, versioning, and containers |
| 6 | [key-vault](./Azure/key-vault/) | Key Vault with RBAC authorization and network ACLs |
| 7 | [aks](./Azure/aks/) | AKS cluster with autoscaling and system assigned identity |
| 8 | [app-service](./Azure/app-service/) | App Service (Linux/Windows) with service plan and staging slot |
| 9 | [sql-database](./Azure/sql-database/) | Azure SQL Server and database with firewall rules |
| 10 | [load-balancer](./Azure/load-balancer/) | Load Balancer with public IP, backend pool, probe, and rules |
| 11 | [container-registry](./Azure/container-registry/) | Azure Container Registry |
| 12 | [bastion](./Azure/bastion/) | Bastion Host with AzureBastionSubnet and public IP |
| 13 | [application-gateway](./Azure/application-gateway/) | Application Gateway with routing rules |
| 14 | [dns-zone](./Azure/dns-zone/) | Public or Private DNS Zone with VNet links and records |
| 15 | [log-analytics](./Azure/log-analytics/) | Log Analytics Workspace |
| 16 | [cosmos-db](./Azure/cosmos-db/) | Cosmos DB account with SQL database and geo replication |

## Module Structure

```
module-name/
├── main.tf          # Resource definitions
├── variables.tf     # Input variables
└── outputs.tf       # Output values
```

## Usage Example

```hcl
module "vpc" {
  source = "./Modules/AWS/vpc"

  vpc_name            = "my-vpc"
  vpc_cidr            = "10.0.0.0/16"
  availability_zones  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
  enable_nat_gateway  = true

  tags = {
    Environment = "dev"
  }
}

module "resource_group" {
  source = "./Modules/Azure/resource-group"

  name     = "my-rg"
  location = "East US"

  tags = {
    Environment = "dev"
  }
}
```
