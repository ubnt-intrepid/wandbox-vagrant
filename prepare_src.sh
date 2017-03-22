#!/bin/bash

set -eu
set +x

if ! which git > /dev/null; then
  apt-get update
  apt-get install -y git
fi
if ! [[ -d "$WANDBOX_BUILDER" ]]; then
  git clone --depth 1 https://github.com/melpon/wandbox-builder.git "$WANDBOX_BUILDER"
fi

install -m 755 /vagrant/docker-exec.sh "$WANDBOX_BUILDER/build/docker-exec.sh"
install -m 755 /vagrant/compilers.py   "$WANDBOX_BUILDER/cattleshed-conf/compilers.py"

