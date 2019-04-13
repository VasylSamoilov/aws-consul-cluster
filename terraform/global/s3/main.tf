# terraform state file setup
provider "aws" {
  region = "eu-central-1"
}

# create an S3 bucket to store the state file in
resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.bucket_name}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name = "S3 remote Terraform state store"
  }
}
