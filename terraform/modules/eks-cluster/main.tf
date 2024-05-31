resource "aws_security_group" "eks-cluster" {
  name        = "${var.cluster_name}-${var.env}-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.cluster_name}-${var.env}-sg" })
}

resource "aws_security_group_rule" "cluster-ingress-node-https" {
  description       = "Allow pods to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks-cluster.id
  cidr_blocks = [var.vpc_eks_block]
  to_port     = 443
  type        = "ingress"
}

resource "aws_security_group_rule" "cluster-ingress-gitlab-https" {
  description       = "Allow gitlab VM to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks-cluster.id
  cidr_blocks       = [var.vpc_cicd_block]
  to_port = 443
  type    = "ingress"
}

resource "aws_cloudwatch_log_group" "cluster-logs" {
  name              = "/aws/eks/${var.cluster_name}-${var.env}/cluster"
  retention_in_days = 180
  tags              = merge(var.common_tags, { Name = "${var.cluster_name}-${var.env}-logs" })
}

resource "aws_eks_cluster" "eks-cluster" {
  name     = "${var.cluster_name}-${var.env}"
  role_arn = aws_iam_role.eks-cluster.arn
  version  = var.k8s_version

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = false
    public_access_cidrs     = ["0.0.0.0/0"]
    security_group_ids      = [aws_security_group.eks-cluster.id]
    subnet_ids              = [var.priv_snet1_id, var.priv_snet2_id]
  }

  enabled_cluster_log_types = var.cluster_log_types

  depends_on = [
    aws_iam_role_policy_attachment.k8s-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.k8s-cluster-AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.cluster-logs,
    aws_security_group_rule.cluster-ingress-gitlab-https
  ]

  tags = merge(var.common_tags, { Name = "${var.cluster_name}-${var.env}" })
}
