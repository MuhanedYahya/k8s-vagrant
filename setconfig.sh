#!/bin/bash

ssh-keygen -f "/home/muhaned/.ssh/known_hosts" -R "192.168.1.180"

scp root@192.168.1.180:/etc/kubernetes/admin.conf ~/.kube/config
