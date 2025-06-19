output "vpc_id" {
 description = "vpc id"
 value = aws_vpc.Test_vpc.id
}

output "subnet-1_id" {
 description = "subnet-1 id"
 value = aws_subnet.subnet-1.id
}

output "subnet-2_id" {
 description = "subnet-2 id"
 value = aws_subnet.subnet-2.id
}

output "sg_id" {
 description = "security group id"
 value = aws_security_group.Test_sg.id
}

output "App-1-eni_id" {
 description = "App-1 network interface id"
 value = aws_network_interface.App-1-nt_int.id
}

output "App-2-eni_id" {
 description = "App-2 network interface id"
 value = aws_network_interface.App-2-nt_int.id
}

output "App-1-pri_ip" {
 description = "App-1 private ip"
 value = aws_network_interface.App-1-nt_int.private_ip
}

output "App-2-pri_ip" {
 description = "App-2 private ip"
 value = aws_network_interface.App-2-nt_int.private_ip
}

output "App-1-eip_id" {
 description = "App-1 elastic ip id"
 value = aws_eip.App-1-eip.id
}

output "App-2-eip_id" {
 description = "App-2 elastic ip id"
 value = aws_eip.App-2-eip.id
}

output "App-1-pub_ip" {
 description = "App-1 public ip"
 value = aws_eip.App-1-eip.public_ip
}

output "IGW_id" {
 description = "Internet gateway id"
 value = aws_internet_gateway.Test_IGW.id
}

output "route_table_id" {
 description = "route table id"
 value = aws_route_table.Test_rt.id
}

output "App-1_id" {
 description = "App-1 instance id"
 value = aws_instance.App-1.id
}

output "App-2_id" {
 description = "App-2 instance id "
 value = aws_instance.App-2.id
}

output "Alb_arn" {
 description = "Alb arn"
 value = aws_lb.ALB.arn
}

output "Alb_dns" {
 description = "Alb dns"
 value = aws_lb.ALB.dns_name
}

output "tg-1_arn" {
 description = "target group 1 arn"
 value = aws_lb_target_group.Alb-tg-1.arn
}

output "tg-2_arn" {
 description = "target group 1 arn"
 value = aws_lb_target_group.Alb-tg-2.arn
}

output "Alb-listener_arn" {
 description = "Alb listener arn"
 value = aws_lb_listener.Alb_listener.arn
}