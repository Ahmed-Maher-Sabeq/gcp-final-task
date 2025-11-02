# Provider Configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }
}

# GCP Provider Configuration - Standard GCP Authentication
provider "google" {
  credentials = file("it-gcp-final-task-15807-d39827153d91.json")
  project     = "it-gcp-final-task-15807"
  region      = "us-central1"
  zone        = "us-central1-a"
  
  default_labels = {
    project     = "it-gcp-final-task-15807"
    environment = "dev"
    managed-by  = "terraform"
  }
}

provider "google-beta" {
  credentials = file("it-gcp-final-task-15807-d39827153d91.json")
  project     = "it-gcp-final-task-15807"
  region      = "us-central1"
  zone        = "us-central1-a"
  
  default_labels = {
    project     = "it-gcp-final-task-15807"
    environment = "dev"
    managed-by  = "terraform"
  }
}