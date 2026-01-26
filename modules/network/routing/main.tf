locals {
  public_azs = distinct([for k, s in var.public_subnets : s.az])

  nat_azs = var.nat_mode == "one_per_az" ? local.public_azs : [local.public_azs[0]]

  # Pick one public subnet per AZ for NAT placement
  public_subnet_by_az = {
    for az in local.public_azs :
    az => one([for k, s in var.public_subnets : s.id if s.az == az])
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# PUBLIC ROUTING
# ─────────────────────────────────────────────────────────────────────────────

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags   = merge(var.tags, { Name = "${var.name}-rt-public" })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

resource "aws_route_table_association" "public" {
  for_each       = var.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# ─────────────────────────────────────────────────────────────────────────────
# NAT GATEWAYS
# ─────────────────────────────────────────────────────────────────────────────

resource "aws_eip" "nat" {
  for_each = var.create_nat ? toset(local.nat_azs) : toset([])
  domain   = "vpc"
  tags     = merge(var.tags, { Name = "${var.name}-nat-eip-${each.key}" })
}

resource "aws_nat_gateway" "this" {
  for_each      = var.create_nat ? toset(local.nat_azs) : toset([])
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = local.public_subnet_by_az[each.key]
  tags          = merge(var.tags, { Name = "${var.name}-nat-${each.key}" })

  depends_on = [aws_eip.nat]
}

# ─────────────────────────────────────────────────────────────────────────────
# PRIVATE ROUTING
# ─────────────────────────────────────────────────────────────────────────────

resource "aws_route_table" "private" {
  for_each = toset(distinct([for k, s in var.private_subnets : s.az]))
  vpc_id   = var.vpc_id
  tags     = merge(var.tags, { Name = "${var.name}-rt-private-${each.key}" })
}

resource "aws_route" "private_default" {
  for_each               = var.create_nat ? aws_route_table.private : {}
  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = var.nat_mode == "one_per_az" ? aws_nat_gateway.this[each.key].id : aws_nat_gateway.this[local.nat_azs[0]].id
}

resource "aws_route_table_association" "private" {
  for_each       = var.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.value.az].id
}
