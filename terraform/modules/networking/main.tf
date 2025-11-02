# Networking Module - VPC, subnets, NAT gateway, and firewall rules

# Custom VPC network
resource "google_compute_network" "vpc" {
  name                    = "gcp-infrastructure-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
  project                 = var.project_id
  
  description = "Custom VPC for GCP infrastructure deployment with private GKE cluster"
}

# Management subnet - contains NAT gateway and management VM
resource "google_compute_subnetwork" "management" {
  name          = "management-subnet"
  ip_cidr_range = var.management_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
  
  description = "Management subnet with NAT gateway for private VM and cluster management"
  
  # Enable private Google access for accessing Google APIs
  private_ip_google_access = true
  
  # Secondary IP ranges for future use if needed
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Restricted subnet - contains private GKE cluster with no internet access
resource "google_compute_subnetwork" "restricted" {
  name          = "restricted-subnet"
  ip_cidr_range = var.restricted_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
  
  description = "Restricted subnet for private GKE cluster with no direct internet access"
  
  # Enable private Google access for GKE to access Google APIs
  private_ip_google_access = true
  
  # Secondary IP ranges for GKE pods and services
  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = "10.1.0.0/16"
  }
  
  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = "10.2.0.0/16"
  }
  
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# Cloud Router for NAT gateway
resource "google_compute_router" "router" {
  name    = "management-router"
  region  = var.region
  network = google_compute_network.vpc.id
  project = var.project_id
  
  description = "Cloud Router for NAT gateway in management subnet"
}

# Cloud NAT for outbound internet access from management subnet
resource "google_compute_router_nat" "nat" {
  name                               = "management-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  project                            = var.project_id
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  
  # Only allow NAT for management subnet
  subnetwork {
    name                    = google_compute_subnetwork.management.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
  
  # Enable endpoint independent mapping for better performance
  enable_endpoint_independent_mapping = false
}

# Firewall rule to allow SSH access to management VM
resource "google_compute_firewall" "allow_ssh_management" {
  name    = "allow-ssh-management"
  network = google_compute_network.vpc.name
  project = var.project_id
  
  description = "Allow SSH access to management VM from authorized sources"
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  source_ranges = ["35.235.240.0/20"] # Google Cloud IAP range for SSH
  target_tags   = ["management-vm"]
  
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

# Firewall rule for internal communication between subnets
resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal-communication"
  network = google_compute_network.vpc.name
  project = var.project_id
  
  description = "Allow internal communication between all subnets"
  
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  
  allow {
    protocol = "icmp"
  }
  
  source_ranges = [
    var.management_subnet_cidr,
    var.restricted_subnet_cidr,
    "10.1.0.0/16", # GKE pods
    "10.2.0.0/16"  # GKE services
  ]
  
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

# Firewall rule for GKE cluster communication
resource "google_compute_firewall" "allow_gke_webhooks" {
  name    = "allow-gke-webhooks"
  network = google_compute_network.vpc.name
  project = var.project_id
  
  description = "Allow GKE master to access webhooks on nodes"
  
  allow {
    protocol = "tcp"
    ports    = ["8443", "9443", "15017"]
  }
  
  source_ranges = ["172.16.0.0/28"] # GKE master range
  target_tags   = ["gke-node"]
  
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

# Firewall rule to allow health checks for load balancer
resource "google_compute_firewall" "allow_health_checks" {
  name    = "allow-health-checks"
  network = google_compute_network.vpc.name
  project = var.project_id
  
  description = "Allow health checks from Google Cloud Load Balancer"
  
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080"]
  }
  
  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]
  target_tags = ["gke-node"]
  
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}