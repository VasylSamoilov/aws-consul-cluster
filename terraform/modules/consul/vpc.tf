# Define VPC.
resource "aws_vpc" "consul" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name    = "Consul VPC"
    Project = "consul"
  }
}

# Create an Internet Gateway for VPC.
resource "aws_internet_gateway" "consul" {
  vpc_id = "${aws_vpc.consul.id}"

  tags {
    Name    = "Consul IGW"
    Project = "consul"
  }
}

# Create a public subnet for each AZ.
resource "aws_subnet" "public-a" {
  vpc_id                  = "${aws_vpc.consul.id}"
  cidr_block              = "${var.subnet_cidr1}"
  availability_zone       = "${lookup(var.subnetaz1, var.region)}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.consul"]

  tags {
    Name    = "Consul public subnet a"
    Project = "consul"
  }
}

resource "aws_subnet" "public-b" {
  vpc_id                  = "${aws_vpc.consul.id}"
  cidr_block              = "${var.subnet_cidr2}"
  availability_zone       = "${lookup(var.subnetaz2, var.region)}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.consul"]

  tags {
    Name    = "Consul public subnet b"
    Project = "consul"
  }
}

resource "aws_subnet" "public-c" {
  vpc_id                  = "${aws_vpc.consul.id}"
  cidr_block              = "${var.subnet_cidr3}"
  availability_zone       = "${lookup(var.subnetaz3, var.region)}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.consul"]

  tags {
    Name    = "Consul public subnet c"
    Project = "consul"
  }
}

# Create a route table allowing all addresses access to the IGW.
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.consul.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.consul.id}"
  }

  tags {
    Name    = "Consul public route table"
    Project = "consul"
  }
}

# Associate the route table with the public subnet.
resource "aws_route_table_association" "public-a" {
  subnet_id      = "${aws_subnet.public-a.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public-b" {
  subnet_id      = "${aws_subnet.public-b.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public-c" {
  subnet_id      = "${aws_subnet.public-c.id}"
  route_table_id = "${aws_route_table.public.id}"
}

# Create an internal security group for the VPC.
resource "aws_security_group" "consul-sg" {
  name        = "consul-sg"
  description = "Security group for consul VPC"
  vpc_id      = "${aws_vpc.consul.id}"

  tags {
    Name    = "Consul security group"
    Project = "consul"
  }
}

resource "aws_security_group_rule" "allow-internal-vpc-inbound" {
  type              = "ingress"
  security_group_id = "${aws_security_group.consul-sg.id}"

  from_port = "0"
  to_port   = "0"
  protocol  = "-1"
  self      = true
}

resource "aws_security_group_rule" "allow-internal-vpc-outbound" {
  type              = "egress"
  security_group_id = "${aws_security_group.consul-sg.id}"

  from_port = "0"
  to_port   = "0"
  protocol  = "-1"
  self      = true
}

resource "aws_security_group_rule" "allow-outbound-http" {
  type              = "egress"
  security_group_id = "${aws_security_group.consul-sg.id}"

  from_port   = "80"
  to_port     = "80"
  protocol    = "6"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow-outbound-https" {
  type              = "egress"
  security_group_id = "${aws_security_group.consul-sg.id}"

  from_port   = "443"
  to_port     = "443"
  protocol    = "6"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow-inbound-http" {
  type              = "ingress"
  security_group_id = "${aws_security_group.consul-sg.id}"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow-inbound-https" {
  type              = "ingress"
  security_group_id = "${aws_security_group.consul-sg.id}"

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow-inbound-consul-ui" {
  type              = "ingress"
  security_group_id = "${aws_security_group.consul-sg.id}"

  from_port   = 8500
  to_port     = 8500
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# TODO: insecure, change to bastion host
resource "aws_security_group" "consul-public-ssh" {
  name        = "consul-public-ssh"
  description = "Security group that allows SSH traffic from internet"
  vpc_id      = "${aws_vpc.consul.id}"

  tags {
    Name    = "Consul public SSH"
    Project = "consul"
  }
}

resource "aws_security_group_rule" "allow-inbound-ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.consul-public-ssh.id}"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
