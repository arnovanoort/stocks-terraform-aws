//
//terraform {
//  required_providers {
//    postgresql = {
//      source = "terraform-providers/postgresql"
//    }
//  }
//}
//
//provider "postgresql" {
//  sslmode = "disable"
//  database = "stocks"
//  database_username = "postgres"
//  password = "postgres"
//  username          = "postgres"
//}

variable "database_subnet_group" {}
variable "aws_security_group" {}


resource "aws_db_instance" "stock-reader-db2" {
  allocated_storage        = 5 # gigabytes
  backup_retention_period  = 0   # in days
  db_subnet_group_name     = var.database_subnet_group
  engine                   = "postgres"
  engine_version           = "12.5"
  identifier               = var.db-identifier
  instance_class           = "db.t3.micro"
  multi_az                 = false
  name                     = "stocks"
#  parameter_group_name     = "mydbparamgroup1" # if you have tuned it
#  password                 = "${trimspace(file("${path.module}/secrets/mydb1-password.txt"))}"
  password                 = "postgres" //var.rds_password
  port                     = 5432
  publicly_accessible      = true
  storage_encrypted        = false
  storage_type             = "gp2"
  username                 = "postgres" //"stock_reader"
  vpc_security_group_ids   = [var.aws_security_group.id]
  deletion_protection      = false
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  skip_final_snapshot       = true
  final_snapshot_identifier = "fsi"
}

//resource "postgresql_database" "stocks" {
//  name              = "stocks"
//  owner             = "postgres"
//  allow_connections = true
//}

data "aws_db_instance" "database" {
  db_instance_identifier = aws_db_instance.stock-reader-db2.identifier
}

output "db-hostname" {
  value = data.aws_db_instance.database.endpoint
}
