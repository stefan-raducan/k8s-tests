# ArgoCD Applications

This directory contains all application manifests managed by ArgoCD following GitOps principles.

## Directory Structure

```
argocd/
├── base/                              # Shared configurations
│   └── namespace.yaml                 # Common namespace definition
├── apps/                              # Individual applications
│   └── random-api/
│       ├── base/                      # Base manifests (common to all envs)
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── keda-scaledobject.yaml
│       │   ├── application.yaml       # Base Application CRD
│       │   └── kustomization.yaml
│       └── overlays/                  # Environment-specific configs
│           ├── dev/
│           │   └── kustomization.yaml # Dev patches (lower resources)
│           └── prod/
│               └── kustomization.yaml # Prod patches (higher resources)
├── envs/                              # Environment Application Generators
│   ├── dev/
│   │   └── kustomization.yaml         # Generates dev Application CRD
│   └── prod/
│       └── kustomization.yaml         # Generates prod Application CRD
└── bootstrap/                         # Bootstrap configurations
    ├── app-of-apps-dev.yaml           # Dev environment bootstrap
    └── app-of-apps-prod.yaml          # Prod environment bootstrap
```

## Adding a New Application

1. Create a new directory structure under `apps/your-app-name/`:
   ```
   apps/your-app-name/
   ├── base/
   │   ├── deployment.yaml
   │   ├── service.yaml
   │   ├── application.yaml
   │   └── kustomization.yaml
   └── overlays/
       ├── dev/
       │   └── kustomization.yaml
       └── prod/
           └── kustomization.yaml
   ```
2. Define base manifests in `base/`
3. Create environment-specific patches in `overlays/dev/` and `overlays/prod/`
4. Add the application to `envs/dev/kustomization.yaml` and `envs/prod/kustomization.yaml`
5. Push to Git - the app-of-apps will automatically deploy them!

## Deployment

### App of Apps Pattern (Recommended)

Deploy the "app-of-apps" to automatically manage all applications:

```bash
kubectl apply -f argocd/bootstrap/app-of-apps-dev.yaml
```

This single command will:
1. Create the `app-of-apps` Application in ArgoCD
2. ArgoCD will monitor `argocd/envs/dev` folder in your Git repo
3. Automatically create/sync all Application CRDs found in that folder
4. Any new apps you add to `argocd/envs/dev` will be automatically deployed
5. Any apps you remove from Git will be automatically deleted (due to `prune: true`)

### Manual Deployment (Alternative)

If you prefer to manage apps individually:

```bash
kubectl apply -f argocd-apps/argocd/random-api.yaml
```

### Verify Deployment

Check ArgoCD applications:

```bash
kubectl get applications -n argocd
```

Or view in the ArgoCD UI.

### Port Forward
If you don't want to use cloudflared to access argocd, you can use port forward:
```bash
kubectl port-forward svc/argo-cd-argocd-server -n argocd 8080:443
```
