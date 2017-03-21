#!/bin/bash

set -e
set +x

# Disable SELinux
which setenforce > /dev/null && setenforce 0 || true

if ! [[ -f $HOME/.wandbox_installed ]]; then
  # Build docker images
  # cd /root/src/wandbox-builder/build
  # ./docker-build.sh go-head

  # Install compilers & Wandbox binaries
  cd /root/src/wandbox-builder/build
  ./docker-exec.sh cattleshed ./install.sh
  ./docker-exec.sh kennel     ./install.sh
  ./docker-exec.sh go-head    ./install.sh
  ./docker-exec.sh ocaml-head ./install.sh
fi

# Update cattleshed.conf
cd /root/src/wandbox-builder/cattleshed-conf
mkdir -p ../wandbox/cattleshed-conf
./update.sh

touch $HOME/.wandbox_installed
