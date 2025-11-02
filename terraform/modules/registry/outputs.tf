# Outputs for registry module

output "repository_name" {
  description = "Name of the Artifact Registry repository"
  value       = google_artifact_registry_repository.container_repo.name
}

output "repository_url" {
  description = "URL of the Artifact Registry repository"
  value       = "${google_artifact_registry_repository.container_repo.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.container_repo.repository_id}"
}

output "repository_location" {
  description = "Location of the Artifact Registry repository"
  value       = google_artifact_registry_repository.container_repo.location
}