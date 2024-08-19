# cilium mesh
```
export CLUSTER1=cluster1-admin@cluster1; export CLUSTER2=cluster2-admin@cluster2
```
```
kind create cluster --config cluster1.yaml
kind create cluster --config cluster2.yaml
```
```
kubectl cluster-info --context cluster1
kubectl cluster-info --context cluster2
```
```
cilium install --set cluster.name=cluster1 --set cluster.id=1 --context $CLUSTER1 --set ipam.operator.clusterPoolIPv4PodCIDRList=10.1.0.0/16

cilium install --set cluster.name=cluster2 --set cluster.id=2 --context $CLUSTER2 --set ipam.operator.clusterPoolIPv4PodCIDRList=10.2.0.0/16
```


```
cilium clustermesh enable --context $CLUSTER1 --service-type NodePort
cilium clustermesh enable --context $CLUSTER2 --service-type NodePort

cilium clustermesh enable --context $CLUSTER1
cilium clustermesh enable --context $CLUSTER2
```

```
cilium clustermesh status --context $CLUSTER1 --wait
cilium clustermesh status --context $CLUSTER2 --wait
```

```
cilium clustermesh connect --context $CLUSTER1 --destination-context $CLUSTER2
```

```
cilium connectivity test --context $CLUSTER1 --multi-cluster $CLUSTER2
```