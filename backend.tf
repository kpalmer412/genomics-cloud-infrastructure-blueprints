terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    # GUIDANCE FOR LABS: Replace this with your central IT infrastructure bucket name.
    # Recommended naming convention: [organization]-global-terraform-state
    bucket       = "ken-genomics-tfstate-2026" 
    key          = "infrastructure/cost-guardrails/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    
    # Leverages native S3 state locking (Introduced in Terraform 1.10+)
    use_lockfile = true 
  }
}

provider "aws" {
  region = var.aws_region
}
