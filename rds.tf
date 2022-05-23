resource "aws_db_instance" "persistant_database" {
  allocated_storage       = 20
  backup_retention_period = 1
  engine                  = "postgres"
  engine_version          = "9.6.22"
  identifier              = local.rds_database_identifier
  instance_class          = "db.t3.small"
  multi_az                = false
  db_name                 = "postgres"
  password                = aws_ssm_parameter.rds_db_password.value
  port                    = 5432
  publicly_accessible     = true
  storage_encrypted       = true
  storage_type            = "gp2"
  username                = aws_ssm_parameter.rds_db_username.value
  vpc_security_group_ids  = [aws_security_group.databases_sg.id]
  skip_final_snapshot     = true
}
