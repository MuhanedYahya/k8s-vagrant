# install using cli (optional) only if you disabled calico from master script
```
helm install cilium cilium/cilium --version 1.15.6 \             
  --namespace kube-system --values values.yaml
```

ExternalIPs enabled & NodePort enabled also clusterPoolIPv4PodCIDRList is set in values.yaml