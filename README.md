## Task

Automate the creation of a Consul cluster

## Case

1. We use AWS for hosting our solution

2. For operating our infrastructure we need a HA Consul cluster distributed over at least 3 availability zones

3. The setup and maintenance should be fully automated

4. Consul instances should discover themselves using DNS

## Usage

### Configure AWS region
```
# export AWS_REGION="eu-central-1"
```

### Configure terraform remote state (optional)

#### Configure variables
```
# export S3_BUCKET="unique-bucket-name"
# export DYNAMODB_TABLE="some-table-name"
```

#### Configure S3 bucket to store state remotely
```
# cd terraform/global/s3
# terraform init
# terraform plan -var region_name=$AWS_REGION -var bucket_name=$S3_BUCKET
# terraform apply -var region_name=$AWS_REGION -var bucket_name=$S3_BUCKET
```

#### Configure DynamoDB table for locking state
```
# cd terraform/global/dynamodb
# terraform init
# terraform plan -var region_name=$AWS_REGION -var dynamodb_name=$DYNAMODB_TABLE
# terraform apply -var region_name=$AWS_REGION -var dynamodb_name=$DYNAMODB_TABLE
```

#### Configure terraform to use remote state
```
# make configure-remote-state
```

### Run linters (optional)
```
# make lint
```

### Create consul cluster
```
# cd terraform/staging/services/consul
# terraform init
# terraform plan -var region=$AWS_REGION
# terraform apply -var region=$AWS_REGION
```

### Architecture diagram
![alt text](https://i.imgur.com/JuKMOND.png "AWS diagram")
