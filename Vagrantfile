# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "boxcutter/ubuntu1604"

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
    rsync__args: ["-avtzL"],
    rsync__exclude: [".git/"]

  # Download wandbox-builder
  config.vm.provision :shell, privileged:true, inline: <<-SHELL
    apt-get update
    apt-get install -y git
    if ! [[ -d /root/src/wandbox-builder ]]; then
      git clone --depth 1 \
        https://github.com/melpon/wandbox-builder.git \
        /root/src/wandbox-builder
    fi
    cp /vagrant/docker-exec.sh /root/src/wandbox-builder/build/docker-exec.sh
    chmod +x /root/src/wandbox-builder/build/docker-exec.sh
  SHELL

  # Install wandbox into wandbox-builder/wandbox
  config.vm.provision :docker
  config.vm.provision :shell, privileged:true, path:"./install_wandbox.sh"
  config.vm.provision :shell, privileged:true, path:"./start_wandbox.sh"
end
