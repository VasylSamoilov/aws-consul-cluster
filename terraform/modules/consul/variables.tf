variable "region" {
  description = "The region to deploy the cluster in, e.g: us-east-1."
}

variable "instance_size" {
  description = "The size of the cluster nodes, e.g: t2.micro"
}

variable "image" {
  description = "Image id, e.g: ami-09def150731bdbcc2"
}

variable "asg_min_size" {
  description = "The minimum size of the cluter, e.g. 1"
}

variable "asg_max_size" {
  description = "The maximum size of the cluter, e.g. 3"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC, e.g: 10.0.0.0/16"
}

variable "subnetaz1" {
  description = "The AZ for the first public subnet, e.g: us-east-1a"
  type        = "map"
}

variable "subnetaz2" {
  description = "The AZ for the second public subnet, e.g: us-east-1b"
  type        = "map"
}

variable "subnetaz3" {
  description = "The AZ for the third public subnet, e.g: us-east-1c"
  type        = "map"
}

variable "subnet_cidr1" {
  description = "The CIDR block for the first public subnet, e.g: 10.0.1.0/24"
}

variable "subnet_cidr2" {
  description = "The CIDR block for the second public subnet, e.g: 10.0.2.0/24"
}

variable "subnet_cidr3" {
  description = "The CIDR block for the third public subnet, e.g: 10.0.3.0/24"
}

variable "key_name" {
  description = "The name of the key to user for ssh access, e.g: consul"
}

variable "public_key_path" {
  description = "The local public key path, e.g. ~/.ssh/id_rsa.pub"
}

variable "asgname" {
  description = "The auto-scaling group name, e.g: consul-asg"
}
