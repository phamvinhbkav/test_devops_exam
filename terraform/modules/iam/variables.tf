variable "name" {
}

variable "policy" {
}

variable "assume_roles" {
  type    = list(string)
  default = ["ec2.amazonaws.com"]
}

variable "custom_assume_role" {
  type    = string
  default = ""
}

variable "assume_role_arns" {
  type    = list(string)
  default = []
}