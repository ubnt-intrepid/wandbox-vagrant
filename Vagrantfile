# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "fedora/25-cloud-base"
  config.vm.box_check_update = false
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end
  config.vm.provider :virtualbox do |vb|
    vb.memory = 4096
    vb.cpus = 2
  end
  config.vm.network :forwarded_port, host:"3500", guest:"3500"
  config.vm.synced_folder ".", "/vagrant",
    type: "rsync",
    rsync__args: ["-avtzL", "--delete"],
    rsync__exclude: [".git/"]

  config.vm.provision :docker
  config.vm.provision :shell, privileged: true, path: "./provision.sh"
end
