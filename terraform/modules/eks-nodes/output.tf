output "iam_role_arn" {
  value = aws_iam_role.eks-node.arn
}

output "eks_nodes_security_group_id" {
  value = aws_security_group.eks-node.id
}