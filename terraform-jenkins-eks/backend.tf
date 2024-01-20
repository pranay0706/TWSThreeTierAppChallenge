terraform {
  backend "s3" {
    bucket = "s3-bucket-terraform-eks"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}