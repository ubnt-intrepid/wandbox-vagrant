# `Vagrantfile` for provisioning Wandbox service

## Usage
1. Start VM
   ```sh
   $ vagrant up [--provision]
   ```

2. Install compilers
   ```sh
   $ vagrant ssh -c "sudo env WANDBOX_BUILDER=/var/src/wandbox-builder /vagrant/provision/do_install.sh clang-head"
   ```

3. Update cattleshed-conf/compilers.default and then restart the service
   ```sh
   $ vagrant ssh -c "sudo env WANDBOX_BUILDER=/var/src/wandbox-builder /vagrant/provision/start_wandbox.sh"
   ```