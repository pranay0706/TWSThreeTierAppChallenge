#VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "eks-vpc"
  cidr = var.vpc_cidr_eks

  azs             = data.aws_availability_zones.azs.names
  private_subnets = var.private_subnet_eks
  public_subnets  = var.public_subnet_eks

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = {
    "kubernetes.io/cluster/my-3tiereks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/my-3tiereks-cluster" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/my-3tiereks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }
}

#AWS-EKS
module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = "my-3tiereks-cluster"
  cluster_version = "1.24"

  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t2.medium"]
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}