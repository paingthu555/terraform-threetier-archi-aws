variable "db_storage" {}
variable "db_instance_class" {}
variable "db_name" {}
variable "db_subnet_group_name" {}
variable "db_engine_version" {}
variable "db_identifier" {}
variable "skip_db_snapshot" {}
variable "vpc_db_sg" {}
variable "dbuser" {
  description = "RDS db admin user"
  type = string
  sensitive = true
}
variable "dbpassword" {
  description = "RDS db admin password"
  type        = string
  sensitive   = true
}