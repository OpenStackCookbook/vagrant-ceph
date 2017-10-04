#!/bin/bash
sudo apt-get update
sudo apt-get -y install python-pip python-dev libffi-dev git software-properties-common python-software-properties
sudo add-apt-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible
git clone https://github.com/ceph/ceph-ansible
cd ceph-ansible
git checkout v2.2.9
cp /vagrant/inventory .
# sort out keys for root user
sudo ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
rm -f /vagrant/id_rsa*
sudo cp /root/.ssh/id_rsa /vagrant
sudo cp /root/.ssh/id_rsa.pub /vagrant
cat /vagrant/id_rsa.pub | sudo tee -a /root/.ssh/authorized_keys

# Write out /root/.ssh/config
echo "
BatchMode yes
CheckHostIP no
StrictHostKeyChecking no" > /root/.ssh/config
chmod 0600 /root/.ssh/config

cp site.yml.sample site.yml
cp /vagrant/all.yml group_vars/all.yml
cp /vagrant/mons.yml group_vars/mons.yml
cp /vagrant/osds.yml group_vars/osds.yml
cp group_vars/rgws.yml.sample group_vars/rgws.yml

ansible-playbook -i inventory site.yml
