data "template_file" "node_role_policy" {
  template = file("${path.module}/json/node-role-policy.json")
}

resource "aws_iam_role" "eks-node" {
  name               = "${var.name}-role"
  path               = "/"
  assume_role_policy = data.template_file.node_role_policy.rendered
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonAPIGatewayPushToCloudWatchLogs" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
  role       = aws_iam_role.eks-node.name
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonPrometheusFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonPrometheusFullAccess"
  role       = aws_iam_role.eks-node.name
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonMSKFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonMSKFullAccess"
  role       = aws_iam_role.eks-node.name
  lifecycle {
    create_before_destroy = true
  }
}