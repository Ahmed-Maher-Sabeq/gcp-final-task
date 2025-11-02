# Root Terraform configuration for GCP Infrastructure Deployment
# This file orchestrates all modules to create the complete infrastructure

# IAM Module - Service accounts and permissions
module "iam" {
  source = "./modules/iam"
  
  project_id = local.project_id
}

# Networking Module - VPC, subnets, NAT gateway
module "networking" {
  source = "./modules/networking"
  
  project_id               = local.project_id
  region                   = local.region
  management_subnet_cidr   = local.management_subnet_cidr
  restricted_subnet_cidr   = local.restricted_subnet_cidr
}

# Artifact Registry Module - Private container registry
module "registry" {
  source = "./modules/registry"
  
  project_id          = local.project_id
  region              = local.region
  gke_service_account = module.iam.gke_service_account_email
  
  depends_on = [module.iam]
}

# Compute Module - Management VM
module "compute" {
  source = "./modules/compute"
  
  project_id           = local.project_id
  region               = local.region
  zone                 = local.zone
  management_subnet    = module.networking.management_subnet
  gke_service_account  = module.iam.gke_service_account_email
  vm_machine_type      = local.vm_machine_type
  
  depends_on = [module.networking, module.iam]
}

# GKE Module - Private Kubernetes cluster
module "gke" {
  source = "./modules/gke"
  
  project_id              = local.project_id
  region                  = local.region
  cluster_name            = local.cluster_name
  restricted_subnet       = module.networking.restricted_subnet
  management_subnet_cidr  = local.management_subnet_cidr
  gke_service_account     = module.iam.gke_service_account_email
  node_machine_type       = local.gke_node_machine_type
  node_count              = local.gke_node_count
  max_node_count          = local.gke_max_node_count
  
  depends_on = [module.networking, module.iam]
}