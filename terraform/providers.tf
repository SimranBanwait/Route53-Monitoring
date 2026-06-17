terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
  # Add this backend block
  backend "s3" {
    bucket         = "tf-state-holder-temp"
    key            = "infrastructure/terraform.tfstate" # Path inside the bucket where the file will live
    region         = "us-east-1"                       # Replace with your actual AWS region (e.g., us-east-1, ap-south-1)
    encrypt        = true                               # Enables server-side encryption for the state file
    # dynamodb_table = "terraform-lock-table"           # Optional: For state locking (Highly Recommended)
  }
}

provider "aws" {
  region = var.aws_region
}
