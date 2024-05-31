variable "type" {
  type = string
}

variable "to_port" {
  type = number
}

variable "protocol" {
  type = string
}

variable "prefix_list_ids" {
  type = list(string)
}

variable "from_port" {
  type = number
}

variable "security_group_id" {
  type = string
}
