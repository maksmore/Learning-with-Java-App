# ---------------------------- ALB & TG Creation ---------------------------|

resource "aws_lb_target_group" "app_tg" {
  name     = "App-ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/api/v1/specialty"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 20
    timeout             = 10
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }
}

resource "aws_lb" "app" {
  name               = "APP-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for subnet in aws_subnet.ec2_subnet : subnet.id]

  tags = {
    Environment = var.app_environment
  }
  # depends_on = [aws_autoscaling_group.ecs_asg]
}

resource "aws_lb_listener" "app_http_alb" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "app_https_alb" {
  load_balancer_arn = aws_lb.app.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.my_cert.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}