# Enable required APIs
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

# Artifact Registry
module "artifact_registry" {
  source        = "./modules/artifact_registry"
  project_id    = var.project_id
  location      = var.region
  repository_id = var.repository_id
  depends_on    = [google_project_service.required_apis]
}

# GitHub Actions WIF service accounts
resource "google_service_account" "github_actions_build" {
  account_id   = "gha-build-${var.environment}"
  project      = var.project_id
  display_name = "GitHub Actions build SA (${var.environment})"
}

resource "google_service_account" "github_actions_deploy" {
  account_id   = "gha-deploy-${var.environment}"
  project      = var.project_id
  display_name = "GitHub Actions deploy SA (${var.environment})"
}

resource "google_service_account" "github_actions_infra" {
  account_id   = "gha-infra-${var.environment}"
  project      = var.project_id
  display_name = "GitHub Actions infra SA (${var.environment})"
}

# Build SA: push to Artifact Registry
resource "google_artifact_registry_repository_iam_member" "build_writer" {
  project    = var.project_id
  location   = module.artifact_registry.location
  repository = module.artifact_registry.repository_id
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.github_actions_build.email}"
}

# Deploy SA: deploy to Cloud Run services
resource "google_cloud_run_v2_service_iam_member" "deploy_invoker_api" {
  name     = module.api.name
  location = var.region
  project  = var.project_id
  role     = "roles/run.developer"
  member   = "serviceAccount:${google_service_account.github_actions_deploy.email}"
}

resource "google_cloud_run_v2_service_iam_member" "deploy_invoker_cache" {
  name     = module.cache.name
  location = var.region
  project  = var.project_id
  role     = "roles/run.developer"
  member   = "serviceAccount:${google_service_account.github_actions_deploy.email}"
}

# Infra SA: manage project resources
resource "google_project_iam_member" "infra_editor" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.github_actions_infra.email}"
}

# Runtime service accounts
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

# Cloud Run services
module "api" {
  source                = "./modules/cloud_run_service"
  project_id            = var.project_id
  location              = var.region
  name                  = "api-${var.environment}"
  image                 = var.api_image_ref
  service_account_email = module.api_service_account.email
  env_vars              = var.api_env_vars
  min_instances         = var.api_min_instances[var.environment]
  max_instances         = var.api_max_instances[var.environment]
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
  image                 = var.cache_image_ref
  service_account_email = module.cache_service_account.email
  env_vars = merge(
    var.cache_env_vars,
    { UPSTREAM_URL = module.api.url }
  )
  min_instances         = var.cache_min_instances[var.environment]
  max_instances         = var.cache_max_instances[var.environment]
  container_port        = var.cache_container_port
  health_check_path     = var.cache_health_check_path
  allow_unauthenticated = var.cache_allow_unauthenticated

  depends_on = [
    module.api,
    module.cache_service_account,
    module.artifact_registry
  ]
}
