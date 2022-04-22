
output "postgres_endpoint" {
  value = aws_db_instance.postgres_rds.endpoint
}

output "first_instance_id" {
  value = data.aws_instances.first_instance_id.ids[0]
}

output "second_instance_id" {
  value = data.aws_instances.second_instance_id.ids[1]
}

output "my_db" {
  value = data.aws_db_instance.db.engine
}

output "id_of_incident_topic" {
  value = data.aws_sns_topic.email_incident_topic.id
}

output "sns_topic" {
  value = data.aws_sns_topic.email_incident_topic.arn
}

output "role" {
  value = aws_iam_role_policy_attachment.ecs_agent.role
}

output "asg_name" {
  value = aws_autoscaling_group.ecs_asg.name
}

output "private_dns_name_first" {
  value = data.aws_instance.first_instance_dns.private_dns
}

output "private_dns_name_second" {
  value = data.aws_instance.second_instance_dns.private_dns
}
