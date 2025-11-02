# Variables for networking module

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for regional resources"
  type        = string
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