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


# Create launch template and asg for web tier

resource "aws_launch_template" "terra_pt_web" {
  name_prefix            = "terra_pt_web"
  instance_type          = var.ec2_instance_type
  image_id               = data.aws_ami.amazonlnx.id
  # vpc_security_group_ids = [var.web_sg]
  key_name               = var.key_name
  user_data              = filebase64("${path.module}/web.sh")

  network_interfaces {
    security_groups = [var.web_sg]
    associate_public_ip_address = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "terra_pt_web-${"aws:instance-id"}"
    }
  }
}

resource "aws_autoscaling_group" "terra_pt_web_asg" {
  name                = "terra_pt_web_asg"
  vpc_zone_identifier = var.web_subnet
  min_size            = 1
  max_size            = 2
  desired_capacity    = 2
  target_group_arns = [var.lb_tg_arn]

  launch_template {
    id      = aws_launch_template.terra_pt_web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "terra_pt_web"
    propagate_at_launch = true
  }
}