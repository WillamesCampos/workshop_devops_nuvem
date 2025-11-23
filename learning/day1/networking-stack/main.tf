terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.assume_role.region

  # setting default tags for the project
  default_tags {
    tags = var.tags
  }

   assume_role {
    role_arn = var.assume_role.arn
  }
}