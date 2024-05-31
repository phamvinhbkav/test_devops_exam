module "eks" {
  source            = "../../../modules/eks-cluster/"
  vpc_id            = module.app_vpc.vpc_id
  priv_snet1_id     = module.app_private_subnet_1.subnet_id
  priv_snet2_id     = module.app_private_subnet_2.subnet_id
  cluster_name      = var.cluster_name
  k8s_version       = var.k8s_version
  cluster_log_types = var.cluster_log_types
  region            = var.region
  env               = var.env
  common_tags       = var.common_tags
  vpc_cicd_block    = "192.168.0.0/24"
  vpc_eks_block = module.app_vpc.vpc_cidr_block
}
