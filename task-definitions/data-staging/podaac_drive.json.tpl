[
  {
    "name": "podaac-drive",
    "image":
    "${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com/eodc-mount-podaac-drive",
    "cpu": 10,
    "memory": 512,
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
      "containerPath": "/data"
    }]
  }
]
