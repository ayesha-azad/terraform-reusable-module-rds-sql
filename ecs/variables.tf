variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-north-1"
}

variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_ids" {
  description = "List of subnet IDs for ALB and ECS tasks"
  type        = list(string)
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "my-alb"
}

variable "target_group_name_prefix" {
  description = "Prefix for the target group name"
  type        = string
  default     = "ecs"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "ecs-integrated"
}

variable "cluster_capacity_providers" {
  description = "List of capacity providers for the cluster"
  type        = list(string)
  default     = ["FARGATE", "FARGATE_SPOT"]
}

variable "default_capacity_provider_strategy" {
  description = "Default capacity provider strategy for the cluster"
  type = map(object({
    weight = number
    base   = optional(number)
  }))
  default = {
    FARGATE = {
      weight = 50
      base   = 20
    }
    FARGATE_SPOT = {
      weight = 50
    }
  }
}

variable "service_cpu" {
  description = "CPU units for the service"
  type        = number
  default     = 1024
}

variable "service_memory" {
  description = "Memory for the service in MB"
  type        = number
  default     = 4096
}

variable "container_name" {
  description = "Name of the container"
  type        = string
  default     = "ecs-sample"
}

variable "container_image" {
  description = "Docker image for the container"
  type        = string
  default     = "ayeshaazad/devops-showcase"
}

variable "container_cpu" {
  description = "CPU units for the container"
  type        = number
  default     = 512
}

variable "container_memory" {
  description = "Memory for the container in MB"
  type        = number
  default     = 1024
}

variable "container_memory_reservation" {
  description = "Soft memory reservation for the container in MB"
  type        = number
  default     = 100
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 80
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "ECS"
    ManagedBy   = "Terraform"
  }
}