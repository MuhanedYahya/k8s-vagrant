#!/bin/bash

## !IMPORTANT ##
#
## This script is tested only in the generic/ubuntu2204 Vagrant box
## If you use a different version of Ubuntu or a different Ubuntu Vagrant box test this again
#

readonly NFS_SHARE="/srv/nfs/kubedata"
readonly ALLOWED_RANGE="192.168.1.0/24"
echo "[TASK 1] apt update"
sudo apt-get update -qq >/dev/null
echo "[TASK 2] install nfs server & ufw"
sudo apt install nfs-kernel-server ufw -y
echo "[TASK 3] creating nfs exports"
sudo mkdir -p $NFS_SHARE
sudo chown nobody:nogroup $NFS_SHARE
sudo echo "$NFS_SHARE $ALLOWED_RANGE(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
sudo ufw allow ssh
sudo ufw allow from $ALLOWED_RANGE to any port nfs
sudo ufw --force enable
