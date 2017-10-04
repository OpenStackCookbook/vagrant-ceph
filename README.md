# vagrant-ceph
Vagrant Ceph environment that can be used to bolt onto [vagrant-openstack](https://github.com/OpenStackCookbook/vagrant-openstack)
Contributors:
- Kevin Jackson (@itarchitectkev)

# View the demo!
[![Vagrant Up Demo](https://asciinema.org/a/sPAcxfGUSAYsDJy9LTXGZoLR1.png)](https://asciinema.org/a/sPAcxfGUSAYsDJy9LTXGZoLR1)

# Requirements
- Vagrant (recommended 1.8+)
- Vagrant plugins - [Installation instructions](https://www.vagrantup.com/docs/plugins/usage.html)
  - [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager)  
  - [vagrant-triggers](https://github.com/emyl/vagrant-triggers)
- VirtualBox 4.3+ (Tested on VirtualBox 5.1)
- Git (to check out this environment)
- NFSD enabled on Mac and Linux environments to allow guest /vagrant access

# Instructions
```
git clone https://github.com/OpenStackCookbook/vagrant-ceph.git
cd vagrant-ceph
vagrant up --provider=virtualbox
```

Time to deploy: 5 mins

```
vagrant ssh cephaio
sudo -i
ceph -s
ceph df
```

# Environment
Deploys 1 server

cephaio (1vCPU, 4Gb Ram)<br>

# Networking
eth0 - nat (used by VMware/VirtualBox)<br>
eth1 - br-mgmt (Container) 172.29.236.0/24<br>
eth2 - br-vlan (Neutron VLAN network) 0.0.0.0/0<br>
eth3 - host / Ceph 192.168.100.0/24<br>
eth4 - br-vxlan (Neutron VXLAN Tunnel network) 172.29.240.0/24<br>

Note: check your VirtualBox/Fusion/Workstation networking and remove any conflicts.<br>
Any amendments are done in the file called Vagrantfile:<br>

```
box.vm.network :private_network, ip: "172.29.236.#{ip_start+i}", :netmask => "255.255.255.0"
box.vm.network :private_network, ip: "10.10.0.#{ip_start+i}", :netmask => "255.255.255.0"
box.vm.network :private_network, ip: "192.168.100.#{ip_start+i}", :netmask => "255.255.255.0"
box.vm.network :private_network, ip: "172.29.240.#{ip_start+i}", :netmask => "255.255.255.0
```
