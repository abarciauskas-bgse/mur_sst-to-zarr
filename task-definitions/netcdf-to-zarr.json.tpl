[
  {
    "name": "eodc-netcdf-to-zarr-task-def",
    "image":
    "${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com/eodc-netcdf-to-zarr",
    "cpu": 30,
    "memory": 24000,
    "essential": true,
    "mountPoints": [{
      "sourceVolume": "service-storage",
      "containerPath": "/s3fsx"
    }],
    "portMappings": [{
      "hostPort": 8888,
      "protocol": "tcp",
      "containerPort": 8888
    }, {
      "hostPort": 8787,
      "protocol": "tcp",
      "containerPort": 8787
    }],
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "/ecs/eodc-netcdf-to-zarr",
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
