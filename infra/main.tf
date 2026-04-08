resource "google_project_service" "required_apis" {
  for_each = toset([
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "iam.googleapis.com",
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ])
  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

module "artifact_registry" {
  source        = "./modules/artifact_registry"
  project_id    = var.project_id
  location      = var.region
  repository_id = var.repository_id
  depends_on    = [google_project_service.required_apis]
}

module "api_service_account" {
  source       = "./modules/iam"
  project_id   = var.project_id
  account_id   = "${var.environment}-api-sa"
  display_name = "Cloud Run runtime service account for api-${var.environment}"

  artifact_registry_reader        = true
  artifact_registry_location      = module.artifact_registry.location
  artifact_registry_repository_id = module.artifact_registry.repository_id

  roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter"
  ]
}

module "cache_service_account" {
  source       = "./modules/iam"
  project_id   = var.project_id
  account_id   = "${var.environment}-cache-sa"
  display_name = "Cloud Run runtime service account for cache-${var.environment}"

  artifact_registry_reader        = true
  artifact_registry_location      = module.artifact_registry.location
  artifact_registry_repository_id = module.artifact_registry.repository_id

  roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter"
  ]
}

module "api" {
  source                = "./modules/cloud_run_service"
  project_id            = var.project_id
  location              = var.region
  name                  = "api-${var.environment}"
  image                 = var.api_image_digest != "" ? "${split(":", var.api_image)[0]}@${var.api_image_digest}" : var.api_image
  service_account_email = module.api_service_account.email
  env_vars              = var.api_env_vars
  min_instances         = var.api_min_instances
  max_instances         = var.api_max_instances
  container_port        = var.api_container_port
  health_check_path     = var.api_health_check_path
  allow_unauthenticated = var.api_allow_unauthenticated

  depends_on = [
    module.api_service_account,
    module.artifact_registry
  ]
}

module "cache" {
  source                = "./modules/cloud_run_service"
  project_id            = var.project_id
  location              = var.region
  name                  = "cache-${var.environment}"
  image                 = var.cache_image_digest != "" ? "${split(":", var.cache_image)[0]}@${var.cache_image_digest}" : var.cache_image
  service_account_email = module.cache_service_account.email
  env_vars = merge(
    var.cache_env_vars,
    {
      UPSTREAM_URL = module.api.url
    }
  )
  min_instances         = var.cache_min_instances
  max_instances         = var.cache_max_instances
  container_port        = var.cache_container_port
  health_check_path     = var.cache_health_check_path
  allow_unauthenticated = var.cache_allow_unauthenticated

  depends_on = [
    module.api,
    module.cache_service_account,
    module.artifact_registry
  ]
}
