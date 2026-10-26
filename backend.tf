terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}




provider "aws" {
  region = var.aws_region
}
terraform {
  backend "s3" {
    bucket       = "ken-genomics-tfstate-2026"
    key          = "pitt-surgery-hsrdc-migration/sandbox.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true 
  }
}
