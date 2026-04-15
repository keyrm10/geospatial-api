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
  description = "Environment (dev, stg, prd)"

  validation {
    condition     = contains(["dev", "stg", "prd"], var.environment)
    error_message = "Environment must be one of: dev, stg, prd."
  }
}

variable "repository_id" {
  type        = string
  description = "Artifact Registry repository name"
  default     = "geospatial-api"
}

variable "state_bucket" {
  type        = string
  description = "GCS bucket for OpenTofu remote state"
}

variable "api_image_ref" {
  type        = string
  description = "API container image reference (tag or digest)"
  default     = "us-docker.pkg.dev/cloudrun/container/placeholder"
}

variable "cache_image_ref" {
  type        = string
  description = "Cache container image reference (tag or digest)"
  default     = "us-docker.pkg.dev/cloudrun/container/placeholder"
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
  type        = map(number)
  description = "API minimum instances per environment"
  default = {
    dev  = 0
    stg  = 5
    prod = 5
  }
}

variable "api_max_instances" {
  type        = map(number)
  description = "API maximum instances per environment"
  default = {
    dev  = 5
    stg  = 5
    prod = 5
  }
}

variable "cache_min_instances" {
  type        = map(number)
  description = "Cache minimum instances per environment"
  default = {
    dev  = 0
    stg  = 1
    prod = 1
  }
}

variable "cache_max_instances" {
  type        = map(number)
  description = "Cache maximum instances per environment"
  default = {
    dev  = 1
    stg  = 1
    prod = 1
  }
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
