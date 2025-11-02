# GCP Infrastructure Deployment Guide

## Prerequisites ✅ COMPLETED

1. **GCP Project Setup** ✅
   - Project ID: `it-gcp-final-task-15807`
   - Required APIs enabled

2. **Service Account Setup** ✅
   - Service account created with required permissions
   - JSON key file: `it-gcp-final-task-15807-d39827153d91.json`

3. **Terraform Setup** ✅
   - Terraform installed
   - Configuration files ready (`terraform.tfvars` created)

## Deployment Steps (Windows)

### 1. Set up Environment
```cmd
cd terraform
setup.bat
```

### 2. Initialize Terraform
```cmd
terraform init
```

### 3. Plan the Deployment
```cmd
terraform plan
```

### 4. Apply the Infrastructure
```cmd
terraform apply
```

### 5. Build and Push Application Images

After infrastructure is created, build and push the application image:

```cmd
REM Navigate to application directory
cd ..\DevOps-Challenge-Demo-Code-master

REM Configure Docker for GAR
gcloud auth configure-docker us-central1-docker.pkg.dev

REM Build the image
docker build -t us-central1-docker.pkg.dev/it-gcp-final-task-15807/gcp-infrastructure-repo/python-web-app:latest .

REM Push the image
docker push us-central1-docker.pkg.dev/it-gcp-final-task-15807/gcp-infrastructure-repo/python-web-app:latest
```

### 6. Deploy Kubernetes Applications

Connect to the GKE cluster and deploy the applications:

```cmd
REM Get cluster credentials
gcloud container clusters get-credentials private-gke-cluster --region us-central1 --project it-gcp-final-task-15807

REM Apply the manifests (image URL already updated)
kubectl apply -f kubernetes/redis-statefulset.yaml
kubectl apply -f kubernetes/app-deployment.yaml
kubectl apply -f kubernetes/ingress.yaml
```

### 6. Access the Application

Wait for the load balancer to be provisioned (5-10 minutes), then get the external IP:

```bash
kubectl get ingress python-web-app-ingress
```

## Verification

1. **Check Infrastructure**
   ```bash
   terraform output
   ```

2. **Check Kubernetes Resources**
   ```bash
   kubectl get all
   kubectl get ingress
   ```

3. **Test Application**
   - Access the external IP from the ingress
   - Verify the counter increments on page refresh

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

## Troubleshooting

1. **GKE Access Issues**
   - Ensure you're connecting from the management VM or have proper authorized networks configured

2. **Image Pull Issues**
   - Verify GAR permissions for the GKE service account
   - Check image URL format in deployment manifest

3. **Load Balancer Issues**
   - Check firewall rules allow health checks
   - Verify backend service configuration