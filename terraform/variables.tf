variable "aws_region" {
  default = "ap-south-1"
}

variable "docker_image" {
  description = "Docker image for the Strapi application"
  type        = string
  default     = "arfath29/strapi-app:v2"
}
