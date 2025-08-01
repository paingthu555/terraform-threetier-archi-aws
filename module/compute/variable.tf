variable "ec2_instance_type" {
    description = "Instance type"
    type = string
    default = "t2.micro"
}


variable "web_subnet" {
  type = list(string)
}
variable "web_sg" {}
variable "ssh_key" {}
variable "key_name" {}
variable "lb_tg_arn" {
  description = "The ARN of the load balancer target group"
  type        = string
  }

