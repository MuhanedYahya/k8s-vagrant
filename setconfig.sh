#!/bin/bash

ssh-keygen -f "/home/muhaned/.ssh/known_hosts" -R "192.168.1.100"

scp root@192.168.1.100:/etc/kubernetes/admin.conf ~/.kube/config
