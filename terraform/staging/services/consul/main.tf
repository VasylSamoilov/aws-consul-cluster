# Setup the core provider information.
provider "aws" {
  region = "${var.region}"
}

# Create consul cluster, based on consul module.
module "consul-cluster" {
  source          = "../../../modules/consul"
  region          = "${var.region}"
  instance_size   = "t2.micro"
  vpc_cidr        = "10.0.0.0/16"
  subnetaz1       = "${var.subnetaz1}"
  subnetaz2       = "${var.subnetaz2}"
  subnetaz3       = "${var.subnetaz3}"
  subnet_cidr1    = "10.0.1.0/24"
  subnet_cidr2    = "10.0.2.0/24"
  subnet_cidr3    = "10.0.3.0/24"
  key_name        = "consul-cluster"
  public_key_path = "${var.public_key_path}"
  asgname         = "consul-asg"
  asg_min_size    = "3"
  asg_max_size    = "3"
  image           = "${var.ami}"
}

# Output DNS name of the consul cluster.
output "consul-dns" {
  value = "${module.consul-cluster.consul-dns}"
}
