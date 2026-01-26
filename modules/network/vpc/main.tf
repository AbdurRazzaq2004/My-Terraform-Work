resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = var.name })
}

resource "aws_internet_gateway" "this" {
  count  = var.create_igw ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-igw" })
}

# Optional VPC Flow Logs
resource "aws_flow_log" "this" {
  count                = var.enable_flow_logs ? 1 : 0
  iam_role_arn         = var.flow_log_role_arn
  log_destination      = var.flow_log_destination
  log_destination_type = var.flow_log_destination_type
  traffic_type         = var.flow_log_traffic_type
  vpc_id               = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.name}-flow-log" })
}
