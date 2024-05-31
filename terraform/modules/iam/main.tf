
locals {
  assume_role = var.custom_assume_role == "" ? data.aws_iam_policy_document.default_assume_role.json : var.custom_assume_role
}


data "aws_iam_policy_document" "default_assume_role" {
  statement {
    sid    = "1"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = var.assume_roles
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.assume_role_arns
    }
  }
}

resource "aws_iam_role" "iam_role" {
  name               = "${var.name}-role"
  assume_role_policy = local.assume_role
}

resource "aws_iam_policy" "iam_policy" {
  name   = "${var.name}-policy"
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "iam_policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}

