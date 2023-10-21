terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.22.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "random" {
  # Configuration options
}

resource "random_id" "env" {
  byte_length = 8
}