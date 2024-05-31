output "eks_cluster_security_group_id" {
  value = aws_security_group.eks-cluster.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}

output "eks_certificate_authority" {
  value = aws_eks_cluster.eks-cluster.certificate_authority[0].data
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.cluster.arn
}

output "oidc_provider_url" {
  value = aws_iam_openid_connect_provider.cluster.url
}
