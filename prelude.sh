#!/bin/bash

set -e
set +x

if ! which git > /dev/null; then
  apt-get update
  apt-get install -y git
fi

if ! [[ -d /root/src/wandbox-builder ]]; then
  git clone --depth 1 \
    https://github.com/melpon/wandbox-builder.git \
    /root/src/wandbox-builder
fi

cp /vagrant/docker-exec.sh /root/src/wandbox-builder/build/docker-exec.sh
chmod +x /root/src/wandbox-builder/build/docker-exec.sh
