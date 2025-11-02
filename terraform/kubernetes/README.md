# Kubernetes Manifests

This directory contains Kubernetes deployment manifests for the Python application and Redis.

## Files:
- redis-statefulset.yaml - Redis StatefulSet with persistent storage
- app-deployment.yaml - Python application deployment
- ingress.yaml - Ingress configuration for external access

## Deployment:
Apply these manifests after the GKE cluster is created:
```bash
kubectl apply -f redis-statefulset.yaml
kubectl apply -f app-deployment.yaml
kubectl apply -f ingress.yaml
```