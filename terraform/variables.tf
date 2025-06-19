variable "aws_region" {
  default = "us-east-1"
}

variable "docker_image" {
  description = "Docker image for the Strapi application"
  type        = string
  default     = "arfath29/strapi-app:v2"
}
