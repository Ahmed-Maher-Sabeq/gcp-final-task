# Output values for the GCP Infrastructure Deployment

# Networking outputs
output "vpc_name" {
  description = "Name of the VPC network"
  value       = module.networking.vpc_name
}

output "management_subnet_name" {
  description = "Name of the management subnet"
  value       = module.networking.management_subnet_name
}

output "restricted_subnet_name" {
  description = "Name of the restricted subnet"
  value       = module.networking.restricted_subnet_name
}

output "nat_gateway_name" {
  description = "Name of the NAT gateway"
  value       = module.networking.nat_gateway_name
}

# IAM outputs
output "gke_service_account_email" {
  description = "Email of the custom GKE service account"
  value       = module.iam.gke_service_account_email
}

# Compute outputs
output "management_vm_name" {
  description = "Name of the management VM"
  value       = module.compute.vm_name
}

output "management_vm_internal_ip" {
  description = "Internal IP address of the management VM"
  value       = module.compute.vm_internal_ip
}

# GKE outputs
output "gke_cluster_name" {
  description = "Name of the GKE cluster"
  value       = module.gke.cluster_name
}

output "gke_cluster_endpoint" {
  description = "Endpoint of the GKE cluster"
  value       = module.gke.cluster_endpoint
  sensitive   = true
}

output "gke_cluster_ca_certificate" {
  description = "CA certificate of the GKE cluster"
  value       = module.gke.cluster_ca_certificate
  sensitive   = true
}

# Registry outputs
output "artifact_registry_repository" {
  description = "Name of the Artifact Registry repository"
  value       = module.registry.repository_name
}

output "artifact_registry_url" {
  description = "URL of the Artifact Registry repository"
  value       = module.registry.repository_url
}

# Connection information
output "kubectl_connection_command" {
  description = "Command to connect kubectl to the GKE cluster"
  value       = "gcloud container clusters get-credentials ${module.gke.cluster_name} --region ${local.region} --project ${local.project_id}"
}

output "ssh_to_management_vm" {
  description = "Command to SSH to the management VM"
  value       = "gcloud compute ssh ${module.compute.vm_name} --zone ${local.zone} --project ${local.project_id}"
}

output "docker_push_command" {
  description = "Command to push Docker images to GAR"
  value       = "docker push ${module.registry.repository_url}/python-web-app:latest"
}

output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    project_id         = local.project_id
    region             = local.region
    vpc_name           = module.networking.vpc_name
    cluster_name       = module.gke.cluster_name
    registry_url       = module.registry.repository_url
    management_vm_ip   = module.compute.vm_internal_ip
  }
}