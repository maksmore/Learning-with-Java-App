# --------------------------- EC2 ECS Instance Creating ------------------------------------|

# resource "aws_key_pair" "pub_key" {
#   key_name   = "id_rsa"
#   public_key = "your_pub_key"
# }


resource "aws_instance" "db_filling_instance" {
  #ts:skip=AC_AWS_0479 need to skip it
  #ts:skip=AC_AWS_0480 need to skip it
  ami                         = data.aws_ami.ecs.id
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  subnet_id                   = aws_subnet.ec2_subnet[2].id
  availability_zone           = data.aws_availability_zones.available.names[2]
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  # key_name                    = aws_key_pair.pub_key.key_name
  user_data                   = "#!/bin/bash\necho ECS_CLUSTER=ECS-Regular-Cluster >> /etc/ecs/ecs.config"
  tags = {
    Name = var.db_ec2_name
  }
}