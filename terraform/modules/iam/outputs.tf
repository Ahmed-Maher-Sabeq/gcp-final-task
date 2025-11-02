# Outputs for IAM module

output "gke_service_account_email" {
  description = "Email address of the GKE nodes service account"
  value       = google_service_account.gke_nodes.email
}

output "gke_service_account_name" {
  description = "Name of the GKE nodes service account"
  value       = google_service_account.gke_nodes.name
}