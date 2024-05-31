variable "eks_cluster_security_group_id" {}

variable "eks_nodes_security_group_id" {}

variable "region" {}

variable "vpc_id" {}

variable "common_tags" {
  type    = map(string)
  default = {}
}

# variable "route_table_eks_subnet_id" {}

variable "env" {}

variable "priv_snet1_id" {}

variable "priv_snet2_id" {}
