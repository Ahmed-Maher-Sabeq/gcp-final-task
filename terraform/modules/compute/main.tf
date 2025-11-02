# Compute Module - Management VM for GKE cluster management

# Management VM with private IP only
resource "google_compute_instance" "management_vm" {
  name         = "management-vm"
  machine_type = var.vm_machine_type
  zone         = var.zone
  project      = var.project_id
  
  description = "Private VM for managing GKE cluster with kubectl access"
  
  # Boot disk configuration
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
      type  = "pd-standard"
    }
  }
  
  # Network interface - private IP only, no external IP
  network_interface {
    network    = var.management_subnet.network
    subnetwork = var.management_subnet.id
    
    # No access_config block means no external IP
  }
  
  # Service account for VM
  service_account {
    email  = var.gke_service_account
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
  
  # Network tags for firewall rules
  tags = ["management-vm"]
  
  # Startup script to install kubectl and gcloud CLI
  metadata_startup_script = <<-EOF
    #!/bin/bash
    
    # Update system
    apt-get update
    apt-get install -y apt-transport-https ca-certificates gnupg curl
    
    # Install Google Cloud SDK
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    apt-get update
    apt-get install -y google-cloud-cli google-cloud-cli-gke-gcloud-auth-plugin
    
    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    
    # Install Docker for building images
    apt-get install -y docker.io
    systemctl enable docker
    systemctl start docker
    usermod -aG docker ubuntu
    
    # Configure gcloud for the project
    gcloud config set project ${var.project_id}
    gcloud config set compute/region ${var.region}
    gcloud config set compute/zone ${var.zone}
    
    # Configure Docker to use gcloud as credential helper for GAR
    gcloud auth configure-docker ${var.region}-docker.pkg.dev
    
    echo "Management VM setup completed" > /var/log/startup-complete.log
  EOF
  
  # Metadata for SSH access
  metadata = {
    enable-oslogin = "TRUE"
  }
  
  # Allow stopping for updates
  allow_stopping_for_update = true
}