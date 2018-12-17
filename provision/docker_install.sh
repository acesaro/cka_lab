#!/bin/bash
set -xe

yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

yum update --security -y

yum-config-manager \
  --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo

yum -y install docker-ce-18.06.1.ce
systemctl enable docker
systemctl start docker
