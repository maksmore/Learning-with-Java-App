# ----------------- Cloudwatch Email Alarm & Monitoring of Certain Resources ---------------|

resource "aws_cloudwatch_dashboard" "my_dashboard" {
  dashboard_name = "Common-infrastracture-metrics"

  dashboard_body = <<EOF
{
    "widgets":[
        {
            "type":"metric",
            "x":0,
            "y":0,
            "width":12,
            "height":6,
            "properties":{
                "metrics":[
                    [
                        "AWS/EC2",
                        "CPUUtilization",
                        "InstanceId",
                        "${data.aws_instances.first_instance_id.ids[0]}"
                    ],
                    [
                        "AWS/EC2",
                        "NetworkIn",
                        "InstanceId",
                        "${data.aws_instances.first_instance_id.ids[0]}",
                        {
                        "yAxis":"right",
                        "label":"NetworkIn",
                        "period":300,
                        "stat":"Maximum"
                        }
                    ],
                    [
                        "CWAgent",
                        "mem_used_percent",
                        "host",
                        "${data.aws_instance.first_instance_dns.private_dns}",
                        {
                        "yAxis":"right",
                        "label":"MemoryUsage",
                        "period":300,
                        "stat":"Maximum"
                        }
                    ]
                ],
                "period":300,
                "stat":"Average",
                "region":"eu-west-1",
                "timezone":"+0300",
                "title":"${data.aws_instances.first_instance_id.ids[0]} EC2 Instance metrics",
                "stacked":true,
                "view":"timeSeries",
                "liveData":false,
                "yAxis":{
                    "left":{
                        "min":0,
                        "max":100
                    },
                    "right":{
                        "min":50
                    }
                },
                "annotations":{
                    "horizontal":[
                        {
                        "visible":true,
                        "color":"#9467bd",
                        "label":"Critical range",
                        "value":20,
                        "fill":"above",
                        "yAxis":"right"
                        }
                    ]
                }
            }
        },
        {
            "type":"metric",
            "x":0,
            "y":0,
            "width":12,
            "height":6,
            "properties":{
                "metrics":[
                    [
                        "AWS/EC2",
                        "CPUUtilization",
                        "InstanceId",
                        "${data.aws_instances.first_instance_id.ids[1]}"
                    ],
                    [
                        "AWS/EC2",
                        "NetworkIn",
                        "InstanceId",
                        "${data.aws_instances.first_instance_id.ids[1]}",
                        {
                        "yAxis":"right",
                        "label":"NetworkIn",
                        "period":300,
                        "stat":"Maximum"
                        }
                    ],
                    [
                        "CWAgent",
                        "mem_used_percent",
                        "host",
                        "${data.aws_instance.second_instance_dns.private_dns}",
                        {
                        "yAxis":"right",
                        "label":"MemoryUsage",
                        "period":300,
                        "stat":"Maximum"
                        }
                    ]
                ],
                "period":300,
                "stat":"Average",
                "region":"eu-west-1",
                "timezone":"+0300",
                "title":"${data.aws_instances.first_instance_id.ids[1]} EC2 Instance Metrics",
                "stacked":true,
                "view":"timeSeries",
                "liveData":false,
                "yAxis":{
                    "left":{
                        "min":0,
                        "max":100
                    },
                    "right":{
                        "min":50
                    }
                },
                "annotations":{
                    "horizontal":[
                        {
                        "visible":true,
                        "color":"#9467bd",
                        "label":"Critical range",
                        "value":20,
                        "fill":"above",
                        "yAxis":"right"
                        }
                    ]
                }
            }
        },
        {
            "type":"metric",
            "x":0,
            "y":0,
            "width":12,
            "height":6,
            "properties":{
                "metrics":[
                    [
                        "AWS/RDS",
                        "CPUUtilization",
                        "EngineName",
                        "${data.aws_db_instance.db.engine}"
                    ],
                    [
                        "AWS/RDS",
                        "NetworkReceiveThroughput",
                        "EngineName",
                        "${data.aws_db_instance.db.engine}",
                        {
                        "yAxis":"right",
                        "label":"NetworkReceiveThroughput",
                        "period":300,
                        "stat":"Maximum"
                        }
                    ],
                    [
                        "AWS/RDS",
                        "DatabaseConnections",
                        "EngineName",
                        "${data.aws_db_instance.db.engine}",
                        {
                        "yAxis":"left",
                        "label":"DatabaseConnections",
                        "period":300,
                        "stat":"Maximum"
                        }
                    ],
                    [
                        "AWS/RDS",
                        "FreeStorageSpace",
                        "EngineName",
                        "${data.aws_db_instance.db.engine}",
                        {
                        "yAxis":"right",
                        "label":"FreeStorageSpace",
                        "period":300,
                        "stat":"Maximum"
                        }
                    ]
                ],
                "period":300,
                "stat":"Average",
                "region":"eu-west-1",
                "timezone":"+0300",
                "title":"${data.aws_db_instance.db.engine} DB Instance Metrics",
                "stacked":true,
                "view":"timeSeries",
                "liveData":false,
                "yAxis":{
                    "left":{
                        "min":0,
                        "max":100
                    },
                    "right":{
                        "min":50
                    }
                },
                "annotations":{
                    "horizontal":[
                        {
                        "visible":true,
                        "color":"#9467bd",
                        "label":"Critical range",
                        "value":20,
                        "fill":"above",
                        "yAxis":"right"
                        }
                    ]
                }
            }
        },
        {
            "type":"metric",
            "x":0,
            "y":0,
            "width":12,
            "height":6,
            "properties":{
                "metrics":[
                    [
                        "AWS/ECS",
                        "CPUUtilization",
                        "ClusterName",
                        "${aws_ecs_cluster.app_cluster.name}"
                    ],
                    [
                        "AWS/ECS",
                        "MemoryUtilization",
                        "ClusterName",
                        "${aws_ecs_cluster.app_cluster.name}",
                        {
                        "yAxis":"right",
                        "label":"MemoryUtilization",
                        "period":300,
                        "stat":"Maximum"
                        }
                    ]
                ],
                "period":300,
                "stat":"Average",
                "region":"eu-west-1",
                "timezone":"+0300",
                "title":"${aws_ecs_cluster.app_cluster.name} Metrics",
                "stacked":true,
                "view":"timeSeries",
                "liveData":false,
                "yAxis":{
                    "left":{
                        "min":0,
                        "max":100
                    },
                    "right":{
                        "min":50
                    }
                },
                "annotations":{
                    "horizontal":[
                        {
                        "visible":true,
                        "color":"#9467bd",
                        "label":"Critical range",
                        "value":20,
                        "fill":"above",
                        "yAxis":"right"
                        }
                    ]
                }
            }
        }
    ]
}
EOF
}

resource "aws_cloudwatch_metric_alarm" "bat" {
  alarm_name          = "Autoscaling Group CPU Utilization-Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ecs_asg.name
  }
  actions_enabled   = true
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.my_scaling.arn]
}

resource "aws_cloudwatch_metric_alarm" "cw_alarm" {
  count                     = length(var.alarm_type)
  alarm_name                = "${var.alarm_type[count.index]}-Alarm"
  comparison_operator       = var.comparison_operator[count.index]
  evaluation_periods        = var.evaluation_periods[count.index]
  metric_name               = var.metric_name[count.index]
  namespace                 = var.name_space[count.index]
  period                    = var.period[count.index]
  statistic                 = var.statistic[count.index]
  threshold                 = var.threshold[count.index]
  alarm_description         = "This metric monitors ${var.alarm_type[count.index]}"
  insufficient_data_actions = []

  actions_enabled = true
  alarm_actions   = [data.aws_sns_topic.email_incident_topic.arn]
}
