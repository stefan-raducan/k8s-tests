# Info

## ArgoCD
To access ArgoCD when using minikube, use the following command:

```bash
# starts a tunnel
minikube service argo-cd-argocd-server -n argocd --url
```

get initial argocd password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
login on url

reset password:
```bash
kubectl -n argocd patch secret argocd-initial-admin-secret --type merge -p '{"data":{"admin.password":""}}'
kubectl -n argocd patch secret argocd-initial-admin-secret --type merge -p '{"data":{"admin.passwordMtime":""}}'
```

## GitOps Deployment

Deploy all applications using the app-of-apps pattern:

```bash
kubectl apply -f argocd-apps/argocd/app-of-apps.yaml
```

This will automatically:
- Monitor the `argocd-apps/argocd/` folder in Git
- Deploy all applications defined there (currently: random-api)
- Auto-sync when you push changes to Git
- Auto-delete apps removed from Git

Verify deployment:
```bash
kubectl get applications -n argocd
```
