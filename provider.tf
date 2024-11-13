terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.75.0"
    }
  }
  cloud {
    organization = "Cloud_Resume_API"
    workspaces {
      name = "API_Resume"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
}