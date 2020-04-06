# -*- mode: ruby -*-
# vi: set ft=ruby :

# Based on https://github.com/rancher/quickstart

# Create a file called `config.json` with the following contents:

# k3os_version: 0.9.1
# k3s_token: 8aw47ft0w864ft08w64ftwa7eag8w7t
# linked_clones: true
# net:
#   network_type: private_network
# server:
#   cpus: 1
#   memory: 2000
# node:
#   count: 3
#   cpus: 2
#   memory: 2000
# ip:
#   server: 172.22.101.101
#   node: 172.22.101.111 # ip of first node

require 'ipaddr'
require 'yaml'

x = YAML.load_file('config.yaml')
puts "Config: #{x.inspect}\n\n"

Vagrant.configure(2) do |config|
  config.vbguest.auto_update = false if Vagrant.has_plugin?("vagrant-vbguest") # disable conflicting plugin

  config.vm.define "k3os-server" do |server|
      c = x.fetch('server')
      server.vm.box= "digitalism/k3os-box"
      server.vm.box_version = x.fetch('k3os_version')
      server.vm.guest = :linux
      server.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.cpus = c.fetch('cpus')
        v.linked_clone = true if Gem::Version.new(Vagrant::VERSION) >= Gem::Version.new('1.8.0') and x.fetch('linked_clones')
        v.memory = c.fetch('memory')
      end
      config.vm.synced_folder '.', '/vagrant', disabled: true
      server.vm.network x.fetch('net').fetch('network_type'), ip: x.fetch('ip').fetch('server'), auto_config: false
      server.vm.provision "shell", path: "scripts/configure_k3s_server.sh", upload_path: '/home/rancher/configure_k3s_server.sh', args: [x.fetch('k3s_token'), x.fetch('ip').fetch('server')]
  end

  node_ip_base = IPAddr.new(x.fetch('ip').fetch('node'))
  (1..x.fetch('node').fetch('count')).each do |i|
    c = x.fetch('node')
    hostname = "k3os-%d" % i
    config.vm.define hostname do |node|
      node.vm.box = "digitalism/k3os-box"
      node.vm.box_version = x.fetch('k3os_version')
      node.vm.guest = :linux
      node.vm.provider "virtualbox" do |v|
        v.cpus = c.fetch('cpus')
        v.linked_clone = true if Gem::Version.new(Vagrant::VERSION) >= Gem::Version.new('1.8.0') and x.fetch('linked_clones')
        v.memory = c.fetch('memory')
      end
      config.vm.synced_folder '.', '/vagrant', disabled: true
      node_ip = IPAddr.new(node_ip_base.to_i + i - 1, Socket::AF_INET).to_s 
      node.vm.network x.fetch('net').fetch('network_type'), ip: node_ip, auto_config: false
      node.vm.provision "shell", path: "scripts/configure_k3s_node.sh", upload_path: '/home/rancher/configure_k3s_node.sh', args: [x.fetch('k3s_token'), x.fetch('ip').fetch('server'), node_ip, i]
    end
  end
end
