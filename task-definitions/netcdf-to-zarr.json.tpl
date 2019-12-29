[
  {
    "name": "eodc-netcdf-to-zarr-task-def",
    "image":
    "${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com/eodc-netcdf-to-zarr",
    "cpu": 6,
    "memory": 30000,
    "essential": true,
    "mountPoints": [{
      "sourceVolume": "service-storage",
      "containerPath": "/data"
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
