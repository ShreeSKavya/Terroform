terraform {
  required_version = "~> 1.5.7"
  required_providers {
    aws = {
      version = "~> 5.17.0"
    }
  }
  backend "s3" {
    bucket = "my-s3-bucket-backend-dynamodb"
    key = "main/terraform.tfstate"
    region = "us-west-1"
    dynamodb_table = "dynamobd_state_locking_table"
  }
}