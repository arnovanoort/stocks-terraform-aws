
resource "aws_db_instance" "stock-reader-db" {
  allocated_storage        = 5 # gigabytes
  backup_retention_period  = 0   # in days
  db_subnet_group_name     = var.database_subnet_group
  engine                   = "postgres"
  engine_version           = "12.5"
  identifier               = var.stock-reader-db-identifier
  instance_class           = "db.t3.micro"
  multi_az                 = false
  name                     = "stocks"
  password                 = "postgres"
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
data "aws_db_instance" "stock-reader-db" {
  db_instance_identifier = aws_db_instance.stock-reader-db.identifier
}

output "stock-reader-db-hostname" {
  value = data.aws_db_instance.stock-reader-db.endpoint
}
