data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "backend-bucket-abc123"
    key    = "terraform/dnd-interview-tf/ca-central-1/vpc.tfstate"
    region = "ca-central-1"
  }
}