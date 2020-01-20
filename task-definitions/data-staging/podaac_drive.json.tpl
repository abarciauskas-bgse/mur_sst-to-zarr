[
  {
    "name": "podaac-drive",
    "image":
    "${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com/eodc-mount-podaac-drive",
    "cpu": 10,
    "memory": 24000,
    "essential": true,
    "devices": ["/dev/fuse"],
    "privileged": true,
    "linuxParameters": {
      "capabilities": {
        "add": ["SYS_ADMIN"]
      }
    },
    "mountPoints": [{
      "sourceVolume": "service-storage",
      "containerPath": "/s3fs"
    }],
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "/ecs/eodc-podaac_drive",
        "awslogs-region": "${aws_region}",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
