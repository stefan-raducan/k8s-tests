# cloudflared initial manual setup
```bash
kubectl create namespace cloudflared
kubectl create secret generic tunnel-credentials \
  --from-literal=token='TOKEN' \
  -n cloudflared
```
