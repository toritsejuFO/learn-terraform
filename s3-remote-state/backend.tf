terraform {
  backend "s3" {
    bucket = "cerebrohive-master-terraform"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "s3-state-lock"
  }
}
