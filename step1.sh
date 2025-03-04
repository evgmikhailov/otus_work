#!/bin/bash
# install distr
sudo apt install ansible sshpass nfs-common
# create folder to nfs & connect this
sudo mkdir -p /mnt/nfs
sudo mount -t nfs 192.168.1.77:/vol01 /mnt/nfs
# make user ansible & add sudo groups
sudo adduser ansible
sudo usermod -aG sudo ansible
# create ssh key for users
cd /home/user01/.ssh
ssh-keygen -t ed25519
ssh-keygen -t ed25519 -C "ansible" -f ~/.ssh/ansible
# map git to ansible station
cd /home/user01
git clone https://github.com/evgmikhailov/otus_work.git
# start playbook 
cd /home/user01/otus_work
ansible-playbook  --become --ask-become-pass --vault-id @prompt site.yml
