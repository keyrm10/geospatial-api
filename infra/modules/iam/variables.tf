variable "project_id" {
  type        = string
  description = "Google Cloud project ID"
}

variable "account_id" {
  type        = string
  description = "Service account ID (prefix)"
}

variable "display_name" {
  type        = string
  description = "Display name for the service account"
}

variable "roles" {
  type        = list(string)
  description = "List of IAM roles to assign to the service account at the project level"
  default     = []
}

variable "artifact_registry_reader" {
  type        = bool
  description = "Grant roles/artifactregistry.reader on the specified repository"
  default     = false
}

variable "artifact_registry_location" {
  type        = string
  description = "Location of the Artifact Registry repository"
  default     = ""
}

variable "artifact_registry_repository_id" {
  type        = string
  description = "ID of the Artifact Registry repository"
  default     = ""
}
