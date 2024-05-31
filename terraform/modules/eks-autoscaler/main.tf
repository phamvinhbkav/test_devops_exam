resource "null_resource" "iam-service-account" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    on_failure  = fail
    when        = create
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
        chmod +x ${path.module}/create-sa.sh && ${path.module}/create-sa.sh $cluster_name
     EOT
    environment = {
      cluster_name = "${var.cluster_name}-${var.env}"
      iam_role_arn = "${var.iam_role_arn}"
    }
  }
}

# You can get the latest docker image version of autoscaler for our EKS version by run the command: curl -s "https://api.github.com/repos/kubernetes/autoscaler/releases" | grep '"tag_name":' | sed -s 's/.*-\([0-9][0-9\.]*\).*/\1/' | grep -m1 ${K8S_VERSION}
resource "null_resource" "autoscaler-deployment" {
  depends_on = [null_resource.iam-service-account]
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    on_failure  = fail
    interpreter = ["/bin/bash", "-c"]
    when        = create
    command     = <<EOT
        chmod +x ${path.module}/deployment.sh && ${path.module}/deployment.sh $cluster_name
     EOT
    environment = {
      working_dir = "${path.module}/"
      autoscaler_version = "${var.autoscaler_version}"
      cluster_name = "${var.cluster_name}-${var.env}"
    }
  }
}
