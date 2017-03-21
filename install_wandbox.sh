#!/bin/bash

set -e
set +x

if [[ -f $HOME/.wandbox_installed ]]; then
  exit 0
fi

# Disable SELinux
which setenforce > /dev/null && setenforce 0 || true

# Build docker images
# cd /root/src/wandbox-builder/build
# ./docker-build.sh go-head

# Install compilers & Wandbox binaries
cd /root/src/wandbox-builder/build
./docker-exec.sh cattleshed ./install.sh
./docker-exec.sh kennel     ./install.sh
./docker-exec.sh go-head    ./install.sh
./docker-exec.sh ocaml-head ./install.sh

# Update cattleshed.conf
cd /root/src/wandbox-builder/cattleshed-conf
mkdir -p ../wandbox/cattleshed-conf
./update.sh

touch $HOME/.wandbox_installed
