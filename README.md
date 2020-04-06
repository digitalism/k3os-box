# k3OS on Vagrant

Run a [k3os](https://k3os.io) cluster on [Vagrant](https://www.vagrantup.com).

## Quick Start

Run the Vagrant box:

```
vagrant up
```

You can then login to the k3os server using `vagrant ssh k3os-server` and to node 1 using `vagrant ssh k3os-1`.

Change the number of nodes, the amount of RAM and the network configuration in `config.yaml`.

See [Vagrant Docs](https://www.vagrantup.com/docs/index.html) for more details on how to use Vagrant.

## Build

Build vagrant box image using [Packer](https://www.packer.io/): 

```
packer build vagrant.json
vagrant box add k3os_virtualbox.box --name k3os
```

Then, in the `Vagrantfile`, change `"digitalism/k3os-box"` to `"k3os"` and comment out the line `server.vm.box_version`.
