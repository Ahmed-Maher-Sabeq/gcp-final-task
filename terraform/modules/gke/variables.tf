# Variables for GKE module

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "restricted_subnet" {
  description = "Restricted subnet resource"
  type = object({
    id      = string
    network = string
  })
}

variable "management_subnet_cidr" {
  description = "CIDR block of the management subnet for authorized networks"
  type        = string
}

variable "gke_service_account" {
  description = "Email of the GKE service account"
  type        = string
}

variable "node_machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "node_count" {
  description = "Initial number of nodes in the node pool"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes for autoscaling"
  type        = number
  default     = 3
}