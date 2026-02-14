<div align="center">

<img src="https://img.shields.io/badge/Terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform"/>
<img src="https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazonaws&logoColor=white" alt="AWS"/>

<br/><br/>

# AWS Terraform Modules

### 18 Production Ready, Reusable Modules

<br/>

<img src="https://img.shields.io/badge/Modules-18-FF9900?style=flat-square" alt="Modules"/>
<img src="https://img.shields.io/badge/Provider-AWS-232F3E?style=flat-square&logo=amazonaws" alt="AWS"/>
<img src="https://img.shields.io/badge/Terraform-%3E%3D1.5.0-purple?style=flat-square&logo=terraform" alt="Terraform"/>

</div>

<br/>

## What Are Terraform Modules?

A **Terraform module** is a reusable, self contained package of Terraform configuration files that provisions a specific piece of infrastructure. Instead of writing the same resource blocks over and over, you write them once as a module and call that module wherever you need it.

Each module in this collection contains:

| File | Purpose |
|:---|:---|
| `variables.tf` | Input variables the module accepts |
| `main.tf` | The actual resource definitions |
| `outputs.tf` | Values the module exposes after creation |

**Benefits:**
- Write once, reuse everywhere
- Consistent infrastructure across environments
- Easier to maintain, test, and review
- Reduces code duplication

---

## Available Modules

| # | Module | Description |
|:---:|:---|:---|
| 1 | [vpc](./vpc/) | VPC with public/private subnets, Internet Gateway, NAT Gateway, route tables |
| 2 | [ec2](./ec2/) | EC2 instance with IMDSv2, encrypted root EBS volume |
| 3 | [security-group](./security-group/) | Security Group with dynamic ingress and egress rules |
| 4 | [s3](./s3/) | S3 bucket with versioning, encryption, lifecycle rules, public access block |
| 5 | [rds](./rds/) | RDS instance with subnet group, multi AZ support |
| 6 | [iam-role](./iam-role/) | IAM role with managed and inline policy attachments |
| 7 | [alb](./alb/) | Application Load Balancer with target group and listener |
| 8 | [eks](./eks/) | EKS cluster with managed node group and IAM roles |
| 9 | [ecs](./ecs/) | ECS Fargate cluster with task definition, service, CloudWatch logs |
| 10 | [lambda](./lambda/) | Lambda function with IAM role and CloudWatch log group |
| 11 | [cloudfront](./cloudfront/) | CloudFront distribution with S3 or custom origin |
| 12 | [route53](./route53/) | Route 53 hosted zone with standard and alias records |
| 13 | [asg](./asg/) | Auto Scaling Group with launch template and target tracking policy |
| 14 | [sns](./sns/) | SNS topic with email, SQS, and Lambda subscriptions |
| 15 | [sqs](./sqs/) | SQS queue with dead letter queue and redrive policy |
| 16 | [dynamodb](./dynamodb/) | DynamoDB table with GSI, TTL, encryption, point in time recovery |
| 17 | [secrets-manager](./secrets-manager/) | Secrets Manager secret with JSON or plaintext value |
| 18 | [elasticache](./elasticache/) | ElastiCache Redis/Memcached cluster with subnet group |

---

## How to Use a Module

### Basic Syntax

```hcl
module "<name>" {
  source = "./path/to/module"

  # pass the required variables
  variable_1 = "value"
  variable_2 = "value"
}
```

### Step by Step

**1. Reference the module** in your root `main.tf` using the `source` path.

**2. Pass the required variables** that the module expects.

**3. Use the module outputs** to connect modules together or display results.

```hcl
# Step 1 & 2: Call the module and pass variables
module "my_vpc" {
  source = "./Modules/vpc"

  vpc_name           = "production-vpc"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.10.0/24", "10.0.20.0/24"]
  enable_nat_gateway = true

  tags = {
    Environment = "production"
  }
}

# Step 3: Use outputs from the module
output "vpc_id" {
  value = module.my_vpc.vpc_id
}
```

---

## Usage Examples

### VPC + Security Group + EC2

A common pattern where modules connect to each other through outputs:

```hcl
module "vpc" {
  source = "./Modules/vpc"

  vpc_name           = "app-vpc"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.10.0/24", "10.0.20.0/24"]
  enable_nat_gateway = true
  tags               = { Environment = "dev" }
}

module "web_sg" {
  source = "./Modules/security-group"

  name   = "web-sg"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
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

  tags = { Environment = "dev" }
}

module "web_server" {
  source = "./Modules/ec2"

  instance_name       = "web-server"
  ami_id              = "ami-0c02fb55956c7d316"
  instance_type       = "t3.small"
  subnet_id           = module.vpc.public_subnet_ids[0]
  security_group_ids  = [module.web_sg.security_group_id]
  associate_public_ip = true
  key_name            = "my-key"
  tags                = { Environment = "dev" }
}
```

### S3 + CloudFront

```hcl
module "website_bucket" {
  source = "./Modules/s3"

  bucket_name        = "my-static-website-bucket"
  enable_versioning  = true
  enable_encryption  = true
  block_public_access = true
  tags               = { Environment = "production" }
}

module "cdn" {
  source = "./Modules/cloudfront"

  origin_domain_name     = module.website_bucket.bucket_regional_domain_name
  origin_id              = "s3-website"
  default_root_object    = "index.html"
  viewer_protocol_policy = "redirect-to-https"
  price_class            = "PriceClass_100"
  tags                   = { Environment = "production" }
}
```

### RDS + Secrets Manager

```hcl
module "db_secret" {
  source = "./Modules/secrets-manager"

  secret_name = "production-db-credentials"
  description = "RDS database credentials"

  secret_map = {
    username = "admin"
    password = "SuperSecretPass123!"
  }

  tags = { Environment = "production" }
}

module "database" {
  source = "./Modules/rds"

  identifier         = "production-db"
  engine             = "mysql"
  engine_version     = "8.0"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  db_name            = "appdb"
  username           = "admin"
  password           = "SuperSecretPass123!"
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.db_sg.security_group_id]
  multi_az           = true
  tags               = { Environment = "production" }
}
```

### EKS Cluster

```hcl
module "eks" {
  source = "./Modules/eks"

  cluster_name         = "production-cluster"
  cluster_version      = "1.29"
  subnet_ids           = module.vpc.private_subnet_ids
  node_instance_types  = ["t3.medium"]
  node_desired_size    = 3
  node_min_size        = 2
  node_max_size        = 6
  tags                 = { Environment = "production" }
}
```

### ALB + ASG

```hcl
module "alb" {
  source = "./Modules/alb"

  name               = "web-alb"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [module.alb_sg.security_group_id]
  health_check_path  = "/health"
  tags               = { Environment = "production" }
}

module "asg" {
  source = "./Modules/asg"

  name               = "web-asg"
  ami_id             = "ami-0c02fb55956c7d316"
  instance_type      = "t3.small"
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.app_sg.security_group_id]
  target_group_arns  = [module.alb.target_group_arn]
  min_size           = 2
  max_size           = 8
  desired_capacity   = 3
  health_check_type  = "ELB"
  tags               = { Environment = "production" }
}
```

### Lambda + SNS + SQS

```hcl
module "queue" {
  source = "./Modules/sqs"

  queue_name      = "order-processing"
  enable_dlq      = true
  max_receive_count = 3
  tags            = { Environment = "production" }
}

module "notifications" {
  source = "./Modules/sns"

  topic_name  = "order-alerts"
  protocol    = "email"
  subscribers = ["alerts@example.com"]
  tags        = { Environment = "production" }
}

module "processor" {
  source = "./Modules/lambda"

  function_name = "order-processor"
  runtime       = "python3.12"
  handler       = "lambda_function.lambda_handler"
  source_path   = "./src/lambda.zip"
  timeout       = 60
  memory_size   = 256

  environment_variables = {
    QUEUE_URL = module.queue.queue_url
    SNS_TOPIC = module.notifications.topic_arn
  }

  tags = { Environment = "production" }
}
```

### DynamoDB

```hcl
module "table" {
  source = "./Modules/dynamodb"

  table_name   = "orders"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "order_id"
  range_key    = "created_at"

  attributes = [
    { name = "order_id",   type = "S" },
    { name = "created_at", type = "S" },
    { name = "customer_id", type = "S" }
  ]

  global_secondary_indexes = [{
    name     = "customer-index"
    hash_key = "customer_id"
  }]

  ttl_attribute                 = "expires_at"
  enable_point_in_time_recovery = true
  tags                          = { Environment = "production" }
}
```

### Route 53 + ElastiCache

```hcl
module "dns" {
  source = "./Modules/route53"

  zone_name = "example.com"

  records = [
    { name = "www", type = "A",     ttl = 300, records = ["1.2.3.4"] },
    { name = "api", type = "CNAME", ttl = 300, records = ["api-lb.example.com"] }
  ]

  tags = { Environment = "production" }
}

module "cache" {
  source = "./Modules/elasticache"

  cluster_name       = "app-cache"
  engine             = "redis"
  engine_version     = "7.0"
  node_type          = "cache.t3.micro"
  num_cache_nodes    = 1
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.cache_sg.security_group_id]
  tags               = { Environment = "production" }
}
```

---

## References

| Resource | Link |
|:---|:---|
| AWS Provider Docs | [registry.terraform.io/providers/hashicorp/aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) |
| Terraform Module Docs | [developer.hashicorp.com/terraform/language/modules](https://developer.hashicorp.com/terraform/language/modules) |
| AWS Documentation | [docs.aws.amazon.com](https://docs.aws.amazon.com/) |
