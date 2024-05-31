variable "general" {
  type = map(any)
  default = {
    region: "ap-northeast-1"
    environment: "dev"
  }
}

variable "common_tags" {
  type = map(any)
  default = {
    
  }
}

variable "platform" {
  type = map(string)
  default = {
    node_size = 2
    desired_size = 2
    max_size = 2
    min_size = 1
    ami = "ami-0a0f69a41ae022c92"
    instance_type = "t3.medium"
  }
}

variable "autoscaler_version" {
  default = "v1.20"
}
