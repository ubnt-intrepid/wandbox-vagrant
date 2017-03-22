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

  config.vm.provision :docker
  config.vm.provision :shell, inline: <<-SHELL
    export WANDBOX_BUILDER=/var/src/wandbox-builder
    export WANDBOX_PREFIX=/opt/wandbox

    # Disable SELinux
    which setenforce > /dev/null && setenforce 0 || true

    mkdir -p "$WANDBOX_PREFIX"

    # Download wandbox-builder
    if ! which git > /dev/null; then
      apt-get update
      apt-get install -y git
    fi
    rm -rf $WANDBOX_BUILDER
    git clone --depth 1 https://github.com/melpon/wandbox-builder.git "${WANDBOX_BUILDER}"

    ln -s "$WANDBOX_PREFIX" "$WANDBOX_BUILDER/wandbox"

    # Install binaries
    /bin/bash /vagrant/provision/install_all.sh

    # Start Wandbox service
    /bin/bash /vagrant/provision/start_wandbox.sh
  SHELL
end
