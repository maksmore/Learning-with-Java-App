data "aws_availability_zones" "available" {}

data "aws_route53_zone" "my_domain" {
  name         = var.your_dns_name
  private_zone = false
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_ami" "ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-*"] # ECS optimized image
  }

  filter {
    name = "virtualization-type"
    values = [
    "hvm"]
  }

  owners = [
    "amazon" # Only official images
  ]
}

data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_instances" "first_instance_id" {
  instance_tags = {
    Name = "App in ASG"
  }
  depends_on = [aws_autoscaling_group.ecs_asg]
}

data "aws_instance" "first_instance_dns" {
  instance_id = data.aws_instances.first_instance_id.ids[0]
}

data "aws_instance" "second_instance_dns" {
  instance_id = data.aws_instances.second_instance_id.ids[1]
}

data "aws_instances" "second_instance_id" {
  instance_tags = {
    Name = "App in ASG"
  }
  depends_on = [aws_autoscaling_group.ecs_asg]
}

data "aws_db_instance" "db" {
  db_instance_identifier = "prod-rds"
  depends_on             = [aws_db_instance.postgres_rds]
}

data "aws_sns_topic" "email_incident_topic" {
  name       = "Incident_Alert"
  depends_on = [aws_sns_topic.alarm_topic]
}
