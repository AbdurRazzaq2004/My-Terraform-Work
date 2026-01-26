# Terraform AWS VPC Stack

A modular, reusable Terraform configuration for creating AWS VPC infrastructure with best practices. This module follows the **"Stack module with submodules"** pattern - the most flexible approach for team reuse.

---

## 📖 Table of Contents

- [Module Structure](#-module-structure)
- [Design Principles](#-design-principles)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Step-by-Step Usage Guide](#-step-by-step-usage-guide)
- [Configuration Options](#️-configuration-options)
- [Module Outputs](#-module-outputs)
- [NAT Gateway Modes](#-nat-gateway-modes)
- [Using Individual Submodules](#-using-individual-submodules)
- [Real-World Examples](#-real-world-examples)
- [Version Tagging](#️-version-tagging)
- [Security Best Practices](#-security-best-practices)
- [Troubleshooting](#-troubleshooting)

---

## 📁 Module Structure

```
terraform/
├── examples/
│   └── simple-two-az/          # Example: 2-AZ VPC deployment
│       ├── main.tf             # Main configuration
│       ├── variables.tf        # Input variables
│       ├── outputs.tf          # Output values
│       └── terraform.tfvars.example
│
├── modules/
│   ├── network/
│   │   ├── vpc/                # VPC + Internet Gateway + Flow Logs
│   │   ├── subnets/            # Public/Private subnets with for_each
│   │   ├── routing/            # NAT Gateways + Route Tables
│   │   └── security/           # Security Groups + NACLs
│   │
│   ├── compute/
│   │   └── ec2/                # EC2 instances with for_each
│   │
│   └── vpc_stack/              # Wrapper module (one call creates everything)
│
└── README.md
```

### What Each Component Does

| Component | Purpose |
|-----------|---------|
| `modules/network/vpc` | Creates VPC, Internet Gateway, and optional Flow Logs |
| `modules/network/subnets` | Creates public/private subnets using `for_each` for stable addressing |
| `modules/network/routing` | Creates NAT Gateways, Route Tables, and route associations |
| `modules/network/security` | Creates Security Groups and optional Network ACLs |
| `modules/compute/ec2` | Creates EC2 instances with EBS, EIP support |
| `modules/vpc_stack` | **Wrapper module** - calls all submodules with one simple interface |
| `examples/simple-two-az` | Working example showing how to use the modules |

---

## 🎯 Design Principles

| Principle | Explanation |
|-----------|-------------|
| **Submodules = Building Blocks** | Each submodule (vpc, subnets, routing, security) can be used independently |
| **vpc_stack = Convenience Wrapper** | One module call creates your entire VPC infrastructure |
| **Declarative Subnets** | Subnets defined as a map (key = name) prevents index drift issues |
| **Flexible Configuration** | Toggle features on/off (NAT, IGW, Flow Logs) via variables |
| **Stable Resource Addressing** | Using `for_each` with named keys means adding/removing subnets won't recreate others |

---

## 📋 Prerequisites

Before using this module, ensure you have:

1. **Terraform installed** (version >= 1.5.0)
   ```bash
   terraform version
   ```

2. **AWS CLI configured** with appropriate credentials
   ```bash
   aws configure
   # Or use environment variables:
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   export AWS_REGION="us-east-1"
   ```

3. **AWS Provider** configured in your Terraform code

---

## 🚀 Quick Start

### Option 1: Using the vpc_stack Wrapper (Recommended)

The easiest way - one module creates everything:

```hcl
# main.tf
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc_stack" {
  source = "./modules/vpc_stack"  # Or use Git URL for remote

  name     = "my-vpc"
  vpc_cidr = "10.0.0.0/16"

  subnets = {
    public_a  = { cidr = "10.0.1.0/24", az = "us-east-1a", tier = "public" }
    public_b  = { cidr = "10.0.2.0/24", az = "us-east-1b", tier = "public" }
    private_a = { cidr = "10.0.11.0/24", az = "us-east-1a", tier = "private" }
    private_b = { cidr = "10.0.12.0/24", az = "us-east-1b", tier = "private" }
  }

  nat_mode = "single"  # Cost-saving for dev/test

  tags = {
    Environment = "dev"
    Project     = "my-project"
  }
}

# Access outputs
output "vpc_id" {
  value = module.vpc_stack.vpc_id
}
```

### Option 2: Clone and Run the Example

```bash
# Clone the repository
git clone https://github.com/YOUR_ORG/terraform-aws-vpc-stack.git
cd terraform-aws-vpc-stack/examples/simple-two-az

# Copy and customize variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# Initialize and apply
terraform init
terraform plan
terraform apply
```

---

## 📚 Step-by-Step Usage Guide

### Step 1: Define Your Network Architecture

First, plan your subnet layout. Use this pattern:

```
VPC CIDR: 10.0.0.0/16 (65,536 IPs)
├── Public Subnets (for load balancers, bastion hosts)
│   ├── public_a:  10.0.1.0/24  (256 IPs) - us-east-1a
│   └── public_b:  10.0.2.0/24  (256 IPs) - us-east-1b
│
└── Private Subnets (for application servers, databases)
    ├── private_a: 10.0.11.0/24 (256 IPs) - us-east-1a
    └── private_b: 10.0.12.0/24 (256 IPs) - us-east-1b
```

### Step 2: Create Your Terraform Configuration

Create a new directory for your project:

```bash
mkdir my-infrastructure && cd my-infrastructure
```

Create `main.tf`:

```hcl
terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  # Optional: Configure remote state
  # backend "s3" {
  #   bucket = "my-terraform-state"
  #   key    = "vpc/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# VPC STACK - Creates complete VPC infrastructure
# ─────────────────────────────────────────────────────────────────────────────

module "vpc_stack" {
  # For local development:
  source = "../path/to/terraform/modules/vpc_stack"
  
  # For remote Git repository (recommended for teams):
  # source = "git::https://github.com/YOUR_ORG/terraform-aws-vpc-stack.git//modules/vpc_stack?ref=v1.0.0"

  name     = var.vpc_name
  vpc_cidr = var.vpc_cidr
  subnets  = var.subnets
  nat_mode = var.nat_mode

  # Optional: Add security groups
  security_groups = var.security_groups

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
```

### Step 3: Define Variables

Create `variables.tf`:

```hcl
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "vpc_name" {
  description = "Name prefix for VPC resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnets" {
  description = "Subnet definitions"
  type = map(object({
    cidr = string
    az   = string
    tier = string
  }))
}

variable "nat_mode" {
  description = "NAT Gateway mode: single (cheaper) or one_per_az (HA)"
  type        = string
  default     = "single"
}

variable "security_groups" {
  description = "Security group definitions"
  type = map(object({
    description = string
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = optional(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = optional(string)
    }))
  }))
  default = {}
}
```

### Step 4: Create Variable Values

Create `terraform.tfvars`:

```hcl
aws_region   = "us-east-1"
environment  = "dev"
project_name = "my-app"
vpc_name     = "my-app-vpc"
vpc_cidr     = "10.0.0.0/16"

subnets = {
  # Public subnets - for ALB, NAT Gateway, Bastion
  public_a  = { cidr = "10.0.1.0/24", az = "us-east-1a", tier = "public" }
  public_b  = { cidr = "10.0.2.0/24", az = "us-east-1b", tier = "public" }
  
  # Private subnets - for EC2, ECS, RDS
  private_a = { cidr = "10.0.11.0/24", az = "us-east-1a", tier = "private" }
  private_b = { cidr = "10.0.12.0/24", az = "us-east-1b", tier = "private" }
}

nat_mode = "single"  # Use "one_per_az" for production

security_groups = {
  web = {
    description = "Allow HTTP/HTTPS traffic"
    ingress = [
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTP"
      },
      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTPS"
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "All outbound"
      }
    ]
  }

  app = {
    description = "Application servers"
    ingress = [
      {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
        description = "App port from VPC"
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "All outbound"
      }
    ]
  }
}
```

### Step 5: Define Outputs

Create `outputs.tf`:

```hcl
output "vpc_id" {
  description = "VPC ID - use this to reference the VPC in other resources"
  value       = module.vpc_stack.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs - use for ALB, bastion hosts"
  value       = module.vpc_stack.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs - use for EC2, ECS, RDS"
  value       = module.vpc_stack.private_subnet_ids
}

output "security_group_ids" {
  description = "Security group IDs"
  value       = module.vpc_stack.security_group_ids
}

output "nat_public_ips" {
  description = "NAT Gateway public IPs - add to allowlists"
  value       = module.vpc_stack.nat_public_ips
}
```

### Step 6: Deploy

```bash
# Initialize Terraform (downloads providers and modules)
terraform init

# Preview changes
terraform plan

# Apply changes (type 'yes' to confirm)
terraform apply

# View outputs
terraform output
```

### Step 7: Use the VPC in Other Resources

After creating the VPC, reference its outputs:

```hcl
# Example: Create an EC2 instance in the private subnet
resource "aws_instance" "app_server" {
  ami           = "ami-0123456789abcdef0"
  instance_type = "t3.micro"
  
  # Reference subnet from vpc_stack output
  subnet_id = module.vpc_stack.private_subnet_ids["private_a"]
  
  # Reference security group from vpc_stack output
  vpc_security_group_ids = [module.vpc_stack.security_group_ids["app"]]

  tags = {
    Name = "app-server"
  }
}

# Example: Create an ALB in public subnets
resource "aws_lb" "web" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.vpc_stack.security_group_ids["web"]]
  
  # Use all public subnets
  subnets = values(module.vpc_stack.public_subnet_ids)
}
```

---

## ⚙️ Configuration Options

### Required Variables

| Variable | Type | Description |
|----------|------|-------------|
| `name` | string | Name prefix for all resources (e.g., "my-app-vpc") |
| `vpc_cidr` | string | CIDR block for the VPC (e.g., "10.0.0.0/16") |
| `subnets` | map(object) | Subnet definitions (see format below) |

### Optional Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `nat_mode` | string | `"one_per_az"` | `"single"` (cheaper) or `"one_per_az"` (HA) |
| `create_igw` | bool | `true` | Create Internet Gateway |
| `create_nat` | bool | `true` | Create NAT Gateway(s) |
| `enable_flow_logs` | bool | `false` | Enable VPC Flow Logs for auditing |
| `flow_log_destination` | string | `null` | ARN of CloudWatch Log Group or S3 bucket |
| `security_groups` | map(object) | `{}` | Security group definitions |
| `nacls` | map(object) | `{}` | Network ACL definitions (optional) |
| `ec2_instances` | map(object) | `{}` | EC2 instance definitions |
| `tags` | map(string) | `{}` | Tags applied to all resources |

### Subnet Definition Format

Subnets are defined as a map where the **key becomes the subnet name**:

```hcl
subnets = {
  # Key format: descriptive_name
  # This key is used in resource names and output references
  
  public_a = {
    cidr = "10.0.1.0/24"    # Subnet CIDR block (must be within VPC CIDR)
    az   = "us-east-1a"     # Availability Zone
    tier = "public"         # "public" = gets public IP, "private" = no public IP
  }
  
  public_b = {
    cidr = "10.0.2.0/24"
    az   = "us-east-1b"
    tier = "public"
  }
  
  private_a = {
    cidr = "10.0.11.0/24"
    az   = "us-east-1a"
    tier = "private"
  }
  
  private_b = {
    cidr = "10.0.12.0/24"
    az   = "us-east-1b"
    tier = "private"
  }
}
```

**Why this format?**
- **Stable addressing**: Adding/removing subnets doesn't force recreation of others
- **Clear references**: `module.vpc_stack.private_subnet_ids["private_a"]`
- **Self-documenting**: Subnet purpose is clear from the key name

### Security Group Definition Format

```hcl
security_groups = {
  # Key becomes the security group name
  web = {
    description = "Allow web traffic"
    
    ingress = [
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"           # tcp, udp, icmp, or -1 for all
        cidr_blocks = ["0.0.0.0/0"]   # Who can access
        description = "HTTP access"   # Optional but recommended
      },
      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "HTTPS access"
      }
    ]
    
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"            # -1 = all protocols
        cidr_blocks = ["0.0.0.0/0"]   # Allow all outbound
        description = "All outbound traffic"
      }
    ]
  }
  
  database = {
    description = "Database access from app tier only"
    ingress = [
      {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = ["10.0.11.0/24", "10.0.12.0/24"]  # Only private subnets
        description = "PostgreSQL from private subnets"
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}
```

### EC2 Instance Definition Format (Optional)

```hcl
ec2_instances = {
  bastion = {
    ami                  = "ami-0123456789abcdef0"
    instance_type        = "t3.micro"
    subnet_id            = "subnet-xxx"  # Or reference: module.vpc_stack.public_subnet_ids["public_a"]
    security_group_ids   = ["sg-xxx"]
    key_name             = "my-key"
    allocate_eip         = true          # Assign Elastic IP
    root_volume_size     = 20
    root_volume_type     = "gp3"
    root_volume_encrypted = true
    require_imdsv2       = true          # Security best practice
  }
  
  app_server = {
    ami                = "ami-0123456789abcdef0"
    instance_type      = "t3.medium"
    subnet_id          = "subnet-xxx"
    security_group_ids = ["sg-xxx"]
    user_data          = file("scripts/bootstrap.sh")
  }
}
```

---

## 📋 Module Outputs

### VPC Outputs

| Output | Type | Description | Example Usage |
|--------|------|-------------|---------------|
| `vpc_id` | string | ID of the VPC | `module.vpc_stack.vpc_id` |
| `vpc_cidr` | string | CIDR block of the VPC | `module.vpc_stack.vpc_cidr` |
| `igw_id` | string | ID of the Internet Gateway | `module.vpc_stack.igw_id` |

### Subnet Outputs

| Output | Type | Description | Example Usage |
|--------|------|-------------|---------------|
| `subnet_ids` | map(string) | All subnet names → IDs | `module.vpc_stack.subnet_ids["public_a"]` |
| `public_subnet_ids` | map(string) | Public subnet names → IDs | `values(module.vpc_stack.public_subnet_ids)` |
| `private_subnet_ids` | map(string) | Private subnet names → IDs | `module.vpc_stack.private_subnet_ids["private_a"]` |

### Routing Outputs

| Output | Type | Description |
|--------|------|-------------|
| `nat_gateway_ids` | map(string) | Map of AZ → NAT Gateway ID |
| `nat_public_ips` | map(string) | Map of AZ → NAT Gateway public IP |
| `public_route_table_id` | string | Public route table ID |
| `private_route_table_ids` | map(string) | Map of AZ → private route table ID |

### Security Outputs

| Output | Type | Description | Example Usage |
|--------|------|-------------|---------------|
| `security_group_ids` | map(string) | SG names → IDs | `module.vpc_stack.security_group_ids["web"]` |
| `nacl_ids` | map(string) | NACL names → IDs | `module.vpc_stack.nacl_ids["public"]` |

### How to Use Outputs

```hcl
# Get a specific subnet ID
resource "aws_instance" "app" {
  subnet_id = module.vpc_stack.private_subnet_ids["private_a"]
  # ...
}

# Get all public subnet IDs as a list (for ALB)
resource "aws_lb" "web" {
  subnets = values(module.vpc_stack.public_subnet_ids)
  # ...
}

# Reference security group
resource "aws_instance" "web" {
  vpc_security_group_ids = [module.vpc_stack.security_group_ids["web"]]
  # ...
}

# Get NAT Gateway public IPs (for external allowlists)
output "nat_ips_for_allowlist" {
  value = values(module.vpc_stack.nat_public_ips)
}
```

---

## 🔧 NAT Gateway Modes

NAT Gateways allow private subnets to access the internet (for updates, API calls, etc.) while remaining inaccessible from the internet.

### `single` Mode (Cost-Saving)

```
┌─────────────────────────────────────────────────────────────┐
│                         VPC                                  │
│  ┌─────────────────┐         ┌─────────────────┐            │
│  │   us-east-1a    │         │   us-east-1b    │            │
│  │                 │         │                 │            │
│  │ ┌─────────────┐ │         │ ┌─────────────┐ │            │
│  │ │  Public     │ │         │ │  Public     │ │            │
│  │ │  Subnet     │ │         │ │  Subnet     │ │            │
│  │ │             │ │         │ │             │ │            │
│  │ │ [NAT GW]────┼─┼─────────┼─┼─────────────┼─┼──► Internet│
│  │ └─────────────┘ │         │ └─────────────┘ │            │
│  │                 │         │                 │            │
│  │ ┌─────────────┐ │         │ ┌─────────────┐ │            │
│  │ │  Private    │ │         │ │  Private    │ │            │
│  │ │  Subnet     │─┼─────────┼─▶  Subnet     │ │            │
│  │ │ (routes to  │ │   All   │ │ (routes to  │ │            │
│  │ │  NAT in 1a) │ │ traffic │ │  NAT in 1a) │ │            │
│  │ └─────────────┘ │         │ └─────────────┘ │            │
│  └─────────────────┘         └─────────────────┘            │
└─────────────────────────────────────────────────────────────┘
```

**Characteristics:**
- ✅ **Cost**: ~$32/month (1 NAT Gateway)
- ✅ **Simple**: Single point of egress
- ❌ **Single point of failure**: If AZ-a fails, private subnets in AZ-b lose internet access
- ❌ **Cross-AZ traffic**: Data transfer charges between AZs

**Use for:** Development, testing, non-critical workloads

```hcl
nat_mode = "single"
```

### `one_per_az` Mode (High Availability)

```
┌─────────────────────────────────────────────────────────────┐
│                         VPC                                  │
│  ┌─────────────────┐         ┌─────────────────┐            │
│  │   us-east-1a    │         │   us-east-1b    │            │
│  │                 │         │                 │            │
│  │ ┌─────────────┐ │         │ ┌─────────────┐ │            │
│  │ │  Public     │ │         │ │  Public     │ │            │
│  │ │  Subnet     │ │         │ │  Subnet     │ │            │
│  │ │             │ │         │ │             │ │            │
│  │ │ [NAT GW]────┼─┼──────────┼─┼─────────────┼─┼──► Internet│
│  │ └─────────────┘ │         │ │ [NAT GW]────┼─┼──► Internet│
│  │                 │         │ └─────────────┘ │            │
│  │ ┌─────────────┐ │         │ ┌─────────────┐ │            │
│  │ │  Private    │ │         │ │  Private    │ │            │
│  │ │  Subnet     │ │         │ │  Subnet     │ │            │
│  │ │ (routes to  │ │         │ │ (routes to  │ │            │
│  │ │  local NAT) │ │         │ │  local NAT) │ │            │
│  │ └──────┬──────┘ │         │ └──────┬──────┘ │            │
│  │        │        │         │        │        │            │
│  │        ▼        │         │        ▼        │            │
│  │    NAT in 1a    │         │    NAT in 1b    │            │
│  └─────────────────┘         └─────────────────┘            │
└─────────────────────────────────────────────────────────────┘
```

**Characteristics:**
- ✅ **High availability**: Each AZ is independent
- ✅ **No cross-AZ traffic**: Lower latency, no data transfer charges
- ❌ **Cost**: ~$64/month (2 NAT Gateways for 2 AZs)

**Use for:** Production workloads, anything requiring high availability

```hcl
nat_mode = "one_per_az"
```

### Cost Comparison

| Mode | NAT Gateways | Monthly Cost* | Best For |
|------|--------------|---------------|----------|
| `single` | 1 | ~$32 | Dev/Test |
| `one_per_az` (2 AZs) | 2 | ~$64 | Production |
| `one_per_az` (3 AZs) | 3 | ~$96 | Production |

*Cost = $0.045/hour × 720 hours/month, plus data processing charges

---

## 📦 Using Individual Submodules

For maximum flexibility, you can use submodules independently instead of the wrapper.

### When to Use Submodules Directly

| Scenario | Recommendation |
|----------|----------------|
| Standard VPC setup | Use `vpc_stack` wrapper |
| Need custom routing logic | Use individual submodules |
| Integrating with existing VPC | Use specific submodules |
| Learning/understanding the code | Start with individual submodules |

### Example: Building VPC Step by Step

```hcl
# ─────────────────────────────────────────────────────────────────────────────
# Step 1: Create VPC
# ─────────────────────────────────────────────────────────────────────────────
module "vpc" {
  source = "git::https://github.com/YOUR_ORG/terraform-aws-vpc-stack.git//modules/network/vpc?ref=v1.0.0"
  
  name = "my-vpc"
  cidr = "10.0.0.0/16"
  
  # Optional: Enable VPC Flow Logs
  enable_flow_logs     = true
  flow_log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  flow_log_role_arn    = aws_iam_role.vpc_flow_logs.arn
  
  tags = {
    Environment = "dev"
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# Step 2: Create Subnets
# ─────────────────────────────────────────────────────────────────────────────
module "subnets" {
  source = "git::https://github.com/YOUR_ORG/terraform-aws-vpc-stack.git//modules/network/subnets?ref=v1.0.0"
  
  name   = "my-vpc"
  vpc_id = module.vpc.vpc_id
  
  subnets = {
    public_a  = { cidr = "10.0.1.0/24", az = "us-east-1a", tier = "public" }
    public_b  = { cidr = "10.0.2.0/24", az = "us-east-1b", tier = "public" }
    private_a = { cidr = "10.0.11.0/24", az = "us-east-1a", tier = "private" }
    private_b = { cidr = "10.0.12.0/24", az = "us-east-1b", tier = "private" }
  }
  
  tags = {
    Environment = "dev"
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# Step 3: Create Routing (NAT Gateways + Route Tables)
# ─────────────────────────────────────────────────────────────────────────────
locals {
  # Transform subnet outputs for the routing module
  public_subnets = {
    for k, id in module.subnets.public_subnet_ids :
    k => { id = id, az = local.subnet_config[k].az }
  }
  private_subnets = {
    for k, id in module.subnets.private_subnet_ids :
    k => { id = id, az = local.subnet_config[k].az }
  }
  subnet_config = {
    public_a  = { az = "us-east-1a" }
    public_b  = { az = "us-east-1b" }
    private_a = { az = "us-east-1a" }
    private_b = { az = "us-east-1b" }
  }
}

module "routing" {
  source = "git::https://github.com/YOUR_ORG/terraform-aws-vpc-stack.git//modules/network/routing?ref=v1.0.0"
  
  name            = "my-vpc"
  vpc_id          = module.vpc.vpc_id
  igw_id          = module.vpc.igw_id
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
  nat_mode        = "single"
  
  tags = {
    Environment = "dev"
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# Step 4: Create Security Groups
# ─────────────────────────────────────────────────────────────────────────────
module "security" {
  source = "git::https://github.com/YOUR_ORG/terraform-aws-vpc-stack.git//modules/network/security?ref=v1.0.0"
  
  name   = "my-vpc"
  vpc_id = module.vpc.vpc_id
  
  security_groups = {
    web = {
      description = "Web servers"
      ingress = [
        { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
      ]
      egress = [
        { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
      ]
    }
  }
  
  tags = {
    Environment = "dev"
  }
}
```

---

## 🌍 Real-World Examples

### Example 1: Development Environment (Cost-Optimized)

```hcl
module "dev_vpc" {
  source = "./modules/vpc_stack"
  
  name     = "dev-vpc"
  vpc_cidr = "10.0.0.0/16"
  
  # Minimal subnets - 1 per tier
  subnets = {
    public  = { cidr = "10.0.1.0/24", az = "us-east-1a", tier = "public" }
    private = { cidr = "10.0.11.0/24", az = "us-east-1a", tier = "private" }
  }
  
  nat_mode   = "single"    # Save money
  create_nat = true        # Still need NAT for private subnet
  
  tags = { Environment = "dev" }
}
```

**Monthly cost estimate:** ~$35 (1 NAT Gateway)

### Example 2: Production Environment (High Availability)

```hcl
module "prod_vpc" {
  source = "./modules/vpc_stack"
  
  name     = "prod-vpc"
  vpc_cidr = "10.0.0.0/16"
  
  # Multi-AZ for high availability
  subnets = {
    public_a   = { cidr = "10.0.1.0/24", az = "us-east-1a", tier = "public" }
    public_b   = { cidr = "10.0.2.0/24", az = "us-east-1b", tier = "public" }
    public_c   = { cidr = "10.0.3.0/24", az = "us-east-1c", tier = "public" }
    private_a  = { cidr = "10.0.11.0/24", az = "us-east-1a", tier = "private" }
    private_b  = { cidr = "10.0.12.0/24", az = "us-east-1b", tier = "private" }
    private_c  = { cidr = "10.0.13.0/24", az = "us-east-1c", tier = "private" }
  }
  
  nat_mode         = "one_per_az"  # HA - each AZ independent
  enable_flow_logs = true          # Audit trail
  
  security_groups = {
    alb = {
      description = "Application Load Balancer"
      ingress = [
        { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
      ]
      egress = [
        { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
      ]
    }
    app = {
      description = "Application servers"
      ingress = [
        { from_port = 8080, to_port = 8080, protocol = "tcp", cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] }
      ]
      egress = [
        { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
      ]
    }
    rds = {
      description = "Database"
      ingress = [
        { from_port = 5432, to_port = 5432, protocol = "tcp", cidr_blocks = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"] }
      ]
      egress = [
        { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
      ]
    }
  }
  
  tags = {
    Environment = "production"
    CostCenter  = "engineering"
  }
}
```

**Monthly cost estimate:** ~$100 (3 NAT Gateways)

### Example 3: Private-Only VPC (No Internet Access)

```hcl
module "isolated_vpc" {
  source = "./modules/vpc_stack"
  
  name     = "isolated-vpc"
  vpc_cidr = "10.100.0.0/16"
  
  subnets = {
    private_a = { cidr = "10.100.1.0/24", az = "us-east-1a", tier = "private" }
    private_b = { cidr = "10.100.2.0/24", az = "us-east-1b", tier = "private" }
  }
  
  create_igw = false  # No internet gateway
  create_nat = false  # No NAT gateway
  
  # Use VPC endpoints for AWS services instead
  tags = { Environment = "isolated" }
}
```

**Monthly cost estimate:** ~$0 (no NAT, no IGW)

---

## 🏷️ Version Tagging

Use semantic versioning to ensure stable, reproducible deployments.

### Creating Releases

```bash
# Tag a new release
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0

# Tag a minor update
git tag -a v1.1.0 -m "Added VPC Flow Logs support"
git push origin v1.1.0

# Tag a patch
git tag -a v1.1.1 -m "Fixed NAT Gateway routing"
git push origin v1.1.1
```

### Consuming Specific Versions

```hcl
# Pin to exact version (recommended for production)
module "vpc_stack" {
  source = "git::https://github.com/YOUR_ORG/terraform-aws-vpc-stack.git//modules/vpc_stack?ref=v1.0.0"
  # ...
}

# Use latest patch in v1.x line
module "vpc_stack" {
  source = "git::https://github.com/YOUR_ORG/terraform-aws-vpc-stack.git//modules/vpc_stack?ref=v1"
  # ...
}

# Use specific commit (for debugging)
module "vpc_stack" {
  source = "git::https://github.com/YOUR_ORG/terraform-aws-vpc-stack.git//modules/vpc_stack?ref=abc1234"
  # ...
}
```

### Version Upgrade Process

```bash
# 1. Update the version in your source
# Change: ?ref=v1.0.0  →  ?ref=v1.1.0

# 2. Re-initialize to download new version
terraform init -upgrade

# 3. Preview changes
terraform plan

# 4. Apply if changes look correct
terraform apply
```

---

## 📝 Examples

See the [examples/](./examples/) directory for complete working examples:

| Example | Description | Use Case |
|---------|-------------|----------|
| [simple-two-az](./examples/simple-two-az/) | Basic 2-AZ VPC with public/private subnets | Getting started, dev/test |

### Running an Example

```bash
cd examples/simple-two-az

# Copy and customize variables
cp terraform.tfvars.example terraform.tfvars
vim terraform.tfvars

# Deploy
terraform init
terraform plan
terraform apply
```

---

## 🔐 Security Best Practices

### 1. Restrict SSH Access

**❌ Don't do this in production:**
```hcl
cidr_blocks = ["0.0.0.0/0"]  # Allows SSH from anywhere!
```

**✅ Do this instead:**
```hcl
cidr_blocks = ["YOUR_OFFICE_IP/32", "YOUR_VPN_IP/32"]
```

### 2. Enable VPC Flow Logs

```hcl
module "vpc_stack" {
  # ...
  
  enable_flow_logs          = true
  flow_log_destination      = aws_cloudwatch_log_group.vpc.arn
  flow_log_destination_type = "cloud-watch-logs"
  flow_log_traffic_type     = "ALL"  # or "REJECT" for only denied traffic
}
```

### 3. Use Security Groups, Not NACLs (Usually)

Security Groups are:
- Stateful (return traffic automatically allowed)
- Easier to manage
- Applied at instance level

Use NACLs only when you need:
- Subnet-level blocking
- Explicit deny rules
- Compliance requirements

### 4. IMDSv2 for EC2 (Enabled by Default)

The EC2 module enforces IMDSv2 by default to prevent SSRF attacks:

```hcl
ec2_instances = {
  web = {
    # ...
    require_imdsv2 = true  # Default, but explicit is good
  }
}
```

### 5. Encrypt EBS Volumes (Enabled by Default)

```hcl
ec2_instances = {
  web = {
    # ...
    root_volume_encrypted = true  # Default
  }
}
```

### 6. Principle of Least Privilege

```hcl
security_groups = {
  database = {
    description = "Database access"
    ingress = [
      {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        # Only allow from private subnets, not entire VPC
        cidr_blocks = ["10.0.11.0/24", "10.0.12.0/24"]
      }
    ]
    # ...
  }
}
```

---

## 🔧 Troubleshooting

### Common Issues

#### 1. "NAT Gateway not found" Error

**Problem:** Private subnets can't reach internet

**Solution:** Ensure `create_nat = true` and public subnets exist:
```hcl
create_nat = true  # Must be true

subnets = {
  public_a = { ... tier = "public" }  # NAT needs a public subnet
  private_a = { ... tier = "private" }
}
```

#### 2. Subnets Being Recreated

**Problem:** Adding a new subnet causes others to be destroyed/recreated

**Solution:** Use named keys (this module does this correctly):
```hcl
# ✅ Correct - stable addressing
subnets = {
  public_a = { ... }   # Adding public_c won't affect this
  public_b = { ... }
}

# ❌ Wrong - index-based (not used in this module)
subnets = [
  { name = "public_a", ... },  # Adding items shifts indexes
]
```

#### 3. "CIDR block conflicts with existing subnet"

**Problem:** Subnet CIDR overlaps with existing subnet

**Solution:** Ensure all CIDRs are unique and within VPC CIDR:
```hcl
vpc_cidr = "10.0.0.0/16"  # Contains 10.0.0.0 - 10.0.255.255

subnets = {
  public_a  = { cidr = "10.0.1.0/24", ... }   # ✅ Within VPC
  public_b  = { cidr = "10.0.2.0/24", ... }   # ✅ No overlap
  private_a = { cidr = "10.0.1.0/24", ... }   # ❌ Conflicts with public_a!
}
```

#### 4. "Error: Invalid availability zone"

**Problem:** Specified AZ doesn't exist in region

**Solution:** Use valid AZs for your region:
```bash
# List available AZs
aws ec2 describe-availability-zones --region us-east-1
```

```hcl
# Use correct AZ names
subnets = {
  public_a = { cidr = "10.0.1.0/24", az = "us-east-1a", ... }  # ✅
  public_b = { cidr = "10.0.2.0/24", az = "us-east-1z", ... }  # ❌ Doesn't exist
}
```

#### 5. "Access Denied" or Permission Errors

**Problem:** AWS credentials lack required permissions

**Solution:** Ensure IAM user/role has these permissions:
- `ec2:*Vpc*`
- `ec2:*Subnet*`
- `ec2:*RouteTable*`
- `ec2:*InternetGateway*`
- `ec2:*NatGateway*`
- `ec2:*SecurityGroup*`
- `ec2:*NetworkAcl*`
- `ec2:*Address*` (for Elastic IPs)

### Getting Help

1. Check Terraform output for specific error messages
2. Run `terraform plan` to see what would change
3. Use `terraform state list` to see current resources
4. Enable debug logging: `TF_LOG=DEBUG terraform plan`

---

## 📄 License

MIT License - see [LICENSE](./LICENSE) for details.

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes
4. Test with `terraform validate` and `terraform plan`
5. Submit a pull request

---

## 📚 Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC User Guide](https://docs.aws.amazon.com/vpc/latest/userguide/)
- [Terraform Module Best Practices](https://www.terraform.io/docs/language/modules/develop/index.html)
