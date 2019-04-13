#!/bin/bash

if [ -z "$AWS_REGION" ]; then
    echo 'Please specify a region: export AWS_REGION=<region_name>'
fi

if [ -z "$S3_BUCKET" ]; then
    echo 'Please specify S3 bucket to store remote state: export S3_BUCKET=<s3_bucket>'
fi

echo -n "terraform {
  backend \"s3\" {
    encrypt        = true
    bucket         = \"$S3_BUCKET\"" > terraform/staging/services/consul/terraform.tf

if [ ! -z "$DYNAMODB_TABLE" ]; then
echo -n "
    dynamodb_table = \"$DYNAMODB_TABLE\"" >> terraform/staging/services/consul/terraform.tf
fi

echo "
    region         = \"$AWS_REGION\"
    key            = \"staging/services/consul/terraform.tfstate\"
  }
}" >> terraform/staging/services/consul/terraform.tf
