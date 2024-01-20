variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "public_subnet_jenkins" {
  description = "Subnet for Jenkins"
  type        = list(string)
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}