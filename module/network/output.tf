output "vpc_id" {
    value = aws_vpc.terraform-vpc.id
}

output "vpc_web_sg" {
    value = aws_security_group.terra-sg.id
}

output "vpc_web_subnet"{
    value = aws_subnet.terra-pub-subnet.*.id
}

output "terra_lb_sg" {
    value = aws_security_group.terra-lb-sg.id
}


