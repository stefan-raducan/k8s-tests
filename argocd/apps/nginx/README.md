# Random API - Base and Overlays Configuration

This document explains the Kustomize base and overlays structure for the random-api application.

## Structure

```
random-api/
├── base/                      # Common manifests shared across all environments
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── keda-scaledobject.yaml
│   └── kustomization.yaml
└── overlays/                  # Environment-specific configurations
    ├── dev/
    │   ├── namespace.yaml
    │   └── kustomization.yaml
    └── prod/
        ├── namespace.yaml
        └── kustomization.yaml
```

## Base Configuration

The base contains the common Kubernetes manifests that are shared across all environments:
- **Deployment**: Base configuration with 1 replica, 100m CPU, 128Mi memory
- **Service**: ClusterIP service exposing port 80
- **ScaledObject**: KEDA autoscaling with 1-10 replicas, polling every 10s

## Environment-Specific Overlays

### Dev Environment

**Resource Allocation:**
- CPU: `50m` (reduced from base 100m)
- Memory: `64Mi` (reduced from base 128Mi)
- Replicas: `1`

**KEDA Scaling:**
- Max replicas: `5` (reduced from base 10)
- Polling interval: `15s` (slower polling)

**Purpose:** Minimal resources for development and testing

### Prod Environment

**Resource Allocation:**
- CPU: `200m` (increased from base 100m)
- Memory: `256Mi` (increased from base 128Mi)
- CPU Limit: `500m`
- Memory Limit: `512Mi`
- Replicas: `3` (high availability)

**KEDA Scaling:**
- Min replicas: `3` (always maintain 3 instances)
- Max replicas: `20` (increased from base 10)
- Polling interval: `5s` (faster response to load)

**Purpose:** Production-ready with high availability and resource limits

## Deployment

Deploy using the app-of-apps pattern:

```bash
```bash
kubectl apply -f argocd/bootstrap/app-of-apps-dev.yaml
```

This will automatically deploy the dev environment. For prod:

```bash
kubectl apply -f argocd/bootstrap/app-of-apps-prod.yaml
```

## Verification

Build and view the manifests for:
- `argocd/apps/random-api/base`: Base configuration (Deployment, Service, KEDA ScaledObject)
- `argocd/apps/random-api/overlays/dev`: Dev environment configuration
- `argocd/apps/random-api/overlays/prod`: Prod environment configuration

Test scaling metrics:
```bash
kubectl run curl-test --image=curlimages/curl:latest --rm -it --restart=Never -n nginx -- curl -s http://random-api.random-api.svc.cluster.local/random\?min_nr\=-5\&max_nr\=5
```
Watch scaling:
```bash
watch -n 1 'kubectl get pods -n nginx --no-headers | wc -l'
```
