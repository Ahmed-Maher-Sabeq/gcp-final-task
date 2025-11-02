# Registry Module - Google Artifact Registry for private container images

# Artifact Registry repository
resource "google_artifact_registry_repository" "container_repo" {
  location      = var.region
  repository_id = "gcp-infrastructure-repo"
  description   = "Private container registry for GCP infrastructure deployment"
  format        = "DOCKER"
  project       = var.project_id
  
  labels = {
    environment = "dev"
    managed-by  = "terraform"
  }
}

# IAM policy for the repository - restrict access
resource "google_artifact_registry_repository_iam_binding" "repo_readers" {
  project    = var.project_id
  location   = google_artifact_registry_repository.container_repo.location
  repository = google_artifact_registry_repository.container_repo.name
  role       = "roles/artifactregistry.reader"
  
  members = [
    "serviceAccount:${var.gke_service_account}",
  ]
}

# Allow repository writers (for CI/CD or manual pushes)
resource "google_artifact_registry_repository_iam_binding" "repo_writers" {
  project    = var.project_id
  location   = google_artifact_registry_repository.container_repo.location
  repository = google_artifact_registry_repository.container_repo.name
  role       = "roles/artifactregistry.writer"
  
  members = [
    "serviceAccount:${var.gke_service_account}",
  ]
}