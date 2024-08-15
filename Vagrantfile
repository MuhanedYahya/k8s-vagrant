# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

VAGRANT_BOX         = "bento/debian-12"
VAGRANT_BOX_VERSION = "202404.23.0"
CPUS_MASTER_NODE    = 2
MEMORY_MASTER_NODE  = 2048
WIFI_NETWORK_INTERFACE = "wlp4s0"
ETH_NETWORK_INTERFACE = ""
MASTER_IP = "192.168.1.170"
WORKER_BASE_IP = 170

# Worker Pool Configurations
WORKER_POOLS = [
  { name_prefix: "worker", count: 1, cpus: 1, memory: 1048 },  # Pool 1
  { name_prefix: "small-pool", count: 0, cpus: 2, memory: 2096 },  # Pool 2
  { name_prefix: "large-pool", count: 0, cpus: 1, memory: 1192 }   # Pool 3
]

Vagrant.configure(2) do |config|

  def add_network_interface(config, interface, ip)
    if interface && !interface.empty?
      config.vm.network "public_network", bridge: interface, ip: ip
    end
  end

  config.vm.provision "shell", path: "bootstrap.sh"

  # Kubernetes Master Server
  config.vm.define "master" do |node|
  
    node.vm.box               = VAGRANT_BOX
    node.vm.box_check_update  = false
    node.vm.box_version       = VAGRANT_BOX_VERSION
    node.vm.hostname          = "master"
    add_network_interface(node, ETH_NETWORK_INTERFACE, MASTER_IP)
    add_network_interface(node, WIFI_NETWORK_INTERFACE, MASTER_IP)

    node.vm.provider :virtualbox do |v|
      v.name    = "master"
      v.memory  = MEMORY_MASTER_NODE
      v.cpus    = CPUS_MASTER_NODE
    end

    node.vm.provider :libvirt do |v|
      v.memory  = MEMORY_MASTER_NODE
      v.nested  = true
      v.cpus    = CPUS_MASTER_NODE
    end

    node.vm.provider :hyperv do |v|
      v.vmname    = "master"
      v.memory  = MEMORY_MASTER_NODE
      v.cpus    = CPUS_MASTER_NODE
      v.enable_virtualization_extensions = true
    end

    node.vm.provision "shell", path: "bootstrap_master.sh"

  end

  # Kubernetes Worker Nodes for Each Pool
  ip_counter = WORKER_BASE_IP

  WORKER_POOLS.each_with_index do |pool, pool_index|
    (1..pool[:count]).each do |i|
      node_name = "#{pool[:name_prefix]}-#{i}"
      config.vm.define node_name do |node|

        node.vm.box               = VAGRANT_BOX
        node.vm.box_check_update  = false
        node.vm.box_version       = VAGRANT_BOX_VERSION
        node.vm.hostname          = node_name

        ip_counter += 1
        ip = "192.168.1.#{ip_counter}"

        add_network_interface(node, ETH_NETWORK_INTERFACE, ip)
        add_network_interface(node, WIFI_NETWORK_INTERFACE, ip)

        node.vm.provider :virtualbox do |v|
          v.name    = node_name
          v.memory  = pool[:memory]
          v.cpus    = pool[:cpus]
        end

        node.vm.provider :libvirt do |v|
          v.memory  = pool[:memory]
          v.nested  = true
          v.cpus    = pool[:cpus]
        end

        node.vm.provider :hyperv do |v|
          v.vmname    = node_name
          v.memory  = pool[:memory]
          v.cpus    = pool[:cpus]
          v.enable_virtualization_extensions = true
        end

        node.vm.provision "shell", path: "bootstrap_worker.sh"

      end
    end
  end

end
