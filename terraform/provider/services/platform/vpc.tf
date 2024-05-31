# App VPC
module "app_vpc" {
  source     = "../../../modules/vpc"
  name_tag   = var.app_name_tag
  cidr_block = "10.0.0.0/16"
}

# App subnets
module "app_public_subnet_1" {
  source     = "../../../modules/subnet"
  vpc_id     = module.app_vpc.vpc_id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-1a"
  depends_on = [ module.app_vpc ]
}

module "app_public_subnet_2" {
  source     = "../../../modules/subnet"
  vpc_id     = module.app_vpc.vpc_id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1c"
  depends_on = [ module.app_vpc ]
}

module "app_private_subnet_1" {
  source     = "../../../modules/subnet"
  vpc_id     = module.app_vpc.vpc_id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"
  depends_on = [ module.app_vpc ]
}

module "app_private_subnet_2" {
  source     = "../../../modules/subnet"
  vpc_id     = module.app_vpc.vpc_id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-1c"
  depends_on = [ module.app_vpc ]
}

# Internet gateway
module "app_internet_gateway" {
  source   = "../../../modules/internet-gateway"
  tag_name = var.igw_name_tag
  vpc_id   = module.app_vpc.vpc_id
  depends_on = [ module.app_vpc ]
}

# App NAT Gateway
module "app_nat_gateway_1" {
  source    = "../../../modules/nat-gateway"
  subnet_id = module.app_public_subnet_1.subnet_id
  tag_name  = "app_nat_gateway_1"
  depends_on = [ module.app_public_subnet_1 ]
}

module "app_nat_gateway_2" {
  source    = "../../../modules/nat-gateway"
  subnet_id = module.app_public_subnet_2.subnet_id
  tag_name  = "app_nat_gateway_2"
  depends_on = [ module.app_public_subnet_2 ]
}

# Public subnet routing table
module "app_routing_table_igw" {
  source     = "../../../modules/route-table"
  vpc_id     = module.app_vpc.vpc_id
  cidr_block = "0.0.0.0/0"
  gateway_id = module.app_internet_gateway.internet_gateway_id
  depends_on = [ module.app_vpc, module.app_internet_gateway ]
}

resource "aws_route_table" "app_routing_priv_1" {
  vpc_id     = module.app_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id  = module.app_nat_gateway_1.nat_gateway_id
  }
  route {
    cidr_block = module.data_vpc.vpc_cidr_block
    vpc_peering_connection_id = module.vpc_peering_connection.vpc_peering_connection_id
  }
  route {
    cidr_block = "192.168.0.0/24"
    vpc_peering_connection_id = module.cicd_app_peering_connection.vpc_peering_connection_id
  }
  depends_on = [ 
    module.data_vpc, 
    module.app_nat_gateway_1, 
    module.vpc_peering_connection,
    module.cicd_app_peering_connection 
  ]
}

resource "aws_route_table" "app_routing_priv_2" {
  vpc_id     = module.app_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id  = module.app_nat_gateway_2.nat_gateway_id
  }
  route {
    cidr_block = module.data_vpc.vpc_cidr_block
    vpc_peering_connection_id = module.vpc_peering_connection.vpc_peering_connection_id
  }
  route {
    cidr_block = "192.168.0.0/24"
    vpc_peering_connection_id = module.cicd_app_peering_connection.vpc_peering_connection_id
  }
  depends_on = [ 
    module.app_vpc, 
    module.data_vpc,
    module.app_nat_gateway_2,
    module.vpc_peering_connection,
    module.cicd_app_peering_connection 
  ]
}

module "app_route_table_association_nat_1_priv_snet_1" {
  source         = "../../../modules/route-table-association"
  subnet_id      = module.app_private_subnet_1.subnet_id
  route_table_id = aws_route_table.app_routing_priv_1.id
}

module "app_route_table_association_nat_2_priv_snet_2" {
  source         = "../../../modules/route-table-association"
  subnet_id      = module.app_private_subnet_2.subnet_id
  route_table_id = aws_route_table.app_routing_priv_2.id
}

module "app_route_table_association_pub_snet_1" {
  source         = "../../../modules/route-table-association"
  subnet_id      = module.app_public_subnet_1.subnet_id
  route_table_id = module.app_routing_table_igw.route_table_id
}

module "app_route_table_association_pub_snet_2" {
  source         = "../../../modules/route-table-association"
  subnet_id      = module.app_public_subnet_2.subnet_id
  route_table_id = module.app_routing_table_igw.route_table_id
}

# Data VPC
module "data_vpc" {
  source     = "../../../modules/vpc"
  name_tag   = var.data_name_tag
  cidr_block = "10.1.0.0/16"
}

# Data subnets
module "data_private_subnet_1" {
  source     = "../../../modules/subnet"
  vpc_id     = module.data_vpc.vpc_id
  cidr_block = "10.1.0.0/24"
  availability_zone = "ap-northeast-1a"
  depends_on = [ module.data_vpc ]
}

module "data_private_subnet_2" {
  source     = "../../../modules/subnet"
  vpc_id     = module.data_vpc.vpc_id
  cidr_block = "10.1.1.0/24"
  availability_zone = "ap-northeast-1c"
  depends_on = [ module.data_vpc ]
}

# CICD Peering
module "cicd_app_peering_connection" {
  source      = "../../../modules/vpc-peering"
  vpc_id      = "vpc-0cee32a7d95b0940f"
  peer_vpc_id = module.app_vpc.vpc_id
}

# VPC Peering
module "vpc_peering_connection" {
  source      = "../../../modules/vpc-peering"
  vpc_id      = module.app_vpc.vpc_id
  peer_vpc_id = module.data_vpc.vpc_id
}

resource "aws_route_table" "routing_table_2" {
  vpc_id = module.data_vpc.vpc_id
  route {
    cidr_block = module.app_vpc.vpc_cidr_block
    vpc_peering_connection_id = module.vpc_peering_connection.vpc_peering_connection_id
  }
  depends_on = [ module.vpc_peering_connection ]
}

module "app_route_table_association_2_priv_snet_1" {
  source         = "../../../modules/route-table-association"
  subnet_id      = module.data_private_subnet_1.subnet_id
  route_table_id = aws_route_table.routing_table_2.id
}

module "app_route_table_association_2_priv_snet_2" {
  source         = "../../../modules/route-table-association"
  subnet_id      = module.data_private_subnet_2.subnet_id
  route_table_id = aws_route_table.routing_table_2.id
}

# Security group
resource "aws_security_group" "data_security_group" {
  name   = var.data_scg_name
  vpc_id = module.data_vpc.vpc_id
  ingress {
    description = "Access Database"
    from_port   = 0
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.data_private_subnet_1.subnet_cidr, module.data_private_subnet_2.subnet_cidr]
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [module.data_private_subnet_1.subnet_id, module.data_private_subnet_2.subnet_id]
}
