resource "aws_security_group_rule" "security_group_rule" {
  type              = var.type
  to_port           = var.to_port
  protocol          = var.protocol
  prefix_list_ids   = var.prefix_list_ids
  from_port         = var.from_port
  security_group_id = var.security_group_id
}
