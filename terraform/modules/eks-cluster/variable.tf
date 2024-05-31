variable "region" {}

variable "cluster_name" {}

variable "env" {}

variable "vpc_id" {}

variable "priv_snet1_id" {}

variable "priv_snet2_id" {}

variable "cluster_log_types" {
  type = list(string)
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "k8s_version" {
  type = string
}

variable "vpc_cicd_block" {}

variable "vpc_eks_block" {}