terraform {
  required_version = "~> 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }

  backend "gcs" {
    bucket = var.state_bucket
    prefix = "env/${var.environment}"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
