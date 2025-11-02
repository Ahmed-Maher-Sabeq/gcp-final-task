# IAM Module - Service accounts and permissions for GCP Infrastructure

# Custom service account for GKE nodes
resource "google_service_account" "gke_nodes" {
  account_id   = "gke-nodes-sa"
  display_name = "GKE Nodes Service Account"
  description  = "Custom service account for GKE node pools with minimal required permissions"
  project      = var.project_id
}

# Basic GKE node permissions - minimal required roles
resource "google_project_iam_member" "gke_node_service_account" {
  project = var.project_id
  role    = "roles/container.nodeServiceAccount"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# Allow nodes to pull images from GCR/GAR
resource "google_project_iam_member" "gke_gcr_access" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# Monitoring and logging permissions for nodes
resource "google_project_iam_member" "gke_monitoring_viewer" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_logging_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# Monitoring metric writer for node metrics
resource "google_project_iam_member" "gke_monitoring_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# Google Artifact Registry permissions for pulling images
resource "google_project_iam_member" "gke_artifact_registry_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# Additional permission for GAR authentication
resource "google_project_iam_member" "gke_artifact_registry_token_creator" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageConsumer"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# Allow the main service account to use the GKE service account
resource "google_service_account_iam_member" "gke_service_account_user" {
  service_account_id = google_service_account.gke_nodes.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:cluster-admin-sa@it-gcp-final-task-15807.iam.gserviceaccount.com"
}

# Allow the main service account to use the default compute service account
resource "google_project_iam_member" "compute_service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:cluster-admin-sa@it-gcp-final-task-15807.iam.gserviceaccount.com"
}

# Add GKE cluster access permissions for the service account
resource "google_project_iam_member" "gke_cluster_viewer" {
  project = var.project_id
  role    = "roles/container.clusterViewer"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}