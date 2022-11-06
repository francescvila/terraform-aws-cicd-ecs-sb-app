provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.11.0"
    }
  }

  backend "s3" {
    region  = "us-east-1"
    bucket  = "tfstate-sandbox-1667687807"
    key     = "dev.tfsate"
    profile = "sandbox"
    encrypt = true
  }
}
