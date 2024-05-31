resource "null_resource" "gen_cluster_auth" {
  triggers = {
    always_run = timestamp()
  }
  depends_on = [aws_eks_cluster.eks-cluster]
  provisioner "local-exec" {
    on_failure  = fail
    when        = create
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
        chmod +x ${path.module}/auth.sh && ${path.module}/auth.sh $cluster_name
     EOT
    environment = {
      cluster_name = "${var.cluster_name}-${var.env}"
      region = "${var.region}"
    }
  }
}
