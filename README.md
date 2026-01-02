# Info
Start minikube with custom cluster ip range and pod network cidr:
```bash
minikube delete
# TODO needs debugging
minikube start --extra-config=kubeadm.pod-network-cidr=10.104.0.0/16
minikube start --service-cluster-ip-range=172.16.0.0/16 --pod-network-cidr=172.17.0.0/16
```


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
kubectl apply -f argocd/bootstrap/dev-test-cluster.yaml
```

This will automatically:
- Monitor the `argocd/envs/dev` folder in Git
- Deploy all applications defined there (currently: random-api)
- Auto-sync when you push changes to Git
- Auto-delete apps removed from Git

Verify deployment:
```bash
kubectl get applications -n argocd
```
