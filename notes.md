build multi arch
```
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t sunna.nbg:5050/xmrig:latest --output=type=registry,registry.insecure=true .
```