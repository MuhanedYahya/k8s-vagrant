#!/bin/bash

echo "[TASK 1] Pull required containers"
kubeadm config images pull >/dev/null

echo "[TASK 2] Initialize Kubernetes Cluster"
# 10.0.0.0/8 is the default pod cidir of cilium
kubeadm init --apiserver-advertise-address=192.168.1.100 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

# echo "[TASK 3] Deploy Calico network"
# kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/tigera-operator.yaml >/dev/null
# kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/custom-resources.yaml >/dev/null

echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh
