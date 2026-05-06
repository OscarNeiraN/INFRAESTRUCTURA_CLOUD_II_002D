resource "aws_db_subnet_group" "main" {
  count = var.create_db ? 1 : 0
  name       = "db-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "mysql" {
  count = var.create_db ? 1 : 0
  allocated_storage = var.db_config.storage
  engine            = var.db_config.engine
  engine_version    = var.db_config.engine_version
  instance_class    = var.db_config.instance_class
  
  identifier = lower("${var.project_name}-db")

  username               = var.db_config.username
  password               = var.db_config.password
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.main[0].name
}