# ─────────────────────────────────────────────────────────────────────────────
# SECURITY GROUPS
# ─────────────────────────────────────────────────────────────────────────────

resource "aws_security_group" "this" {
  for_each = var.security_groups

  name        = "${var.name}-${each.key}"
  description = each.value.description
  vpc_id      = var.vpc_id

  tags = merge(var.tags, { Name = "${var.name}-${each.key}" })

  lifecycle {
    create_before_destroy = true
  }
}

# Flatten ingress rules for iteration
locals {
  sg_ingress_rules = flatten([
    for sg_key, sg in var.security_groups : [
      for idx, rule in sg.ingress : {
        sg_key      = sg_key
        rule_idx    = idx
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_blocks = rule.cidr_blocks
        description = lookup(rule, "description", null)
      }
    ]
  ])

  sg_egress_rules = flatten([
    for sg_key, sg in var.security_groups : [
      for idx, rule in sg.egress : {
        sg_key      = sg_key
        rule_idx    = idx
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr_blocks = rule.cidr_blocks
        description = lookup(rule, "description", null)
      }
    ]
  ])
}

resource "aws_security_group_rule" "ingress" {
  for_each = {
    for rule in local.sg_ingress_rules :
    "${rule.sg_key}-ingress-${rule.rule_idx}" => rule
  }

  type              = "ingress"
  security_group_id = aws_security_group.this[each.value.sg_key].id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  description       = each.value.description
}

resource "aws_security_group_rule" "egress" {
  for_each = {
    for rule in local.sg_egress_rules :
    "${rule.sg_key}-egress-${rule.rule_idx}" => rule
  }

  type              = "egress"
  security_group_id = aws_security_group.this[each.value.sg_key].id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  description       = each.value.description
}

# ─────────────────────────────────────────────────────────────────────────────
# NETWORK ACLs (Optional)
# ─────────────────────────────────────────────────────────────────────────────

resource "aws_network_acl" "this" {
  for_each = var.nacls

  vpc_id     = var.vpc_id
  subnet_ids = each.value.subnet_ids

  tags = merge(var.tags, { Name = "${var.name}-nacl-${each.key}" })
}

locals {
  nacl_ingress_rules = flatten([
    for nacl_key, nacl in var.nacls : [
      for rule in nacl.ingress : {
        nacl_key    = nacl_key
        rule_number = rule.rule_number
        protocol    = rule.protocol
        action      = rule.action
        cidr_block  = rule.cidr_block
        from_port   = rule.from_port
        to_port     = rule.to_port
      }
    ]
  ])

  nacl_egress_rules = flatten([
    for nacl_key, nacl in var.nacls : [
      for rule in nacl.egress : {
        nacl_key    = nacl_key
        rule_number = rule.rule_number
        protocol    = rule.protocol
        action      = rule.action
        cidr_block  = rule.cidr_block
        from_port   = rule.from_port
        to_port     = rule.to_port
      }
    ]
  ])
}

resource "aws_network_acl_rule" "ingress" {
  for_each = {
    for rule in local.nacl_ingress_rules :
    "${rule.nacl_key}-ingress-${rule.rule_number}" => rule
  }

  network_acl_id = aws_network_acl.this[each.value.nacl_key].id
  rule_number    = each.value.rule_number
  egress         = false
  protocol       = each.value.protocol
  rule_action    = each.value.action
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

resource "aws_network_acl_rule" "egress" {
  for_each = {
    for rule in local.nacl_egress_rules :
    "${rule.nacl_key}-egress-${rule.rule_number}" => rule
  }

  network_acl_id = aws_network_acl.this[each.value.nacl_key].id
  rule_number    = each.value.rule_number
  egress         = true
  protocol       = each.value.protocol
  rule_action    = each.value.action
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}
