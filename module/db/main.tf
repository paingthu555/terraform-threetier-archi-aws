## Create RDS mysql

resource "aws_db_instance" "terra-pt-db" {
  allocated_storage = var.db_storage
  storage_type = "gp2"
  engine = "mysql"
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  identifier = var.db_identifier
  username = var.dbuser
  password = var.dbpassword
  vpc_security_group_ids = [var.vpc_db_sg]
  db_subnet_group_name = var.db_subnet_group_name
  skip_final_snapshot = var.skip_db_snapshot
  multi_az = false 
  
  tags = {
    Name = "terra-pt-db"
  }
}