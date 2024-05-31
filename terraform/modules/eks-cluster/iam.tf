resource "aws_iam_role" "eks-cluster" {
  name               = "${var.cluster_name}-${var.env}-eks-cluster-role"
  path               = "/"
  assume_role_policy = file("${path.module}/json/cluster-role-policy.json")

  tags = merge(var.common_tags, { "Name" = "${var.cluster_name}-${var.env}-eks-cluster-role" })
}

resource "aws_iam_role_policy_attachment" "k8s-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster.name
}

resource "aws_iam_role_policy_attachment" "k8s-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-cluster.name
}