terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                   = "us-west-1"
  access_key               = var.access_key
  secret_key               = var.secret_key
  #shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "vscode"
}