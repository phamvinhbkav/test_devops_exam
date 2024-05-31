module "rds" {
  source                 = "../../../modules/rds"
  engine                 = var.rds_engine
  engine_version         = var.rds_version
  instance_class         = var.rds_instance
  allocated_storage      = var.rds_allocated_storage
  storage_type           = var.rds_storage_type
  identifier             = var.rds_identifier
  username               = var.rds_username
  password               = var.rds_password
  ca_cert_identifier     = var.rds_ca_cert
  vpc_security_group_ids = [aws_security_group.data_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
}
