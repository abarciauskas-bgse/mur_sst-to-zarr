provider "aws" {
  region = "us-west-2"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

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
   values = ["amzn2-ami-ecs*"]
 }
}

data "template_file" "ecs_instance_init" {
  template = "${file("ecs-cluster.sh.tpl")}"

  vars = {
    cluster_name = aws_ecs_cluster.eodc_ecs_cluster.name
  }
}

data "template_file" "zarr_rechunker_task_definition" {
  template = "${file("task-definitions/zarr_rechunker.json.tpl")}"

  vars = {
    aws_account_id = data.aws_caller_identity.current.account_id
    aws_region = data.aws_region.current.name
  }
}

data "template_file" "s3_sync_task_definition" {
  template = "${file("task-definitions/data-staging/s3_sync.json.tpl")}"

  vars = {
    aws_account_id = data.aws_caller_identity.current.account_id
    aws_region = data.aws_region.current.name
  }
}

resource "aws_launch_configuration" "as_conf" {
  name          = "eodc-ecs-cluster"
  # Note dynamically setting the image id means new images will force the cluster
  # to attempt to destroy and recreate, which will fail because it's attached to
  # an ASG
  image_id    = data.aws_ami.amazon-linux-2-ecs-optimized.id
  instance_type = "r5.16xlarge"
  user_data = data.template_file.ecs_instance_init.rendered
  key_name = var.keypair
  iam_instance_profile = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/ecsInstanceRole"

  root_block_device {
    volume_size = 200
  }
  ebs_block_device {
    device_name = "/dev/xvdcz"
    volume_size = 200
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  availability_zones = ["us-west-2a"]
  desired_capacity   = 1
  max_size           = 5
  min_size           = 1
  launch_configuration = aws_launch_configuration.as_conf.id

  tag {
    key                 = "project"
    value               = "eodc"
    propagate_at_launch = true
  }
}

resource "aws_ecs_task_definition" "zarr_rechunker" {
  family = "zarr_rechunker"
  container_definitions = data.template_file.zarr_rechunker_task_definition.rendered
}

resource "aws_ecs_task_definition" "s3_sync" {
  family = "s3_sync"
  container_definitions = data.template_file.s3_sync_task_definition.rendered
}

