# --------------------- ECS Cluster, Service & Task Definition Creation --------------------|

resource "aws_ecs_cluster" "app_cluster" {
  name = "ECS-Regular-Cluster"
  
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${var.app_name}-ecs"
    Environment = var.app_environment
  }
}

# resource "aws_ecs_cluster" "db_filling_cluster" {
#   name = "ECS-DB-Filling-Cluster"

#   tags = {
#     Name        = "${var.db_filling_cluster}"
#     Environment = var.app_environment
#   }
# }

resource "aws_ecs_task_definition" "app_task_definition" {
  family = "diploma_project"
  container_definitions = jsonencode([
    {
      "name" : "diploma-container",
      "image" : "public.ecr.aws/j1n7b9p6/diploma_project:v0.0.1",
      "entryPoint" : [],
      "environment" : [],
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 8083,
          "hostPort" : 0
        }
      ],
      "cpu" : 256,
      "memory" : 256,
      "networkMode" : "bridge"
    }
  ])

  task_role_arn            = "arn:aws:iam::233817511251:role/Diploma-execution-task-role"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${data.aws_availability_zones.available.names[0]}, ${data.aws_availability_zones.available.names[1]}]"
  }
}

resource "aws_ecs_task_definition" "db_filling_script_task_definition" {
  family = "db_filling_script"
  container_definitions = jsonencode([
    {
      "name" : "script-container",
      "image" : "public.ecr.aws/j1n7b9p6/db_filling_script:latest",
      "entryPoint" : [],
      "environment" : [
        {
          "name" : "AWS_ACCESS_KEY_ID", "value" : "${var.aws_access_key_id}"
        },
        {
          "name" : "AWS_SECRET_ACCESS_KEY", "value" : "${var.aws_secret_access_key}"
        },
        {
          "name" : "AWS_DEFAULT_REGION", "value" : "${var.aws_default_region}"
        },
        {
          "name" : "PGPASSWORD", "value" : "${var.db_password}"
        }
      ],
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 5432,
          "hostPort" : 5432
        }
      ],
      "cpu" : 256,
      "memory" : 200,
      "networkMode" : "bridge"
    }
  ])

  requires_compatibilities = ["EC2"]
  task_role_arn            = "arn:aws:iam::233817511251:role/Diploma-execution-task-role"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  
  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in ${data.aws_availability_zones.available.names[2]}"
  # }
}

resource "aws_ecs_service" "diploma" {
  name                               = "diploma_project"
  cluster                            = aws_ecs_cluster.app_cluster.id
  task_definition                    = aws_ecs_task_definition.app_task_definition.id
  force_new_deployment               = true
  desired_count                      = 2
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  scheduling_strategy                = "REPLICA"
  
  ordered_placement_strategy {
    type = "spread"
    field = "instanceId"
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "diploma-container"
    container_port   = 8083
  }
  depends_on = [aws_ecs_service.db_filling_script]
}

resource "aws_ecs_service" "db_filling_script" {
  name            = "db_filling_script"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.db_filling_script_task_definition.id
  desired_count   = 1

  depends_on = [aws_db_instance.postgres_rds]
}
