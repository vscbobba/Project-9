terraform {
  required_providers {
    aws = {
    source = "hashicorp/aws"
    version = "5.17.0"
    }
  }
    backend "s3" {
        bucket = "projectbucket2023"
        key = "terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "project-dynamo"
    }
}


provider "aws" {
    region = "us-east-1"
}