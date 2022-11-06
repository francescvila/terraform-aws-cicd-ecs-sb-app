[
  {
    "name": "${project_name}",
    "image": "${repository_url}:latest",
    "cpu": 512,
    "memory": 1024,
    "networkMode": "awsvpc",
    "healthCheck": {
      "retries": 5,
      "command": [ "CMD-SHELL", "curl -f http://localhost:80/ || exit 1" ],
      "timeout": 15,
      "interval": 30,
      "startPeriod": 10
    },
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/${project_name}",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "hostPort": 80,
        "protocol": "tcp",
        "containerPort": 80
      }
    ]
  }
]