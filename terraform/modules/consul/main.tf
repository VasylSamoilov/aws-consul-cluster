# AWS Keypair for SSH
resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

data "template_file" "consul" {
  template = "${file("${path.module}/files/consul-server.sh")}"

  vars {
    asgname = "${var.asgname}"
    region  = "${var.region}"
    size    = "${var.asg_min_size}"
  }
}

# Launch configuration for the consul cluster auto-scaling group.
resource "aws_launch_configuration" "consul-cluster-lc" {
  name_prefix          = "consul-node-"
  image_id             = "${var.image}"
  instance_type        = "${var.instance_size}"
  user_data            = "${data.template_file.consul.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.consul-instance-profile.id}"

  security_groups = [
    "${aws_security_group.consul-sg.id}",
    "${aws_security_group.consul-public-ssh.id}",
  ]

  lifecycle {
    create_before_destroy = true
  }

  key_name = "${var.key_name}"
}

# Load balancers for consul cluster.
resource "aws_elb" "consul-lb" {
  name = "consul-lb"

  security_groups = [
    "${aws_security_group.consul-sg.id}",
  ]

  subnets = ["${aws_subnet.public-a.id}", "${aws_subnet.public-b.id}", "${aws_subnet.public-c.id}"]

  listener {
    instance_port     = 8500
    instance_protocol = "http"
    lb_port           = 8500
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8500/ui/"
    interval            = 30
  }
}

# Auto-scaling group for consul cluster.
resource "aws_autoscaling_group" "consul-cluster-asg" {
  depends_on           = ["aws_launch_configuration.consul-cluster-lc"]
  name                 = "${var.asgname}"
  launch_configuration = "${aws_launch_configuration.consul-cluster-lc.name}"
  min_size             = "${var.asg_min_size}"
  max_size             = "${var.asg_max_size}"
  vpc_zone_identifier  = ["${aws_subnet.public-a.id}", "${aws_subnet.public-b.id}", "${aws_subnet.public-c.id}"]
  load_balancers       = ["${aws_elb.consul-lb.name}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "Consul Node"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "consul-cluster"
    propagate_at_launch = true
  }
}
