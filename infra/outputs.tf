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
