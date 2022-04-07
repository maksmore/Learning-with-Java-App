# ------------------------- Launch Configuration & ASG Creation ----------------------------|

resource "aws_launch_configuration" "ecs_launch_config" {

  name                 = "App in ECS"
  image_id             = data.aws_ami.ecs.id
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups      = [aws_security_group.ec2_sg.id]
  user_data            = file("cw_agent.sh")
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.pub_key.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "my_scaling" {
  name                   = "My_scaling_policy"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                 = var.asg_name
  vpc_zone_identifier  = [for subnet in aws_subnet.ec2_subnet : subnet.id]
  launch_configuration = aws_launch_configuration.ecs_launch_config.name
  target_group_arns    = [aws_lb_target_group.app_tg.arn]

  desired_capacity          = 2
  min_size                  = 1
  max_size                  = 4
  health_check_grace_period = 300
  health_check_type         = "EC2"

  depends_on = [aws_ecs_service.db_filling_script]

  dynamic "tag" {
    for_each = {
      Name  = "App in ASG"
      Owner = "Maksim Morozov"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}