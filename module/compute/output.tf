output "ami_id" {
    value = data.aws_ami.amazonlnx.id
}

output "terra_web_asg" {
    value = aws_autoscaling_group.terra-pt-web-asg.id
}