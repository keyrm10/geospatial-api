output "email" {
  value       = google_service_account.this.email
  description = "Email address of the service account"
}

output "name" {
  value       = google_service_account.this.name
  description = "Resource name of the service account"
}
