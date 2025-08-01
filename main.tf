module "network" {
  source            = "./module/network"
  vpc_cidr          = "172.16.0.0/16"
  vpc_availablezone = "ap-southeast-1"
  vpc_azs           = ["ap-southeast-1a", "ap-southeast-1b"]
}

module "compute" {
  source            = "./module/compute"
  ec2_instance_type = "t2.micro"
  web_subnet        = module.network.vpc_web_subnet
  web_sg            = module.network.vpc_web_sg
  ssh_key           = "terra-key"
  key_name          = "terra-key"
  lb_tg_arn         = module.lb.lb_tg_arn
}

module "lb" {
  source            = "./module/lb"
  lb_sg             = module.network.terra_lb_sg
  lb_subnet         = module.network.vpc_web_subnet
  tg_port           = 80
  tg_protocol       = "HTTP"
  vpc_id            = module.network.vpc_id
  listener_port     = 80
  listener_protocol = "HTTP"
  terra_pt_asg      = module.compute.terra_web_asg
  
}
