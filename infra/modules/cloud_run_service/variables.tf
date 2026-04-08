variable "project_id" {
  type        = string
  description = "Google Cloud project for the Cloud Run service"
}

variable "location" {
  type        = string
  description = "Google Cloud region for the Cloud Run service"
}

variable "name" {
  type        = string
  description = "Name for the Cloud Run service"
}

variable "image" {
  type        = string
  description = "Container image URI for the Cloud Run service"
}

variable "service_account_email" {
  type        = string
  description = "Service Account email that Cloud Run uses as the runtime identity"
}

variable "env_vars" {
  type        = map(string)
  description = "Environment variables to expose to the Cloud Run service"
  default     = {}
}

variable "min_instances" {
  type        = number
  description = "Minimum number of Cloud Run instances"
  default     = 0
}

variable "max_instances" {
  type        = number
  description = "Maximum number of Cloud Run instances"
  default     = 5
}

variable "container_port" {
  type        = number
  description = "Container port exposed by the application"
  default     = 8080
}

variable "health_check_path" {
  type        = string
  description = "Path for the startup probe"
  default     = "/healthz"
}

variable "allow_unauthenticated" {
  type        = bool
  description = "Allow unauthenticated public access to the Cloud Run service"
  default     = false
}
