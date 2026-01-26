# ─────────────────────────────────────────────────────────────────────────────
# EC2 INSTANCES
# ─────────────────────────────────────────────────────────────────────────────

resource "aws_instance" "this" {
  for_each = var.instances

  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = each.value.security_group_ids
  key_name               = each.value.key_name

  iam_instance_profile = each.value.iam_instance_profile

  user_data                   = each.value.user_data
  user_data_replace_on_change = each.value.user_data_replace_on_change

  # Root volume configuration
  root_block_device {
    volume_size           = each.value.root_volume_size
    volume_type           = each.value.root_volume_type
    encrypted             = each.value.root_volume_encrypted
    delete_on_termination = true
  }

  # Metadata options (IMDSv2)
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = each.value.require_imdsv2 ? "required" : "optional"
    http_put_response_hop_limit = 1
  }

  monitoring = each.value.detailed_monitoring

  tags = merge(var.tags, {
    Name = "${var.name}-${each.key}"
  })

  lifecycle {
    ignore_changes = [ami]
  }
}

# ─────────────────────────────────────────────────────────────────────────────
# ELASTIC IPs (Optional - for instances that need static public IPs)
# ─────────────────────────────────────────────────────────────────────────────

resource "aws_eip" "this" {
  for_each = { for k, v in var.instances : k => v if v.allocate_eip }

  instance = aws_instance.this[each.key].id
  domain   = "vpc"

  tags = merge(var.tags, { Name = "${var.name}-${each.key}-eip" })

  depends_on = [aws_instance.this]
}
