#!/bin/sh

# from https://github.com/rancher/quickstart
# cloud-config is at /k3os/system/config.yaml
# dns config is at   /var/lib/rancher/k3s/server/manifests/coredns.yaml
# logs are at        /var/log/k3s-service.log
# kube.config is at  /etc/rancher/k3s/k3s.yaml

k3s_token=${1:-default-token}
k3s_server_ip=${2:-169.254.101.101}

echo "configuring k3os-server with ip ${k3s_server_ip} and token ${k3s_token}"

mkdir -p /mnt
mount /dev/sda1 /mnt
cat <<EOF > /mnt/k3os/system/config.yaml
run_cmd:
  # Duplicate rancher as vagrant user to let ssh the system with vagrant login
  - "sudo sed -e '/^rancher/p' -e 's/^rancher/vagrant/' -i /etc/passwd"
  # Set ip of internal interface
  - "sudo ifconfig eth1 ${k3s_server_ip}"
ssh_authorized_keys:
  # Vagrant key, from https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub
  - ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
hostname: k3os-server
k3os:
  k3s_args:
    - server
#    - "-v=1"
    - "--token=${k3s_token}"
    - "--bind-address=${k3s_server_ip}"
    - "--advertise-address=${k3s_server_ip}"
    - "--flannel-backend=ipsec"
    - "--flannel-iface=eth1"
    - "--node-ip=${k3s_server_ip}"
    - "--node-external-ip=${k3s_server_ip}"
EOF

reboot
