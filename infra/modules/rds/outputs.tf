output "db_instance_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "db_instance_name" {
  value = aws_db_instance.postgres.db_name
}