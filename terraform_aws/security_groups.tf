# ------------------------------ Security Groups Creating ----------------------------------|

resource "aws_security_group" "db_sg" {
  name        = var.db_name_sg
  description = "Allows PostgreSQL TCP traffic"
  vpc_id      = aws_vpc.main.id
  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [aws_vpc.main.cidr_block]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.db_name_sg
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = var.ec2_name_sg
  description = "Allows PostgreSQL TCP traffic"
  vpc_id      = aws_vpc.main.id
  dynamic "ingress" {
    for_each = {
      "5432" = {
        security_groups = [aws_security_group.db_sg.id]
      }
      "22" = {
        cidr_blocks = ["0.0.0.0/0"]
      }
      "all" = {
        security_groups = [aws_security_group.alb_sg.id]
        from_port       = 0
        to_port         = 65535
      }
    }

    content {
      from_port       = lookup(ingress.value, "from_port", ingress.key) # 
      to_port         = lookup(ingress.value, "to_port", ingress.key)
      protocol        = "tcp"
      cidr_blocks     = lookup(ingress.value, "cidr_blocks", null)
      security_groups = lookup(ingress.value, "security_groups", null)
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.db_name_sg
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "ALB-SG"
  description = "Allows HTTP, HTTPS traffic"
  vpc_id      = aws_vpc.main.id
  dynamic "ingress" {
    for_each = var.allow_alb_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-ALB-SG"
  }
}