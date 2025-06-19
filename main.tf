terraform {
 cloud {
  organization = "1st_Terraform_Cloud"

  workspaces {
   name = "Terraform_Testing_1"
  }
 }

 required_providers {
  aws = {
   source = "hashicorp/aws"
   version = "~> 5.0"
  }
 }
}

provider "aws" {
 region = var.aws_region
}

locals {
 project_name = "Terraform_testing_1"
 full_name = "${local.project_name}-${var.environment}"
}

data "aws_key_pair" "keypair" {
 key_name = "Terraform_ec2"
}

resource "aws_vpc" "Test_vpc" {
 cidr_block = var.vpc_cidr

 tags = {
  Name = "${local.full_name}-vpc"
 }
}

resource "aws_subnet" "subnet-1" {
 vpc_id = aws_vpc.Test_vpc.id
 cidr_block = var.subnet-1_cidr
 availability_zone = var.subnet-1_az

 tags = {
  Name = "${local.full_name}-subnet-1"
 }
}

resource "aws_subnet" "subnet-2" {
 vpc_id = aws_vpc.Test_vpc.id
 cidr_block = var.subnet-2_cidr
 availability_zone = var.subnet-2_az

 tags = {
  Name = "${local.full_name}-subnet_2"
 }
}

resource "aws_security_group" "Test_sg" {
 vpc_id = aws_vpc.Test_vpc.id

 ingress {
  from_port = 0
  to_port = 0
  cidr_blocks = [var.default_ip]
  protocol = "-1"
 }

 egress {
  from_port = 0
  to_port = 0
  cidr_blocks = [var.default_ip]
  protocol = "-1"
 }

 tags = {
  Name = "${local.full_name}-Test_sg"
 }
}

resource "aws_network_interface" "App-1-nt_int" {
 subnet_id = aws_subnet.subnet-1.id
 security_groups = [aws_security_group.Test_sg.id]
}

resource "aws_network_interface" "App-2-nt_int" {
 subnet_id = aws_subnet.subnet-2.id
 security_groups = [aws_security_group.Test_sg.id]
}

resource "aws_eip" "App-1-eip" {
 domain = "vpc"
 network_interface = aws_network_interface.App-1-nt_int.id

 tags = {
  Name = "${local.full_name}-App-1-eip"
 }
}

resource "aws_eip" "App-2-eip" {
 domain = "vpc"
 network_interface = aws_network_interface.App-2-nt_int.id

 tags = {
  Name = "${local.full_name}-App-2-eip"
 }
}

resource "aws_internet_gateway" "Test_IGW" {
 vpc_id = aws_vpc.Test_vpc.id

 tags = {
  Name = "${local.full_name}-Test_IGW"
 }
}

resource "aws_route_table" "Test_rt" {
 vpc_id = aws_vpc.Test_vpc.id

 route {
  cidr_block = var.default_ip
  gateway_id = aws_internet_gateway.Test_IGW.id
 }

 tags = {
  Name = "${local.full_name}-Test_rt"
 }
}

resource "aws_route_table_association" "rt_ass-1" {
 subnet_id = aws_subnet.subnet-1.id
 route_table_id = aws_route_table.Test_rt.id
}

resource "aws_route_table_association" "rt_ass-2" {
 subnet_id = aws_subnet.subnet-2.id
 route_table_id = aws_route_table.Test_rt.id
}

data "aws_ami" "amz_linx" {
 most_recent = var.most_recent
 owners = ["amazon"]

 filter {
  name = "name"
  values = ["amzn2-ami-hvm-*"]
 }
}

resource "aws_instance" "App-1" {
 ami = data.aws_ami.amz_linx.id
 instance_type = var.instance_type
 key_name = data.aws_key_pair.keypair.key_name

 network_interface {
  device_index = 0
  network_interface_id = aws_network_interface.App-1-nt_int.id
 }

 user_data = var.user_data-1

 tags = {
  Name = "${local.full_name}-App-1"
 }
}

resource "aws_instance" "App-2" {
 ami = data.aws_ami.amz_linx.id
 instance_type = var.instance_type
 key_name = data.aws_key_pair.keypair.key_name

 network_interface {
  device_index = 0
  network_interface_id = aws_network_interface.App-2-nt_int.id
 }

 user_data = var.user_data-2

 tags = {
  Name = "${local.full_name}-App-2"
 }
}

resource "aws_lb" "ALB" {
 internal = var.Alb_internal
 load_balancer_type = var.lb_type
 security_groups = [aws_security_group.Test_sg.id]
 subnets = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
}

resource "aws_lb_target_group" "Alb-tg-1" {
 port = 80
 protocol = "HTTP"
 vpc_id = aws_vpc.Test_vpc.id

 tags = {
  Name = "${local.full_name}-Alb-tg-1"
 }
}

resource "aws_lb_target_group_attachment" "tg-1-att" {
 target_id = aws_instance.App-1.id
 target_group_arn = aws_lb_target_group.Alb-tg-1.arn
 port = 80
}

resource "aws_lb_target_group" "Alb-tg-2" {
 port = 80
 protocol = "HTTP"
 vpc_id = aws_vpc.Test_vpc.id

 tags = {
  Name = "${local.full_name}-Alb-tg-2"
 }
}

resource "aws_lb_target_group_attachment" "tg-2-att" {
 target_id = aws_instance.App-2.id
 target_group_arn = aws_lb_target_group.Alb-tg-2.arn
}

resource "aws_lb_listener" "Alb_listener" {
 load_balancer_arn = aws_lb.ALB.arn
 port = 80
 protocol = "HTTP"

 default_action {
  type = "fixed-response"

  fixed_response {
   content_type = "text/plain"
   message_body = "not-found"
   status_code = "404"
  }
 }

 tags = {
  Name = "${local.full_name}-Alb_listener"
 }
}

resource "aws_lb_listener_rule" "Alb_listener_rule-1" {
 listener_arn = aws_lb_listener.Alb_listener.arn
 priority = 10

 action {
  type = "forward"
  target_group_arn = aws_lb_target_group.Alb-tg-1.arn
 }

condition {
  path_pattern {
    values = ["/app-1*"]
  }
}
}

resource "aws_lb_listener_rule" "Alb_listener_rule-2" {
 listener_arn = aws_lb_listener.Alb_listener.arn
 priority = 20

 action {
  type = "forward"
  target_group_arn = aws_lb_target_group.Alb-tg-2.arn
 }

 condition {
  path_pattern {
   values = ["/app-2*"]
  }
 }
}