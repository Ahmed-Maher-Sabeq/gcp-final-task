# GKE Module - Private Kubernetes cluster

# Private GKE cluster
resource "google_container_cluster" "private_cluster" {
  name     = var.cluster_name
  location = "${var.region}-a"
  project  = var.project_id
  
  description = "Private GKE cluster for secure application deployment"
  
  # Remove default node pool
  remove_default_node_pool = true
  initial_node_count       = 1
  
  # Network configuration
  network    = var.restricted_subnet.network
  subnetwork = var.restricted_subnet.id
  
  # Private cluster configuration
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
    
    master_global_access_config {
      enabled = false
    }
  }
  
  # IP allocation policy for secondary ranges
  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods"
    services_secondary_range_name = "gke-services"
  }
  
  # Master authorized networks - only management subnet
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.management_subnet_cidr
      display_name = "Management Subnet"
    }
  }
  
  # Network policy
  network_policy {
    enabled  = true
    provider = "CALICO"
  }
  
  # Addons configuration
  addons_config {
    http_load_balancing {
      disabled = false
    }
    
    horizontal_pod_autoscaling {
      disabled = false
    }
    
    network_policy_config {
      disabled = false
    }
    
    dns_cache_config {
      enabled = true
    }
  }
  
  # Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  
  # Logging and monitoring
  logging_config {
    enable_components = [
      "SYSTEM_COMPONENTS",
      "WORKLOADS"
    ]
  }
  
  monitoring_config {
    enable_components = [
      "SYSTEM_COMPONENTS"
    ]
    
    managed_prometheus {
      enabled = true
    }
  }
  
  # Security configuration
  enable_shielded_nodes = true
  
  # Use default maintenance policy
  
  # Resource labels
  resource_labels = {
    environment = "dev"
    managed-by  = "terraform"
  }
}

# Private node pool
resource "google_container_node_pool" "private_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = "${var.region}-a"
  cluster    = google_container_cluster.private_cluster.name
  project    = var.project_id
  
  # Node count and autoscaling
  initial_node_count = var.node_count
  
  autoscaling {
    min_node_count = 1
    max_node_count = var.max_node_count
  }
  
  # Node configuration
  node_config {
    preemptible  = false
    machine_type = var.node_machine_type
    disk_size_gb = 50
    disk_type    = "pd-standard"
    image_type   = "COS_CONTAINERD"
    
    # Service account
    service_account = var.gke_service_account
    
    # OAuth scopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    
    # Network tags
    tags = ["gke-node"]
    
    # Shielded instance config
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
    
    # Workload metadata config
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    
    # Labels
    labels = {
      environment = "dev"
      node-pool   = "private-nodes"
    }
    
    # Taints for dedicated workloads if needed
    # taint {
    #   key    = "dedicated"
    #   value  = "private"
    #   effect = "NO_SCHEDULE"
    # }
  }
  
  # Node management
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  
  # Upgrade settings
  upgrade_settings {
    max_surge       = 1
    max_unavailable = 0
  }
}