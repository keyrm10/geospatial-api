output "repository_id" {
  value       = google_artifact_registry_repository.this.repository_id
  description = "Artifact Registry repository ID"
}

output "location" {
  value       = google_artifact_registry_repository.this.location
  description = "Artifact Registry repository region"
}

output "repository_url" {
  value       = "${google_artifact_registry_repository.this.location}-docker.pkg.dev/${google_artifact_registry_repository.this.project}/${google_artifact_registry_repository.this.repository_id}"
  description = "Docker repository endpoint for images"
}
