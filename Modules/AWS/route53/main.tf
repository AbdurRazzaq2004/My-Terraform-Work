# AWS Route53 Module

resource "aws_route53_zone" "this" {
  name = var.zone_name

  dynamic "vpc" {
    for_each = var.is_private_zone && var.vpc_id != null ? [1] : []
    content {
      vpc_id = var.vpc_id
    }
  }

  tags = merge(var.tags, {
    Name = var.zone_name
  })
}

# Standard DNS records
resource "aws_route53_record" "standard" {
  for_each = {
    for r in var.records : "${r.name}-${r.type}" => r
    if r.alias == null
  }

  zone_id = aws_route53_zone.this.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records
}

# Alias DNS records
resource "aws_route53_record" "alias" {
  for_each = {
    for r in var.records : "${r.name}-${r.type}" => r
    if r.alias != null
  }

  zone_id = aws_route53_zone.this.zone_id
  name    = each.value.name
  type    = each.value.type

  alias {
    name                   = each.value.alias.name
    zone_id                = each.value.alias.zone_id
    evaluate_target_health = each.value.alias.evaluate_target_health
  }
}
