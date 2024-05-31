resource "aws_iam_instance_profile" "eks-node" {
  name = "${var.name}-profile"
  role = aws_iam_role.eks-node.name
  tags = merge(var.common_tags, {
    "Name"      = "${var.name}-profile"
    "NodeGroup" = "${var.name}" })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "eks-node" {
  name        = "${var.name}-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    "Name"      = "${var.name}-sg"
    "NodeGroup" = "${var.name}" })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks-node.id
  source_security_group_id = aws_security_group.eks-node.id
  to_port                  = 65535
  type                     = "ingress"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-node.id
  source_security_group_id = var.eks_cluster_security_group_id
  type                     = "ingress"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress-cluster-443" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-node.id
  source_security_group_id = var.eks_cluster_security_group_id
  type                     = "ingress"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress-cluster-3306" {
  description              = "Allow DB connection"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-node.id
  cidr_blocks              = [var.mysql_cidr_blocks]
  type                     = "ingress"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress-cicd-vm-ssh" {
  description       = "Allow Cloud9 VM to remotely connect with worker nodes"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.eks-node.id
  cidr_blocks = [var.vpc_cicd_block]
  #source_security_group_id = var.sg_cicd_vm_id
  to_port           = 22
  type              = "ingress"
  lifecycle {
    create_before_destroy = true
  }
}

locals {
  eks-node-userdata = <<USERDATA
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash -xe
# You can add some extra arguments like below
#/etc/eks/bootstrap.sh --apiserver-endpoint '${var.eks_cluster_endpoint}' --b64-cluster-ca '${var.eks_certificate_authority}' '${var.cluster_name}-${var.env}' --kubelet-extra-args '--node-labels=eks.amazonaws.com/nodegroup-image=ami-0440c10a3f77514d8,eks.amazonaws.com/capacityType=ON_DEMAND,eks.amazonaws.com/nodegroup=phongtest --max-pods=17' --use-max-pods false
sudo /etc/eks/bootstrap.sh --apiserver-endpoint '${var.eks_cluster_endpoint}' --b64-cluster-ca '${var.eks_certificate_authority}' '${var.cluster_name}-${var.env}'
echo "Running custom user data script" > /tmp/me.txt
yum install -y amazon-ssm-agent
echo "yum'd agent" >> /tmp/me.txt
yum update -y
systemctl enable amazon-ssm-agent && systemctl start amazon-ssm-agent
date >> /tmp/me.txt

--==MYBOUNDARY==--
USERDATA
}

resource "aws_launch_template" "template" {
  name = "${var.name}-LC"
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 30
    }
  }

  image_id      = var.ami
  instance_type = var.instance_type
  update_default_version = true

  monitoring {
    enabled = true
  }
  vpc_security_group_ids = [aws_security_group.eks-node.id]
  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.common_tags, { "Name" = "${var.name}", "kubernetes.io/cluster/${var.cluster_name}-${var.env}" = "owned" })
  }
  user_data = base64encode(local.eks-node-userdata)
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = "${var.cluster_name}-${var.env}"
  node_group_name = var.name
  node_role_arn   = aws_iam_role.eks-node.arn
  subnet_ids      = [var.priv_snet1_id, var.priv_snet2_id]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }
  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
  tags          = merge(var.common_tags, { "Name" = "${var.name}", "kubernetes.io/cluster/${var.cluster_name}-${var.env}" = "owned" })

  update_config {
    max_unavailable = 1
  }
  
  depends_on = [
    aws_iam_role_policy_attachment.eks-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-AmazonEC2ContainerRegistryReadOnly,
    aws_launch_template.template,
    var.eks_vpc_endpoint
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
    create_before_destroy = true
  }
}
