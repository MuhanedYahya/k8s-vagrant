## Provisioning the Kubernetes cluster
### Bring up the cluster
For VirtualBox environment
```
$ vagrant up
```
For KVM/Libvirt environment
```
$ vagrant up --provider libvirt
```
### Copy the kubeconfig file from kmaster
Password for root user is _kubeadmin_
```
$ mkdir ~/.kube
$ scp root@192.168.1.100:/etc/kubernetes/admin.conf ~/.kube/config
```
### Destroy the cluster
```
$ vagrant destroy -f
```


### install cilium & modify clusterPoolIPv4PodCIDRList to match your pod cidr

```
helm install cilium cilium/cilium --version 1.15.6 \
  --namespace kube-system --set ipam.operator.clusterPoolIPv4PodCIDRList="10.244.0.0/16"
```

### install argocd 
```
kubectl create ns argocd
```
```
helm install argocd argo/argo-cd --namespace argocd
```


## Deploying Add Ons
### Deploy dynamic nfs volume provisioning
```
$ cd kubernetes/vagrant-provisioning/misc/nfs-subdir-external-provisioner
$ cat setup_nfs | vagrant ssh kmaster
$ cat setup_nfs | vagrant ssh kworker1
$ cat setup_nfs | vagrant ssh kworker2
$ kubectl create -f 01-setup-nfs-provisioner.yaml

###### for testing
$ kubectl create -f 02-test-claim.yaml
$ kubectl delete -f 02-test-claim.yaml
```
### Deploy metalLB load balancing
```
$ cd kubernetes/vagrant-provisioning/misc/metallb
$ kubectl create -f 01_metallb.yaml

###### wait for 10 seconds or so for the pods to run
$ kubectl create -f 02_metallb-config.yaml

###### for testing
$ kubectl create -f 03_test-load-balancer.yaml
$ kubectl delete -f 03_test-load-balancer.yaml
```
