# cloudflared initial manual setup
If you haven't created the secret yet, run the following:
```bash
kubectl create secret generic tunnel-credentials \
  --from-literal=token='TOKEN' \
  -n cloudflared
```
# TODO
Create the secret in terraform using an aws secrets manager secret as source for the value
