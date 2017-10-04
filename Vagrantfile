# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = {
    'cephaio'  => [1, 219],
}

Vagrant.configure("2") do |config|
    
  # Virtualbox
  config.vm.box = "velocity42/xenial64"
  config.vm.synced_folder ".", "/vagrant", type: "nfs"

  # VMware Fusion / Workstation
  config.vm.provider :vmware_fusion or config.vm.provider :vmware_workstation do |vmware, override|
    override.vm.box = "bunchc/trusty-x64"
    if Vagrant::Util::Platform.windows? 
      override.vm.synced_folder ".", "/vagrant", type: "smb"
    else
      override.vm.synced_folder ".", "/vagrant", type: "nfs"
    end

    # Fusion Performance Hacks
    vmware.vmx["logging"] = "FALSE"
    vmware.vmx["MemTrimRate"] = "0"
    vmware.vmx["MemAllowAutoScaleDown"] = "FALSE"
    vmware.vmx["mainMem.backing"] = "swap"
    vmware.vmx["sched.mem.pshare.enable"] = "FALSE"
    vmware.vmx["snapshot.disabled"] = "TRUE"
    vmware.vmx["isolation.tools.unity.disable"] = "TRUE"
    vmware.vmx["unity.allowCompostingInGuest"] = "FALSE"
    vmware.vmx["unity.enableLaunchMenu"] = "FALSE"
    vmware.vmx["unity.showBadges"] = "FALSE"
    vmware.vmx["unity.showBorders"] = "FALSE"
    vmware.vmx["unity.wasCapable"] = "FALSE"
    vmware.vmx["vhv.enable"] = "TRUE"
  end

  #Default is 2200..something, but port 2200 is used by forescout NAC agent.
  config.vm.usable_port_range= 2800..2900 

  nodes.each do |prefix, (count, ip_start)|
    count.times do |i|
      if prefix == "compute"
        hostname = "%s-%02d" % [prefix, (i+1)]
      else
        hostname = "%s" % [prefix, (i+1)]
      end

      config.vm.define "#{hostname}" do |box|
        box.vm.hostname = "#{hostname}.cook.book"
        box.vm.network :private_network, ip: "172.16.0.#{ip_start+i}", :netmask => "255.255.0.0"
        #box.vm.network :private_network, ip: "10.10.0.#{ip_start+i}", :netmask => "255.255.255.0" 
      	#box.vm.network :private_network, ip: "192.168.100.#{ip_start+i}", :netmask => "255.255.255.0" 

        # If using Fusion or Workstation
        box.vm.provider :vmware_fusion or box.vm.provider :vmware_workstation do |v|
          v.vmx["memsize"] = 4096
        end

        # Otherwise using VirtualBox
        box.vm.provider :virtualbox do |vbox|
 
          # Defaults
          vbox.customize ["modifyvm", :id, "--memory", 4096]
          vbox.customize ["modifyvm", :id, "--cpus", 1]


          dir = "#{ENV['HOME']}/vagrant-additional-disk"

          unless File.directory?( dir )
              Dir.mkdir dir
          end

          (0..2).each do |d|
             file_to_disk = "#{dir}/#{hostname}-#{d}.vmdk"
             unless File.exists?( file_to_disk )
                vbox.customize ['createhd', '--filename', file_to_disk, '--size', 20 * 1024 ]
             end
          end
          vbox.customize [ "storageattach", :id, "--storagectl", "IDE Controller", "--port", 0, "--device", 1, "--type", "hdd", "--medium", "#{dir}/#{hostname}-0.vmdk" ]
          vbox.customize [ "storageattach", :id, "--storagectl", "IDE Controller", "--port", 1, "--device", 0, "--type", "hdd", "--medium", "#{dir}/#{hostname}-1.vmdk" ]
          vbox.customize [ "storageattach", :id, "--storagectl", "IDE Controller", "--port", 1, "--device", 1, "--type", "hdd", "--medium", "#{dir}/#{hostname}-2.vmdk" ]

          # Things will fail if running Windows + VirtualBox without vbguest
          if Vagrant::Util::Platform.windows?
            unless Vagrant.has_plugin?("vagrant-vbguest") 
              raise 'Please install vagrant-vbguest. Running this environment under Windows will fail otherwise. Install with: vagrant plugin install vagrant-vbguest'
            end 
          end
          
          box.vm.provision :shell, :path => "#{prefix}.sh"

        end
      end
    end
  end
end
