# Outputs for networking module

output "vpc_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.vpc.name
}

output "vpc_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.vpc.id
}

output "management_subnet" {
  description = "Management subnet resource"
  value       = google_compute_subnetwork.management
}

output "management_subnet_name" {
  description = "Name of the management subnet"
  value       = google_compute_subnetwork.management.name
}

output "management_subnet_cidr" {
  description = "CIDR block of the management subnet"
  value       = google_compute_subnetwork.management.ip_cidr_range
}

output "restricted_subnet" {
  description = "Restricted subnet resource"
  value       = google_compute_subnetwork.restricted
}

output "restricted_subnet_name" {
  description = "Name of the restricted subnet"
  value       = google_compute_subnetwork.restricted.name
}

output "restricted_subnet_cidr" {
  description = "CIDR block of the restricted subnet"
  value       = google_compute_subnetwork.restricted.ip_cidr_range
}

output "nat_gateway_name" {
  description = "Name of the NAT gateway"
  value       = google_compute_router_nat.nat.name
}

output "router_name" {
  description = "Name of the Cloud Router"
  value       = google_compute_router.router.name
}

output "gke_pods_cidr" {
  description = "CIDR block for GKE pods"
  value       = "10.1.0.0/16"
}

output "gke_services_cidr" {
  description = "CIDR block for GKE services"
  value       = "10.2.0.0/16"
}