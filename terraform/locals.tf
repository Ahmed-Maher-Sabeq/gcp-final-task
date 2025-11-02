# Local values for GCP Infrastructure Deployment
# These values are used throughout the configuration

locals {
  # Project configuration
  project_id = "it-gcp-final-task-15807"
  region     = "us-central1"
  zone       = "us-central1-a"
  
  # Environment and naming
  environment = "dev"
  
  # Network configuration
  management_subnet_cidr = "10.0.1.0/24"
  restricted_subnet_cidr = "10.0.2.0/24"
  
  # Compute configuration
  vm_machine_type       = "e2-micro"
  gke_node_machine_type = "e2-small"
  gke_node_count        = 1
  gke_max_node_count    = 2
  
  # Cluster configuration
  cluster_name = "private-gke-cluster"
  
  # Common tags/labels
  common_labels = {
    project     = local.project_id
    environment = local.environment
    managed-by  = "terraform"
  }
}