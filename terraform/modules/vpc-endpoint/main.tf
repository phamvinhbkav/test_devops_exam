# aws_vpc_endpoint.vpce-autoscaling:
resource "aws_vpc_endpoint" "vpce-autoscaling" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    var.eks_nodes_security_group_id,
    var.eks_cluster_security_group_id
  ]
  service_name = format("com.amazonaws.%s.autoscaling", var.region)
  subnet_ids = [
    var.priv_snet1_id,
    var.priv_snet2_id
  ]
  tags              = merge(var.common_tags, { "Name" = "vpce-autoscaling-${var.env}" })
  vpc_endpoint_type = "Interface"
  vpc_id            = var.vpc_id

  timeouts {}
}

# aws_vpc_endpoint.vpce-ec2:
resource "aws_vpc_endpoint" "vpce-ec2" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    var.eks_nodes_security_group_id,
    var.eks_cluster_security_group_id
  ]
  service_name = format("com.amazonaws.%s.ec2", var.region)
  subnet_ids = [
    var.priv_snet1_id,
    var.priv_snet2_id
  ]
  tags              = merge(var.common_tags, { "Name" = "vpce-ec2-${var.env}" })
  vpc_endpoint_type = "Interface"
  vpc_id            = var.vpc_id

  timeouts {}
}

# aws_vpc_endpoint.vpce-ec2messages:
resource "aws_vpc_endpoint" "vpce-ec2messages" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    var.eks_nodes_security_group_id,
    var.eks_cluster_security_group_id
  ]
  service_name = format("com.amazonaws.%s.ec2messages", var.region)
  subnet_ids = [
    var.priv_snet1_id,
    var.priv_snet2_id
  ]
  tags              = merge(var.common_tags, { "Name" = "vpce-ec2messages-${var.env}" })
  vpc_endpoint_type = "Interface"
  vpc_id            = var.vpc_id

  timeouts {}
}

# aws_vpc_endpoint.vpce-ecrapi:
resource "aws_vpc_endpoint" "vpce-ecrapi" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    var.eks_nodes_security_group_id,
    var.eks_cluster_security_group_id
  ]
  service_name = format("com.amazonaws.%s.ecr.api", var.region)
  subnet_ids = [
    var.priv_snet1_id,
    var.priv_snet2_id
  ]
  tags              = merge(var.common_tags, { "Name" = "vpce-ecrapi-${var.env}" })
  vpc_endpoint_type = "Interface"
  vpc_id            = var.vpc_id

  timeouts {}
}

# aws_vpc_endpoint.vpce-ecrdkr:
resource "aws_vpc_endpoint" "vpce-ecrdkr" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    var.eks_nodes_security_group_id,
    var.eks_cluster_security_group_id
  ]
  service_name = format("com.amazonaws.%s.ecr.dkr", var.region)
  subnet_ids = [
    var.priv_snet1_id,
    var.priv_snet2_id
  ]
  tags              = merge(var.common_tags, { "Name" = "vpce-ecrdkr-${var.env}" })
  vpc_endpoint_type = "Interface"
  vpc_id            = var.vpc_id

  timeouts {}
}

# aws_vpc_endpoint.vpce-elb:
resource "aws_vpc_endpoint" "vpce-elb" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    var.eks_nodes_security_group_id,
    var.eks_cluster_security_group_id
  ]
  service_name = format("com.amazonaws.%s.elasticloadbalancing", var.region)
  subnet_ids = [
    var.priv_snet1_id,
    var.priv_snet2_id
  ]
  tags              = merge(var.common_tags, { "Name" = "vpce-elb-${var.env}" })
  vpc_endpoint_type = "Interface"
  vpc_id            = var.vpc_id

  timeouts {}
}

# aws_vpc_endpoint.vpce-logs:
resource "aws_vpc_endpoint" "vpce-logs" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    var.eks_nodes_security_group_id,
    var.eks_cluster_security_group_id
  ]
  service_name = format("com.amazonaws.%s.logs", var.region)
  subnet_ids = [
    var.priv_snet1_id,
    var.priv_snet2_id
  ]
  tags              = merge(var.common_tags, { "Name" = "vpce-logs-${var.env}" })
  vpc_endpoint_type = "Interface"
  vpc_id            = var.vpc_id

  timeouts {}
}

# aws_vpc_endpoint.vpce-s3:
resource "aws_vpc_endpoint" "vpce-s3" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
      Version = "2008-10-17"
    }
  )
  private_dns_enabled = false
  # route_table_ids = [
  #   var.route_table_eks_subnet_id,
  # ]
  security_group_ids = []
  service_name       = format("com.amazonaws.%s.s3", var.region)
  subnet_ids         = []
  tags               = merge(var.common_tags, { "Name" = "vpce-s3-${var.env}" })
  vpc_endpoint_type  = "Gateway"
  vpc_id             = var.vpc_id

  timeouts {}
}

# aws_vpc_endpoint.vpce-ssm:
resource "aws_vpc_endpoint" "vpce-ssm" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    var.eks_nodes_security_group_id,
    var.eks_cluster_security_group_id
  ]
  service_name = format("com.amazonaws.%s.ssm", var.region)
  subnet_ids = [
    var.priv_snet1_id,
    var.priv_snet2_id
  ]
  tags              = merge(var.common_tags, { "Name" = "vpce-ssm-${var.env}" })
  vpc_endpoint_type = "Interface"
  vpc_id            = var.vpc_id

  timeouts {}
}

# aws_vpc_endpoint.vpce-ssmmessages:
resource "aws_vpc_endpoint" "vpce-ssmmessages" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    var.eks_nodes_security_group_id,
    var.eks_cluster_security_group_id
  ]
  service_name = format("com.amazonaws.%s.ssmmessages", var.region)
  subnet_ids = [
    var.priv_snet1_id,
    var.priv_snet2_id
  ]
  tags              = merge(var.common_tags, { "Name" = "vpce-ssmmessages-${var.env}" })
  vpc_endpoint_type = "Interface"
  vpc_id            = var.vpc_id

  timeouts {}
}

# aws_vpc_endpoint.vpce-sts:
resource "aws_vpc_endpoint" "vpce-sts" {
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  private_dns_enabled = true
  route_table_ids     = []
  security_group_ids = [
    var.eks_nodes_security_group_id,
    var.eks_cluster_security_group_id
  ]
  service_name = format("com.amazonaws.%s.sts", var.region)
  subnet_ids = [
    var.priv_snet1_id,
    var.priv_snet2_id
  ]
  tags              = merge(var.common_tags, { "Name" = "vpce-sts-${var.env}" })
  vpc_endpoint_type = "Interface"
  vpc_id            = var.vpc_id

  timeouts {}
}
