# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

VAGRANT_BOX         = "generic/ubuntu2204"
VAGRANT_BOX_VERSION = "4.2.10"
CPUS_MASTER_NODE    = 2
CPUS_WORKER_NODE    = 1
MEMORY_MASTER_NODE  = 2048
MEMORY_WORKER_NODE  = 2024
WORKER_NODES_COUNT  = 2
WIFI_NETWORK_INTERFACE = "enp3s0"
ETH_NETWORK_INTERFACE = ""
MASTER_IP = "192.168.1.100"
NODE_IP_PREFIX = "192.168.1.10" # 101 || 102 ...

Vagrant.configure(2) do |config|

  # Function to add network interface if not empty
  def add_network_interface(config, interface, ip)
    if interface && !interface.empty?
      config.vm.network "public_network", bridge: interface, ip: ip
    end
  end

  config.vm.provision "shell", path: "bootstrap.sh"

  # Kubernetes Master Server
  config.vm.define "kmaster" do |node|
  
    node.vm.box               = VAGRANT_BOX
    node.vm.box_check_update  = false
    node.vm.box_version       = VAGRANT_BOX_VERSION
    node.vm.hostname          = "kmaster"
    # Add Ethernet network interface if not empty
    add_network_interface(node, ETH_NETWORK_INTERFACE, MASTER_IP)
    # Add Wi-Fi network interface
    add_network_interface(node, WIFI_NETWORK_INTERFACE, MASTER_IP)
    

    node.vm.provider :virtualbox do |v|
      v.name    = "kmaster"
      v.memory  = MEMORY_MASTER_NODE
      v.cpus    = CPUS_MASTER_NODE
    end

    node.vm.provider :libvirt do |v|
      v.memory  = MEMORY_MASTER_NODE
      v.nested  = true
      v.cpus    = CPUS_MASTER_NODE
    end

    node.vm.provider :hyperv do |v|
      v.vmname    = "kmaster"
      v.memory  = MEMORY_MASTER_NODE
      v.cpus    = CPUS_MASTER_NODE
      v.enable_virtualization_extensions = true
    end

    node.vm.provision "shell", path: "bootstrap_kmaster.sh"

  end

  # Kubernetes Worker Nodes
  (1..WORKER_NODES_COUNT).each do |i|

    config.vm.define "kworker#{i}" do |node|

      node.vm.box               = VAGRANT_BOX
      node.vm.box_check_update  = false
      node.vm.box_version       = VAGRANT_BOX_VERSION
      node.vm.hostname          = "kworker#{i}"

      # Add Ethernet network interface if not empty
      add_network_interface(node, ETH_NETWORK_INTERFACE, "#{NODE_IP_PREFIX}#{i}")
      # Add Wi-Fi network interface
      add_network_interface(node, WIFI_NETWORK_INTERFACE, "#{NODE_IP_PREFIX}#{i}")

      node.vm.provider :virtualbox do |v|
        v.name    = "kworker#{i}"
        v.memory  = MEMORY_WORKER_NODE
        v.cpus    = CPUS_WORKER_NODE
      end

      node.vm.provider :libvirt do |v|
        v.memory  = MEMORY_WORKER_NODE
        v.nested  = true
        v.cpus    = CPUS_WORKER_NODE
      end

      node.vm.provider :hyperv do |v|
        v.vmname    = "kworker#{i}"
        v.memory  = MEMORY_WORKER_NODE
        v.cpus    = CPUS_WORKER_NODE
        v.enable_virtualization_extensions = true
      end

      node.vm.provision "shell", path: "bootstrap_kworker.sh"

    end

  end

end
