module "eks-vpc-endpoint" {
  source                        = "../../../modules/vpc-endpoint/"
  common_tags                   = var.common_tags
  vpc_id                        = module.app_vpc.vpc_id
  priv_snet1_id                 = module.app_private_subnet_1.subnet_id
  priv_snet2_id                 = module.app_private_subnet_2.subnet_id
  eks_cluster_security_group_id = module.eks.eks_cluster_security_group_id
  eks_nodes_security_group_id   = module.platform-node.eks_nodes_security_group_id
  env                           = var.env
  region                        = var.region
}
