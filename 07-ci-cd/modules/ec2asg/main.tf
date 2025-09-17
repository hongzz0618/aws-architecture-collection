resource "aws_launch_template" "this" {
  name_prefix   = "${var.project}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs git
mkdir -p /home/ec2-user/app
chown ec2-user:ec2-user /home/ec2-user/app
EOF
  )
}

resource "aws_autoscaling_group" "this" {
  name                      = "${var.project}-asg"
  desired_capacity          = 1
  max_size                  = 1
  min_size                  = 1
  vpc_zone_identifier       = var.subnet_ids
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
  tag {
    key                 = "Project"
    value               = var.project
    propagate_at_launch = true
  }
}
