variable "vpc_cidr" {
  default = "10.2.0.0/16"
}

variable "ec2_subnet_cidrs" {
  default = [
    "10.2.0.0/24",
    "10.2.1.0/24",
    "10.2.2.0/24"
  ]
}

variable "database_subnet_cidrs" {
  default = [
    "10.2.20.0/24",
    "10.2.21.0/24",
    "10.2.22.0/24"
  ]
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "aws_access_key_id" {
  type      = string
  sensitive = true
}

variable "aws_secret_access_key" {
  type      = string
  sensitive = true
}

variable "aws_default_region" {
  type      = string
  sensitive = true
}

variable "account_id" {
  type = any
}

variable "app_name" {
  default = "Diploma"
}

variable "db_filling_cluster" {
  default = "DB_Filling"
}

variable "app_environment" {
  default = "Dev"
}

variable "db_name_sg" {
  default = "Postgres-SG"
}

variable "db_ec2_name" {
  default = "DB-Filling-Host"
}

variable "db_name" {
  default = "specialty"
}

variable "ec2_name_sg" {
  default = "EC2-SG"
}

variable "your_dns_name" {
  type = string
}

variable "email_for_alarms" {
  type = string
}

variable "demo_dns" {
  default = "www"
}

variable "asg_name" {
  default = "ECS-ASG"
}

variable "allow_ports" {
  description = "List Of Ports To Open For WebServer:"
  type        = list(any)
  default     = ["5432"]
}

variable "repository_name" {
  default = ["diploma_project", "db_filling_script"]
}
variable "allow_alb_ports" {
  description = "List Of Ports To Open For WebServer:"
  type        = list(any)
  default     = ["80", "443"]
}

variable "alarm_type" {
  type        = list(string)
  description = "Different Alarm Types"
  default     = ["RDS-High-CPU", "RDS-Free-Storage"]
}

variable "comparison_operator" {
  type        = list(string)
  description = "Different operators"
  default     = ["GreaterThanOrEqualToThreshold", "LessThanOrEqualToThreshold"]
}

variable "evaluation_periods" {
  type        = list(string)
  description = "Evaluation Periods"
  default     = ["2", "2"]
}

variable "metric_name" {
  type        = list(string)
  description = "Metric Name"
  default     = ["CPUUtilization", "FreeStorageSpace"]
}

variable "name_space" {
  type        = list(string)
  description = "Name Space"
  default     = ["AWS/RDS", "AWS/RDS"]
}

variable "period" {
  type        = list(string)
  description = "Period"
  default     = ["120", "120"]
}

variable "statistic" {
  type        = list(string)
  description = "Statistic"
  default     = ["Average", "Average"]
}

variable "threshold" {
  type        = list(string)
  description = "Threshold"
  default     = ["80", "8589934592"]
}
