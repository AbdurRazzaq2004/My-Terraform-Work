# AWS RDS Module

resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.identifier}-subnet-group"
  })
}

resource "aws_db_instance" "this" {
  identifier              = var.identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage > 0 ? var.max_allocated_storage : null
  db_name                 = var.db_name
  username                = var.username
  password                = var.password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = var.security_group_ids
  multi_az                = var.multi_az
  publicly_accessible     = var.publicly_accessible
  skip_final_snapshot     = var.skip_final_snapshot
  backup_retention_period = var.backup_retention_period
  storage_encrypted       = var.storage_encrypted

  tags = merge(var.tags, {
    Name = var.identifier
  })
}
