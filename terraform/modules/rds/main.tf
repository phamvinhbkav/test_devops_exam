resource "aws_db_instance" "myrds" {
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  identifier             = var.identifier
  username               = var.username
  password               = var.password
  publicly_accessible    = false
  skip_final_snapshot    = true
  ca_cert_identifier     = var.ca_cert_identifier
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name
}
