# Infrastructure as Code

This directory provisions Google Cloud resources required to run the `api` and `cache` services on Cloud Run using OpenTofu.

> OpenTofu was chosen instead of Terraform since it remains fully open source after Terraform changed its licence to BSL. OpenTofu provides the same functionality and compatibility, while ensuring the infrastructure tooling stays vendor neutral and openly licensed.

## Environment files

Maintain separate tfvars files per environment in `environments/`. Each defines project-specific values while sharing module logic. Validate the `environment` variable to prevent misconfiguration.

### Requirements

- OpenTofu ~> 1.5
- Google provider ~> 7.0
- Google Cloud project with billing enabled and Artifact Registry API activated

## Usage

Initialise with environment-specific tfvars:

```sh
tofu init
tofu plan -var-file=envs/dev.tfvars
tofu apply -var-file=envs/dev.tfvars
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| project_id | Google Cloud project ID | string | - |
| region | Google Cloud region | string | "europe-west1" |
| environment | Deployment environment (dev, stg, prod) | string | - |
| repository_id | Artifact Registry repository name | string | "geospatial-api" |
| api_image | Container image URI for api service | string | - |
| cache_image | Container image URI for cache service | string | - |
| api_image_digest | Optional image digest for api service | string | "" |
| cache_image_digest | Optional image digest for cache service | string | "" |
| api_container_port | Container port for api service | number | 3000 |
| cache_container_port | Container port for cache service | number | 8080 |
| api_env_vars | Environment variables for api service | map(string) | {} |
| cache_env_vars | Environment variables for cache service | map(string) | {} |

## Outputs

| Name | Description |
|------|-------------|
| api_url | Public URL for the Cloud Run api service |
| cache_url | Public URL for the Cloud Run cache service |
| api_service_name | Cloud Run service name for api |
| cache_service_name | Cloud Run service name for cache |

## Architecture

- **Artifact Registry**: Private Docker repository for container images.
- **Service Accounts**: Dedicated runtime identities for each Cloud Run service with least-privilege Artifact Registry reader access.
- **Cloud Run Services**:
  - `api`: Publicly accessible, scaled to 5 instances.
  - `cache`: Publicly accessible, scaled to 1 instance, injects api service URL as `UPSTREAM_URL`.
