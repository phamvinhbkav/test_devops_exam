data "aws_iam_policy_document" "autoscaler" {
  statement {
    sid       = "AutoscalerPermissions"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]
  }
}

data "aws_iam_policy_document" "autoscaler_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

module "autoscaler-iam" {
  source           = "../../../modules/iam/"
  name             = "${var.cluster_name}-${var.env}-autoscaler"
  policy           = data.aws_iam_policy_document.autoscaler.json
  custom_assume_role = data.aws_iam_policy_document.autoscaler_assume_role_policy.json
}

module "eks-autoscaler" {
  source             = "../../../modules/eks-autoscaler/"
  env                = var.env
  cluster_name       = var.cluster_name
  autoscaler_version = var.autoscaler_version
  iam_role_arn       = module.autoscaler-iam.iam_role_arn
  depends_on         = [module.eks,module.platform-node]
}
