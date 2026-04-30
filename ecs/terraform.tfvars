aws_region = "eu-north-1"

vpc_id   = "vpc-0245204999c62da0c"
vpc_cidr = "172.31.0.0/16"

subnet_ids = [
  "subnet-0c8afdd76b2f4cfe0",
  "subnet-0dd6819244654a5ea",
  "subnet-0dd804a1910681d47"
]

alb_name                 = "my-alb"
target_group_name_prefix = "ecs"

cluster_name = "ecs-integrated"

service_cpu    = 1024
service_memory = 4096

container_name               = "ecs-sample"
container_image              = "ayeshaazad/devops-showcase"
container_cpu                = 512
container_memory             = 1024
container_memory_reservation = 100
container_port               = 80

tags = {
  Environment = "Development"
  Project     = "ECS"
  ManagedBy   = "Terraform"
}