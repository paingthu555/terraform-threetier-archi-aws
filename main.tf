module "network" {
  source            = "./module/network"
  vpc_cidr          = "172.16.0.0/16"
  vpc_availablezone = "ap-southeast-1"
  vpc_azs           = ["ap-southeast-1a", "ap-southeast-1b"]
  db_subnet_gp      = true
}

module "compute" {
  source            = "./module/compute"
  ec2_instance_type = "t2.micro"
  bastion_subnet    = module.network.vpc_bastion_subnet
  bastion_sg        = module.network.vpc_bastion_sg
  web_subnet        = module.network.vpc_web_subnet
  web_sg            = module.network.vpc_web_sg
  app_subnet        = module.network.vpc_app_subnet
  app_sg            = module.network.vpc_app_sg
  ssh_key           = "terra-key"
  key_name          = "terra-key"
  lb_tg_arn         = module.lb.lb_tg_arn
}

module "database" {
  source               = "./module/db"
  db_storage           = 10
  db_engine_version    = "8.0"
  db_instance_class    = "db.t3.micro"
  db_name              = var.db_name
  dbuser               = var.dbuser
  dbpassword           = var.dbpassword
  db_identifier        = "terra-pt-db"
  skip_db_snapshot     = true
  vpc_db_sg            = module.network.vpc_db_sg
  db_subnet_group_name = module.network.db_subnet_group_name[0]

}

module "lb" {
  source            = "./module/lb"
  lb_sg             = module.network.terra_lb_sg
  lb_subnet         = module.network.vpc_pub_subnet
  tg_port           = 80
  tg_protocol       = "HTTP"
  vpc_id            = module.network.vpc_id
  listener_port     = 80
  listener_protocol = "HTTP"
  terra_pt_asg      = module.compute.terra_web_asg

}
