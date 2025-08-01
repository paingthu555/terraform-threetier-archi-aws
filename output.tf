output "lb_dns_name" {
    value = "http://${module.lb.lb_dns_name}"    
}