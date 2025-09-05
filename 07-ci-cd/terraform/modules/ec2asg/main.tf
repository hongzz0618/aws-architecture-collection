variable "instance_type" { type = string }
variable "desired_capacity" { type = number }
variable "iam_instance_profile" { type = string }

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_template" "lt" {
  name_prefix = "example-app-lt-"
  image_id    = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    # Install CodeDeploy agent dependencies
    yum install -y ruby wget unzip
    # Install AWS CodeDeploy agent
    cd /home/ec2-user
    REGION="${var.region}"
    # Download CodeDeploy agent installer for region
    yum install -y awscli
    # install codedeploy agent via S3 installer
    # For Amazon Linux 2
    cd /home/ec2-user
    aws s3 cp s3://aws-codedeploy-${var.region}/latest/install . --region ${var.region}
    chmod +x ./install
    ./install auto > /tmp/codedeploy-install.log
    # Install Nodejs (for running app)
    curl -sL https://rpm.nodesource.com/setup_18.x | bash -
    yum install -y nodejs
    # create app dir
    mkdir -p /home/ec2-user/app
    chown -R ec2-user:ec2-user /home/ec2-user/app
  EOF
  )
}

resource "aws_autoscaling_group" "asg" {
  name = "example-app-asg"
  desired_capacity = var.desired_capacity
  min_size = 1
  max_size = 2
  launch_template {
    id = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "example-app-server"
    propagate_at_launch = true
  }
}

output "asg_name" { value = aws_autoscaling_group.asg.name }
