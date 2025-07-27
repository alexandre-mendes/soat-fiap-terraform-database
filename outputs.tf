output "aurora_endpoint" {
  value = aws_rds_cluster.aurora_cluster.endpoint
}

output "aurora_password" {
  value     = random_password.master_password.result
}
