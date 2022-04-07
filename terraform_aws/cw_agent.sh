#!/bin/bash

# Installing & configuration CloudWatch Agent for agregating of main metrics

echo ECS_CLUSTER=ECS-Regular-Cluster >> /etc/ecs/ecs.config

# ASG_NAME="ECS-ASG"
# export ASG_NAME

# IMAGE_ID=$(curl -s http://169.254.169.254/latest/meta-data/ami-id)
# export IMAGE_ID

# INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
# export INSTANCE_ID

# INSTANCE_TYPE=$(curl -s http://169.254.169.254/latest/meta-data/instance-type)
# export INSTANCE_TYPE

yum install -y amazon-cloudwatch-agent
tee /opt/aws/amazon-cloudwatch-agent/bin/config.json <<EOF
{
   "metrics":{
      "metrics_collected":{
         "mem":{
            "measurement":[
               "mem_used_percent"
            ],
            "metrics_collection_interval":30
         }
      }
   }
}
EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
echo "|--------------------------------------- FINISH ---------------------------------------|"
