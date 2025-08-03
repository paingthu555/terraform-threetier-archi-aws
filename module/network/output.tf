output "vpc_id" {
    value = aws_vpc.terraform-vpc.id
}

output "vpc_bastion_sg" {
    value = aws_security_group.terra-bastion-sg.id
}

output "vpc_bastion_subnet" {
    value = aws_subnet.terra-pub-subnet.*.id
}

output "vpc_pub_subnet" {
  value = aws_subnet.terra-pub-subnet.*.id
}

output "vpc_web_sg" {
    value = aws_security_group.terra-frontend-web-sg.id
}

output "vpc_web_subnet"{
    value = aws_subnet.terra-priv-subnet.*.id
}

output "vpc_app_subnet" {
    value = aws_subnet.terra-priv-subnet.*.id
}

output "vpc_app_sg" {
    value = aws_security_group.terra-backend-app-sg.id
  
}

output "vpc_db_subnet" {
    value = aws_subnet.terra-db-priv-subnet.*.id
}

output "vpc_db_sg" {
    value = aws_security_group.terra-db-sg.id
  
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.terra-db-subnet-gp.*.name
}

output "rds_db_subnet_group" {
  value = aws_db_subnet_group.terra-db-subnet-gp.*.id
}

output "terra_lb_sg" {
    value = aws_security_group.terra-lb-sg.id
}


