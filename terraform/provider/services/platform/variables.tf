variable "env" {
  type    = string
  default = "dev"
}

# variable "vpc_eks_id" {}

# variable "priv_snet1_id" {}

# variable "priv_snet2_id" {}

variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "common_tags" {
  type = map(any)
  default = {
    Name =  "Vincent"
  }
}

variable "cluster_name" {
  type    = string
  default = "platform-eks"
}

variable "k8s_version" {
  type    = string
  default = "1.26"
}

variable "cluster_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "platform" {
  type = map(string)
  default = {
    node_size = 2
    desired_size = 2
    max_size = 2
    min_size = 1
    ami = "ami-0a0f69a41ae022c92"
    instance_type = "t3.medium"
  }
}

variable "vpc_cicd_block" {
  type = string
  default = "222.252.30.8/32"
}

# variable "vpc_eks_block" {}

# variable "sg_cicd_vm_id" {

# }

# variable "route_table_eks_subnet_id" {}

variable "autoscaler_version" {
  default = "1.26"
}

# App VPC 
variable "app_name_tag" {
  type    = string
  default = "app-vpc"
}

# Internet gateway
variable "igw_name_tag" {
  type    = string
  default = "app-internet-gw"
}

# Data VPC
variable "data_name_tag" {
  type    = string
  default = "data-vpc"
}

variable "app_scg_name" {
  type    = string
  default = "app-scg"
}

variable "data_scg_name" {
  type    = string
  default = "data-scg"
}

# RDS
variable "rds_engine" {
  type    = string
  default = "mysql"
}

variable "rds_version" {
  type    = string
  default = "8.0.32"
}

variable "rds_instance" {
  type    = string
  default = "db.t3.micro"
}

variable "rds_allocated_storage" {
  type    = number
  default = 20
}

variable "rds_storage_type" {
  type    = string
  default = "gp2"
}

variable "rds_identifier" {
  type    = string
  default = "mydb"
}

variable "rds_username" {
  type    = string
  default = "admin"
}

variable "rds_password" {
  type    = string
  default = "12345678"
}

variable "rds_ca_cert" {
  type    = string
  default = "rds-ca-2019"
}
