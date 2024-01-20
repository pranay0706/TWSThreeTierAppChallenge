terraform {
  backend "s3" {
    bucket = "s3-bucket-terraform-eks"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}