# -------------------- PostgreSQL with Saving Password in Parameter Store  -----------------|

resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/postgres"
  description = "Master Password for RDS PostgreSQL"
  type        = "SecureString"
  value       = var.db_password
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "specialty"
  subnet_ids = [for subnet in aws_subnet.database_subnet : subnet.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "postgres_rds" {
  identifier             = "prod-rds"
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "12.10"
  instance_class         = "db.t2.micro"
  db_name                = var.db_name
  username               = "postgres"
  password               = aws_ssm_parameter.rds_password.value
  parameter_group_name   = "default.postgres12"
  skip_final_snapshot    = true
  apply_immediately      = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}