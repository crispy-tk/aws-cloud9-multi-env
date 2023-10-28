variable "region" {
  description = "Define the provisioned region."
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Set your cloud9 project name."
  type        = string
  default     = "example"
}

variable "profile" {
  description = "Set your AWS CLI profile."
  type        = string
  default     = "default"
}

variable "instance_type" {
  description = "Define instance type."
  type        = string
  default     = "t2.micro"
}

variable "members_permissions" {
  description = "Permissions are: `read-only` OR `read-write`."
  type = string
  default = "read-write"
}

variable "members_list" {
  description = "Add user to membership. The number of members will determine the number of instances."
  type        = list(string)
}