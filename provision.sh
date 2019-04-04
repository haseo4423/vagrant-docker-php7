#!/bin/sh
setenforce 0
sed -ie 's/^SELINUX=.\+$/SELINUX=disabled/g' /etc/sysconfig/selinux

systemctl stop firewalld
systemctl disable firewalld

yum update -y
yum upgrade -y
yum install -y tree vim git chrony

timedatectl set-timezone Asia/Tokyo

sudo systemctl start chronyd
sudo systemctl enable chronyd

curl -fsSL https://get.docker.com/ | sh
# gpasswd -a vagrant docker

curl -sSL https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

systemctl enable docker
systemctl start docker

groupadd memcached35 -g 53505
useradd -u 53505 -g memcached35 -s /sbin/nologin memcached35

mkdir -p /home/vagrant/docker/sample/db/var/lib/postgresql/data
chown -R vagrant:vagrant /home/vagrant
