variable "project_id" {
  type        = string
  description = "Google Cloud project to create the Artifact Registry repository in"
}

variable "location" {
  type        = string
  description = "Google Cloud region for the Artifact Registry repository"
}

variable "repository_id" {
  type        = string
  description = "Artifact Registry repository ID"
}
