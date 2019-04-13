## Task

Automate the creation of a Consul cluster

## Case

1. We use AWS for hosting our solution

2. For operating our infrastructure we need a HA Consul cluster distributed over at least 3 availability zones

3. The setup and maintenance should be fully automated

4. Consul instances should discover themselves using DNS

## Prerequisites

### Build packer image
```
# cd packer
# packer build consul.json
```

## Usage

### Configure AWS region
```
# export AWS_REGION="eu-central-1"
# export AMI_ID="<ami_id_from_packer_output>"
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
# terraform plan -var region=$AWS_REGION -var ami=$AMI_ID
# terraform apply -var region=$AWS_REGION -var ami=$AMI_ID
```

### Architecture diagram
![alt text](https://i.imgur.com/JuKMOND.png "AWS diagram")


## Additional improvements to consider
* Configure CloudWatch to collect logs from consul servers
* Configure CloudWatch to monitor consul servers load
* Implement dynamic scaling for auto-scaling group 
* Migrate to spot instances to save money

## Price calculator
#### Elastic Load Balancing 
* Number: 1
* Processed bytes per CLB: 10 GB per month
* Monthly: 21.98 USD
#### EC2
* Number: 3 t2.micro Linux instances with a consistent workload, Amazon Elastic Block Storage (30 GB General Purpose SSD (gp2))
* Monthly: 31.73 USD

## Used references
* https://www.dwmkerr.com/creating-a-resilient-consul-cluster-for-docker-microservice-discovery-with-terraform-and-aws/
* https://www.terraform.io/docs/
* https://www.packer.io/docs/
* https://docs.ansible.com/ansible/latest/index.html
* https://calculator.aws/#/estimate
