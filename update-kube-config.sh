#!/bin/sh

# use this script to automatically update your ~/.kube/config

SERVER_IP=$(cat config.yaml | grep " server" | cut -d " " -f 4)
vagrant ssh k3os-server -c "cat /etc/rancher/k3s/k3s.yaml | sed -e 's/127.0.0.1/${SERVER_IP}/g'" | tail -n 19 > ~/.kube/config
echo "---"
cat ~/.kube/config
