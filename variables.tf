variable "region" {
  description = "Define the provisioned region"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Set your cloud9 project name"
  type        = string
  default     = ""
}

variable "profile" {
  description = "Set your AWS CLI profile"
  type        = string
  default     = "default"
}

variable "instance_type" {
  description = "Define instance type"
  type = string
  default = "t2.micro"
}

variable "member" {
  description = "Add user to membership. Permissions are: `read-only` OR `read-write`"
  type = string
  default = ""
}