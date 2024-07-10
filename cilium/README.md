# install using cli
helm install cilium cilium/cilium --version 1.15.6 \             
  --namespace kube-system --set ipam.operator.clusterPoolIPv4PodCIDRList="10.244.0.0/16"