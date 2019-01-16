#!/bin/bash
set -xe

sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.33.20

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

curl -o /tmp/rbac-kdd.yaml https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
curl -o /tmp/calico.yaml https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml

sed -i.bak 's|192.168.0.0/16|10.244.0.0/16|g' /tmp/calico.yaml
for i in rbac-kdd.yaml calico.yaml; do
  kubectl apply -f /tmp/${i}
done

echo 'source <(kubectl completion bash)' >> $HOME/.bashrc
