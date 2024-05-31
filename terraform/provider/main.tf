terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.50.0"
    }
  }

  backend "s3" {
    bucket  = "vincent-tfstate"
    key     = "app/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = "true"
  }
}

module "platform-services" {
  source                    = "./services/platform/"
  region                    = var.general.region
  env                       = var.general.environment
  platform                  = var.platform
  autoscaler_version        = var.autoscaler_version
}

