variable "vpc_cidr" {
  description = "vpc cidr"
  type = string
  default = "172.168.0.0/16"
}

variable "aws_region" {
  description = "aws region"
  type = string
  default = "us-east-1"
}

variable "subnet-1_cidr" {
  description = "subnet 1 cidr"
  type = string
  default = "172.168.0.0/24"
}

variable "subnet-1_az" {
  description = "az for subnet 1"
  type = string
  default = "us-east-1a"
}

variable "subnet-2_cidr" {
  description = "subnet 2 cidr"
  type = string
  default = "172.168.1.0/24"
}

variable "subnet-2_az" {
  description = "az for subnet 2"
  type = string
  default = "us-east-1c"
}

variable "most_recent" {
  description = "ami-id most recent"
  type = bool
  default = true
}

variable "instance_type" {
  description = "ec2 instance type"
  type= string
  default = "t2.micro"
}

variable "protocol" {
  description = "protocol"
  type = string
  default = "-1"
}

variable "lb_type" {
  description = "load balancer type"
  type = string
  default = "application"
}

variable "user_data-1" {
  description = "userdata for Ec2-1"
  type = string
  default = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y
              systemctl enable nginx
              systemctl start nginx
              mkdir -p /usr/share/nginx/html/app-1
              echo "This is ALB-1" > /usr/share/nginx/html/app-1/index.html
              EOF
}

variable "user_data-2" {
  description = "userdata for Ec2-2"
  type = string
  default = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y
              systemctl enable nginx
              systemctl start nginx
              mkdir -p /usr/share/nginx/html/app-2
              echo "This is ALB-2" > /usr/share/nginx/html/app-2/index.html
              EOF
}

variable "environment" {
 description = "Project environment"
 type = string
 default = "dev"
}

variable "Alb_internal" {
 description = "ALB type"
 type = bool
 default = false
}

variable "default_ip" {
 description = "default ip"
 type = string
 default = "0.0.0.0/0"
}