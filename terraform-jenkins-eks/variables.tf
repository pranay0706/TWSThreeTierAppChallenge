variable "vpc_cidr_eks" {
  description = "VPC CIDR EKS"
  type        = string
}

variable "private_subnet_eks" {
  description = "Private Subnet for EKS"
}

variable "public_subnet_eks" {
  description = "Public subnet for EKS"
  type        = list(string)
}
