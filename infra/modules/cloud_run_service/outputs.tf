output "url" {
  value       = google_cloud_run_v2_service.this.uri
  description = "Public URL for the Cloud Run service"
}

output "name" {
  value       = google_cloud_run_v2_service.this.name
  description = "Cloud Run service name"
}
