# Terraform

This folder contains terraform services and modules necessary to deploy consul cluster to AWS.

## Directory structure

### global
Contains code that is common for all terrafor environments.
For example:
* global/s3 contains S3bucket for remote state storage.
* global/dynamodb contains DynamoDB table for remote state locks.


### modules
Contains modules used by services

### staging
Staging environment code.

### production
Production environment code
