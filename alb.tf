<<<<<<< HEAD

=======
# Create Security Group for the Web Server
# terraform aws create security group
resource "aws_security_group" "webserver-security-group" {
  name        = "Web Server Security Group"
  description = "Enable HTTP/HTTPS access on Port 80/443 via ALB and SSH access on Port 22 via SSH SG"
  vpc_id      = aws_vpc.main.id
  ingress {
    description     = "SSH Access"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }
  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }
  ingress {
    description     = "HTTPS"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Web Server Security Group"
  }
}
>>>>>>> 8dd1ab5862f8bf5be677a0a5f09c4cd221890aaf

# resource "aws_security_group" "allow_http" {
#   name        = "allow_http"
#   description = "Allow HTTP inbound connections"
<<<<<<< HEAD
#   vpc_id      = aws_vpc.main_vpc.id
=======
#   vpc_id      = aws_vpc.main.id
>>>>>>> 8dd1ab5862f8bf5be677a0a5f09c4cd221890aaf

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "Allow HTTP Security Group"
#   }
# }
<<<<<<< HEAD
# resource "aws_launch_configuration" "web" {
#   name_prefix = "web-"

#   image_id                    = "ami-0d9858aa3c6322f73" # Amazon Linux 2 AMI (HVM), SSD Volume Type
#   instance_type               = "t2.micro"
#   security_groups             = [aws_security_group.allow_http.id]
#   associate_public_ip_address = true
#   user_data                   = file("user_data.sh")
#   lifecycle {
#     create_before_destroy = true
#   }
# }
# resource "aws_security_group" "elb_http" {
#   name        = "elb_http"
#   description = "Allow HTTP traffic to instances through Elastic Load Balancer"
#   vpc_id      = aws_vpc.main_vpc.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     description = "SSH"
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#   }
#   ingress {
#     description = "HTTPS"
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "Allow HTTP through ELB Security Group"
#   }
# }

# resource "aws_elb" "web_elb" {
#   name = "web-elb"
#   security_groups = [
#     aws_security_group.elb_http.id
#   ]
#   subnets = [
#     aws_subnet.public_us_west_1a.id,
#     aws_subnet.public_us_west_1c.id
#   ]
#   cross_zone_load_balancing = true

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     interval            = 30
#     target              = "HTTP:80/"
#   }

#   listener {
#     lb_port           = 80
#     lb_protocol       = "http"
#     instance_port     = "80"
#     instance_protocol = "http"
#   }

# }
# resource "aws_autoscaling_group" "web" {
#   name = "${aws_launch_configuration.web.name}-asg"

#   min_size         = 1
#   desired_capacity = 2
#   max_size         = 6

#   health_check_type = "ELB"
#   load_balancers = [
#     aws_elb.web_elb.id
#   ]

#   launch_configuration = aws_launch_configuration.web.name

#   enabled_metrics = [
#     "GroupMinSize",
#     "GroupMaxSize",
#     "GroupDesiredCapacity",
#     "GroupInServiceInstances",
#     "GroupTotalInstances"
#   ]

#   metrics_granularity = "1Minute"
#   vpc_zone_identifier = aws_subnet.private_subnet.*.id

#   # Required to redeploy without an outage.
#   lifecycle {
#     create_before_destroy = true
#   }

#   tag {
#     key                 = "Name"
#     value               = "web"
#     propagate_at_launch = true
#   }

# }
# resource "aws_autoscaling_policy" "web_policy_up" {
#   name                   = "web_policy_up"
#   scaling_adjustment     = 1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300
#   autoscaling_group_name = aws_autoscaling_group.web.name
# }

# resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
#   alarm_name          = "web_cpu_alarm_up"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "60"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.web.name
#   }

#   alarm_description = "This metric monitor EC2 instance CPU utilization"
#   alarm_actions     = [aws_autoscaling_policy.web_policy_up.arn]
# }
# resource "aws_autoscaling_policy" "web_policy_down" {
#   name                   = "web_policy_down"
#   scaling_adjustment     = -1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300
#   autoscaling_group_name = aws_autoscaling_group.web.name
# }

# resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
#   alarm_name          = "web_cpu_alarm_down"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "10"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.web.name
#   }

#   alarm_description = "This metric monitor EC2 instance CPU utilization"
#   alarm_actions     = [aws_autoscaling_policy.web_policy_down.arn]
# }
# resource "aws_launch_configuration" "app" {
#   name_prefix = "app-"

#   image_id                    = "ami-0d9858aa3c6322f73" # Amazon Linux 2 AMI (HVM), SSD Volume Type
#   instance_type               = "t2.micro"
#   security_groups             = [aws_security_group.allow_http.id]
#   associate_public_ip_address = true
#   user_data                   = file("user_data.sh")
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_elb" "app_elb" {
#   name = "app-elb"
#   security_groups = [
#     aws_security_group.elb_http.id
#   ]
#   subnets = [
#     aws_subnet.public_us_west_1a.id,
#     aws_subnet.public_us_west_1c.id
#   ]
#   cross_zone_load_balancing = true

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     interval            = 30
#     target              = "HTTP:80/"
#   }

#   listener {
#     lb_port           = 80
#     lb_protocol       = "http"
#     instance_port     = "80"
#     instance_protocol = "http"
#   }

# }
# resource "aws_autoscaling_group" "app" {
#   name = "${aws_launch_configuration.app.name}-asg"

#   min_size         = 1
#   desired_capacity = 2
#   max_size         = 5

#   health_check_type = "ELB"
#   load_balancers = [
#     aws_elb.web_elb.id
#   ]

#   launch_configuration = aws_launch_configuration.app.name

#   enabled_metrics = [
#     "GroupMinSize",
#     "GroupMaxSize",
#     "GroupDesiredCapacity",
#     "GroupInServiceInstances",
#     "GroupTotalInstances"
#   ]

#   metrics_granularity = "1Minute"
#   vpc_zone_identifier = aws_subnet.private_subnet.*.id

#   # Required to redeploy without an outage.
#   lifecycle {
#     create_before_destroy = true
#   }

#   tag {
#     key                 = "Name"
#     value               = "app"
#     propagate_at_launch = true
#   }

# }
# resource "aws_autoscaling_policy" "app_policy_up" {
#   name                   = "app_policy_up"
#   scaling_adjustment     = 1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300
#   autoscaling_group_name = aws_autoscaling_group.app.name
# }

# resource "aws_cloudwatch_metric_alarm" "app_cpu_alarm_up" {
#   alarm_name          = "app_cpu_alarm_up"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "60"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.app.name
#   }

#   alarm_description = "This metric monitor EC2 instance CPU utilization"
#   alarm_actions     = [aws_autoscaling_policy.app_policy_up.arn]
# }
# resource "aws_autoscaling_policy" "app_policy_down" {
#   name                   = "app_policy_down"
#   scaling_adjustment     = -1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300
#   autoscaling_group_name = aws_autoscaling_group.app.name
# }

# resource "aws_cloudwatch_metric_alarm" "app_cpu_alarm_down" {
#   alarm_name          = "app_cpu_alarm_down"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "10"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.app.name
#   }

#   alarm_description = "This metric monitor EC2 instance CPU utilization"
#   alarm_actions     = [aws_autoscaling_policy.app_policy_down.arn]
# }
=======
resource "aws_launch_configuration" "web" {
  name_prefix = "web-"

  image_id                    = "ami-0d9858aa3c6322f73" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.webserver-security-group.id]
  associate_public_ip_address = true
  user_data                   = file("user_data.sh")
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group" "elb_http" {
  name        = "elb_http"
  description = "Allow HTTP traffic to instances through Elastic Load Balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    description = "HTTPS"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP through ELB Security Group"
  }
}

resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = [
    aws_security_group.elb_http.id
  ]
  subnets = [
    aws_subnet.public_subnet1a.id,
    aws_subnet.public_subnet2c.id
  ]
  cross_zone_load_balancing = true

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }

}
resource "aws_autoscaling_group" "web" {
  name = "${aws_launch_configuration.web.name}-asg"

  min_size         = 1
  desired_capacity = 2
  max_size         = 6

  health_check_type = "ELB"
  load_balancers = [
    aws_elb.web_elb.id
  ]

  launch_configuration = aws_launch_configuration.web.name

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"
  vpc_zone_identifier = [aws_subnet.private_subnet1a.id]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }

}
resource "aws_autoscaling_policy" "web_policy_up" {
  name                   = "web_policy_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name          = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.web_policy_up.arn]
}
resource "aws_autoscaling_policy" "web_policy_down" {
  name                   = "web_policy_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}

resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_down" {
  alarm_name          = "web_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.web_policy_down.arn]
}
resource "aws_launch_configuration" "app" {
  name_prefix = "app-"

  image_id                    = "ami-0d9858aa3c6322f73" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.webserver-security-group.id]
  associate_public_ip_address = true
  user_data                   = file("user_data.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "app_elb" {
  name = "app-elb"
  security_groups = [
    aws_security_group.elb_http.id
  ]
  subnets = [
    aws_subnet.public_subnet1a.id,
    aws_subnet.public_subnet2c.id
  ]
  cross_zone_load_balancing = true

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }

}
resource "aws_autoscaling_group" "app" {
  name = "${aws_launch_configuration.app.name}-asg"

  min_size         = 1
  desired_capacity = 2
  max_size         = 5

  health_check_type = "ELB"
  load_balancers = [
    aws_elb.web_elb.id
  ]

  launch_configuration = aws_launch_configuration.app.name

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"
  vpc_zone_identifier = [aws_subnet.private_subnet1a.id]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "app"
    propagate_at_launch = true
  }

}
resource "aws_autoscaling_policy" "app_policy_up" {
  name                   = "app_policy_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app.name
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_alarm_up" {
  alarm_name          = "app_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.app_policy_up.arn]
}
resource "aws_autoscaling_policy" "app_policy_down" {
  name                   = "app_policy_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app.name
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_alarm_down" {
  alarm_name          = "app_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.app_policy_down.arn]
}
>>>>>>> 8dd1ab5862f8bf5be677a0a5f09c4cd221890aaf
