# Input variables for the GCP Infrastructure Deployment

variable "project_id" {
  description = "The GCP project ID where resources will be created"
  type        = string
  default     = "it-gcp-final-task-15807"
  
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID must not be empty."
  }
}

variable "region" {
  description = "The GCP region for regional resources"
  type        = string
  default     = "us-central1"
  
  validation {
    condition = can(regex("^[a-z]+-[a-z]+[0-9]$", var.region))
    error_message = "Region must be a valid GCP region format (e.g., us-central1)."
  }
}

variable "zone" {
  description = "The GCP zone for zonal resources"
  type        = string
  default     = "us-central1-a"
  
  validation {
    condition = can(regex("^[a-z]+-[a-z]+[0-9]-[a-z]$", var.zone))
    error_message = "Zone must be a valid GCP zone format (e.g., us-central1-a)."
  }
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "private-gke-cluster"
  
  validation {
    condition     = can(regex("^[a-z]([a-z0-9-]*[a-z0-9])?$", var.cluster_name))
    error_message = "Cluster name must start with a letter, contain only lowercase letters, numbers, and hyphens, and end with a letter or number."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "management_subnet_cidr" {
  description = "CIDR block for the management subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "restricted_subnet_cidr" {
  description = "CIDR block for the restricted subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "vm_machine_type" {
  description = "Machine type for the management VM"
  type        = string
  default     = "e2-micro"
}

variable "gke_node_machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "gke_node_count" {
  description = "Initial number of nodes in the GKE node pool"
  type        = number
  default     = 1
  
  validation {
    condition     = var.gke_node_count >= 1 && var.gke_node_count <= 10
    error_message = "Node count must be between 1 and 10."
  }
}

variable "gke_max_node_count" {
  description = "Maximum number of nodes in the GKE node pool for autoscaling"
  type        = number
  default     = 3
  
  validation {
    condition     = var.gke_max_node_count >= 1 && var.gke_max_node_count <= 20
    error_message = "Max node count must be between 1 and 20."
  }
}