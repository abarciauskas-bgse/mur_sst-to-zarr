provider "aws" {
  region = "us-east-1"
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
   values = ["*amazon-ecs-optimized"]
 }
}

data "template_file" "ecs_instance_init" {
  template = "${file("ecs-cluster.sh.tpl")}"

  vars = {
    cluster_name = aws_ecs_cluster.eodc_ecs_cluster.name
  }
}

data "template_file" "podaac_drive_task_definition" {
  template = "${file("task-definitions/data-staging/podaac_drive.json.tpl")}"

  vars = {
    aws_account_id = data.aws_caller_identity.current.account_id
    aws_region = data.aws_region.current.name
  }
}

data "template_file" "netcdf_to_zarr_task_definition" {
  template = "${file("task-definitions/netcdf-to-zarr.json.tpl")}"

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
  image_id      = data.aws_ami.amazon-linux-2-ecs-optimized.id
  instance_type = "m5.16xlarge"
  user_data = data.template_file.ecs_instance_init.rendered
  key_name = var.keypair
  iam_instance_profile = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/ecsInstanceRole"
}

resource "aws_autoscaling_group" "ecs_asg" {
  availability_zones = ["us-east-1a"]
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

resource "aws_ecs_task_definition" "podaac_drive" {
  family = "eodc-podaac_drive"
  container_definitions = data.template_file.podaac_drive_task_definition.rendered

  volume {
    name      = "service-storage"
    host_path = "/fsx"
  }
}

resource "aws_ecs_task_definition" "netcdf_to_zarr" {
  family = "eodc-netcdf_to_zarr"
  container_definitions = data.template_file.netcdf_to_zarr_task_definition.rendered

  volume {
    name      = "service-storage"
    host_path = "/fsx"
  }
}

resource "aws_ecs_task_definition" "s3_sync" {
  family = "eodc-s3_sync"
  container_definitions = data.template_file.s3_sync_task_definition.rendered

  volume {
    name      = "service-storage"
    host_path = "/fsx"
  }
}

