# k3os on Vagrant

Run a [k3os](https://k3os.io) cluster on [Vagrant](https://www.vagrantup.com).

## Quick Start

Run the Vagrant box:

```
vagrant up
```

You can then login to the k3os server using `vagrant ssh k3os-server` and to node 1 using `vagrant ssh k3os-1`.

Change the number of nodes, the amount of RAM and the network configuration in `config.yaml`.

See [Vagrant Docs](https://www.vagrantup.com/docs/index.html) for more details on how to use Vagrant.

## Kube Config

To authenticate to the cluster, run `./update-kube-config.sh` to update your `~/.kube/config`.

Test connectivity to the cluster by running `kubectl get pods -A`.

If you prefer manual configuration, copy `/etc/rancher/k3s/k3s.yaml` from `k3os-server` to `~/.kube/config` and replace `127.0.0.1` with `172.22.101.101`.

## Build

Build vagrant base box using [Packer](https://www.packer.io/): 

```
packer build packer/vagrant.json
vagrant box add k3os_virtualbox.box --name k3os
```

Then, in the `Vagrantfile`, change `"digitalism/k3os-box"` to `"k3os"` and comment out the line `server.vm.box_version`.
