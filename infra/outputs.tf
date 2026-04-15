output "api_url" {
  description = "Public URL for the Cloud Run api service"
  value       = module.api.url
}

output "cache_url" {
  description = "Public URL for the Cloud Run cache service"
  value       = module.cache.url
}

output "api_service_name" {
  description = "Cloud Run service name for the api service"
  value       = module.api.name
}

output "cache_service_name" {
  description = "Cloud Run service name for the cache service"
  value       = module.cache.name
}

output "github_actions_service_accounts" {
  description = "Service accounts for GitHub Actions WIF"
  value = {
    build  = google_service_account.github_actions_build.email
    deploy = google_service_account.github_actions_deploy.email
    infra  = google_service_account.github_actions_infra.email
  }
  sensitive = true
}
