#!/bin/bash

declare -a targets=(
  "go-head"
  "ocaml-head"
  "pony-head"
)

targets+=(cattleshed kennel)

build_or_pull() {
  docker pull "melpon/wandbox:$target" || (
    cd /root/src/wandbox-builder/build &&
    ./docker-build.sh "$target"
  )
}

do_install() {
  (
    cd /root/src/wandbox-builder/build &&
    ./docker-exec.sh "$target" ./install.sh
  )
}

set -e
set +x

# Disable SELinux
which setenforce > /dev/null && setenforce 0 || true

if ! [[ -f $HOME/.wandbox_targets_installed ]]; then
  for target in ${targets[@]}; do
    echo >&2 "Installing target '$target'..."
    # Build/Pull docker images
    build_or_pull "$target"
    # Install compilers & Wandbox binaries
    do_install "$target"
  done

  echo >&2 "Updating cattleshed configuration..."
  mkdir -p /root/src/wandbox-builder/wandbox/cattleshed-conf
  cd /root/src/wandbox-builder/cattleshed-conf
  ./update.sh

  touch $HOME/.wandbox_targets_installed
fi

if ! [[ -f $HOME/.wandbox_installed ]]; then
  echo >&2 "Building Docker image for Wandbox service..."
  docker build -t wandbox /vagrant/wandbox
fi
