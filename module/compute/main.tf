## Create Key pair
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_gen" {
  key_name   = var.ssh_key
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "local_file" "ssh_key" {
  content         = tls_private_key.private_key.private_key_pem
  filename        = "${var.ssh_key}.pem"
  file_permission = "0400"
}

# Create bastion host
resource "aws_instance" "terra-pt-bastion" {
  ami                    = data.aws_ami.amazonlnx.id
  instance_type          = var.ec2_instance_type
  key_name               = var.key_name
  subnet_id              = var.bastion_subnet[0]
  vpc_security_group_ids = [var.bastion_sg]
  associate_public_ip_address = true

  tags = {
    Name = "terra-pt-bastion"
  }
}

# Create launch template and asg for web tier

resource "aws_launch_template" "terra-pt-web" {
  name_prefix            = "terra-pt-web"
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [var.web_sg]
  image_id               = data.aws_ami.amazonlnx.id
  key_name               = var.key_name
  user_data              = filebase64("${path.module}/web.sh")

  tags = {
    Name = "terra-pt-web"
  }

}

resource "aws_autoscaling_group" "terra-pt-web-asg" {
  name                = "terra-pt-web-asg"
  vpc_zone_identifier = var.web_subnet
  min_size            = 2
  max_size            = 3
  desired_capacity    = 2
  target_group_arns = [var.lb_tg_arn]

  launch_template {
    id      = aws_launch_template.terra-pt-web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "terra-pt-web"
    propagate_at_launch = true
  }
}

# Create template and asg for app tier

resource "aws_launch_template" "terra-pt-app" {
  name_prefix            = "terra-pt-app"
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [var.app_sg]
  image_id               = data.aws_ami.amazonlnx.id
  key_name               = var.key_name
  user_data              = filebase64("${path.module}/app.sh")

  tags = {
    Name = "terra-pt-app"
  }

}

resource "aws_autoscaling_group" "terra-pt-app-asg" {
  name                = "terra-pt-app-asg"
  vpc_zone_identifier = var.app_subnet
  min_size            = 2
  max_size            = 3
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.terra-pt-app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "terra-pt-app"
    propagate_at_launch = true
  }
}
