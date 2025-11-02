# Outputs for GKE module

output "cluster_name" {
  description = "Name of the GKE cluster"
  value       = google_container_cluster.private_cluster.name
}

output "cluster_endpoint" {
  description = "Endpoint of the GKE cluster"
  value       = google_container_cluster.private_cluster.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "CA certificate of the GKE cluster"
  value       = google_container_cluster.private_cluster.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "cluster_location" {
  description = "Location of the GKE cluster"
  value       = google_container_cluster.private_cluster.location
}

output "node_pool_name" {
  description = "Name of the node pool"
  value       = google_container_node_pool.private_nodes.name
}