variable "cluster_name" {
  type = string
}

variable "eks_cluster_security_group_id" {}

variable "eks_cluster_endpoint" {}

variable "eks_certificate_authority" {}

variable "node_size" {}

variable "ami" {}

variable "env" {}

variable "desired_size" {}

variable "max_size" {}

variable "min_size" {}

variable "name" {
  type = string
}

variable "vpc_id" {}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "autoscaler_enabled" {
  default = "enabled"
}

variable "asg_metrics" {
  type    = list(string)
  default = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

variable "priv_snet1_id" {}

variable "priv_snet2_id" {}

variable "vpc_cicd_block" {}

variable "sg_cicd_vm_id" {}

variable "eks_vpc_endpoint" {}

variable "mysql_cidr_blocks" {}

variable "instance_type" {}