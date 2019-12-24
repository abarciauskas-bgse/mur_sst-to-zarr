provider "aws" {
  # version = "~> 3.0"
  region = "us-east-1"
}

variable "deployment" {
  description = "Deployment-specific prefix to distinguish multiple deployments, for multiple developers or environments."
}

variable "keypair" {
  description = "Key pair name that should be deployed with ECS instances"
}

resource "aws_ecs_cluster" "eodc_ecs_cluster" {
  name = "${var.deployment}-eodc-cluster"
}

data "aws_ami" "amazon-linux-2-ecs-optimized" {
 most_recent = true
 owners = ["amazon"]

 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["*amazon-ecs-optimized"]
 }
}

data "template_file" "ecs_instance_init" {
  template = "${file("ecs-cluster.sh.tpl")}"

  vars = {
    cluster_name = aws_ecs_cluster.eodc_ecs_cluster.name
  }
}

resource "aws_launch_configuration" "as_conf" {
  name          = "web_config"
  image_id      = data.aws_ami.amazon-linux-2-ecs-optimized.id
  instance_type = "m5.2xlarge"
  user_data = data.template_file.ecs_instance_init.rendered
  key_name = var.keypair
  root_block_device {
    volume_size = 20
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  launch_configuration = aws_launch_configuration.as_conf.id
}

