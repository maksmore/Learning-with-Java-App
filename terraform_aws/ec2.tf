# --------------------------- EC2 ECS Instance Creating ------------------------------------|

resource "aws_key_pair" "pub_key" {
  key_name   = "id_rsa"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqVJJx14FTrYQpcN2fhEw/2FKYnr7eWjADRAOyiKk9HtXh2VRIIM+GrJRtFLHhFeQn6FD54Yu5hAvjr6p5nSQWlW3GCR6/7gG2R4mezA2UnvJDQdgemxohi49vG5scHkXe0sxUNyVHjkqDLfOUPSUkybxwH6nLhD0v1wG3y0l/m3es2dBsx1gJMImEvrh+iQy75cQtRsbck+rL9oaWcsLNoNE1eOqSv2b4xdJNxbXtVpypGvTr7uUlx6hitwid0tuaDHzLN3hLwlvs6i0hwfRAyyLTMUfyuY5zMtwScaKiQsWz/1GHQnjmwONmDB695SiMx2CqvNMFUpocrAcOybOL Maksim@MacBook-Pro.local"
}


resource "aws_instance" "db_filling_instance" {
  #ts:skip=AC_AWS_0479 need to skip it
  #ts:skip=AC_AWS_0480 need to skip it
  ami                         = data.aws_ami.ecs.id
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.ec2_subnet[0].id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name                    = aws_key_pair.pub_key.key_name
  user_data                   = "#!/bin/bash\necho ECS_CLUSTER=ECS-DB-Filling-Cluster >> /etc/ecs/ecs.config"
  tags = {
    Name = var.db_ec2_name
  }
}