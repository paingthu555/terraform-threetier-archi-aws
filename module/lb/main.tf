# Create LB
resource "aws_lb" "terra-pt-lb" {
  name               = "terra-pt-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb_sg]
  subnets            = var.lb_subnet
  depends_on = [var.terra_pt_asg]
  
  tags = {
    Name = "terra-pt-lb"
  }
}

# Create Target Group
resource "aws_lb_target_group" "terra-pt-tg" {
  name        = "terra-pt-tg"
  target_type = "instance"
  port        = var.tg_port
  protocol    = var.tg_protocol
  vpc_id      = var.vpc_id
  lifecycle {
    ignore_changes        = [name]
    create_before_destroy = true
  }
}

# Create Listener rule
resource "aws_lb_listener" "terra-pt-lb-listener" {
  load_balancer_arn = aws_lb.terra-pt-lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.terra-pt-tg.arn

  }
}