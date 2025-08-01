output "lb_tg_arn"{
    value = aws_lb_target_group.terra-pt-tg.arn
}

output "lb_dns_name" {
    value = aws_lb.terra-pt-lb.dns_name 
}
    