variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "europe-west1"
}

variable "environment" {
  type        = string
  description = "Environment (dev, stg, prod)"

  validation {
    condition     = contains(["dev", "stg", "prod"], var.environment)
    error_message = "Environment must be one of: dev, stg, prod."
  }
}

variable "repository_id" {
  type        = string
  description = "Artifact Registry repository name"
  default     = "geospatial-api"
}

variable "api_image" {
  type        = string
  description = "API container image URI"
}

variable "cache_image" {
  type        = string
  description = "Cache container image URI"
}

variable "api_image_digest" {
  type        = string
  description = "API image digest (optional)"
  default     = ""
}

variable "cache_image_digest" {
  type        = string
  description = "Cache image digest (optional)"
  default     = ""
}

variable "api_container_port" {
  type        = number
  description = "API container port"
  default     = 3000
}

variable "cache_container_port" {
  type        = number
  description = "Cache container port"
  default     = 8080
}

variable "api_env_vars" {
  type        = map(string)
  description = "API environment variables"
  default     = {}
}

variable "cache_env_vars" {
  type        = map(string)
  description = "Cache environment variables"
  default     = {}
}

variable "api_min_instances" {
  type        = number
  description = "API minimum instances"
  default     = 5
}

variable "api_max_instances" {
  type        = number
  description = "API maximum instances"
  default     = 5
}

variable "cache_min_instances" {
  type        = number
  description = "Cache minimum instances"
  default     = 1
}

variable "cache_max_instances" {
  type        = number
  description = "Cache maximum instances"
  default     = 1
}

variable "api_health_check_path" {
  type        = string
  description = "API health check path"
  default     = "/healthz"
}

variable "cache_health_check_path" {
  type        = string
  description = "Cache health check path"
  default     = "/healthz"
}

variable "api_allow_unauthenticated" {
  type        = bool
  description = "Allow unauthenticated access to API"
  default     = true
}

variable "cache_allow_unauthenticated" {
  type        = bool
  description = "Allow unauthenticated access to cache"
  default     = true
}
