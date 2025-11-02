# Variables for compute module

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "zone" {
  description = "The GCP zone for the VM"
  type        = string
}

variable "management_subnet" {
  description = "Management subnet resource"
  type = object({
    id      = string
    network = string
  })
}

variable "gke_service_account" {
  description = "Email of the GKE service account"
  type        = string
}

variable "vm_machine_type" {
  description = "Machine type for the management VM"
  type        = string
  default     = "e2-micro"
}