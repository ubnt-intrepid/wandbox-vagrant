#!/bin/bash

set -eu
set +x

declare -a targets=(
  "go-head"
  # "ocaml-head"
  "pony-head"
)

targets+=(cattleshed kennel)

build_or_pull() {
  docker pull "melpon/wandbox:$target" || (
    cd "$WANDBOX_BUILDER/build" && ./docker-build.sh "$target"
  )
}

do_install() {
  (cd "$WANDBOX_BUILDER/build"; ./docker-exec.sh "$target" ./install.sh)
}

# Disable SELinux
which setenforce > /dev/null && setenforce 0 || true

if ! [[ -f $HOME/.wandbox_targets_built ]]; then
  for target in ${targets[@]}; do
    echo >&2 "Installing target '$target'..."
    # Build/Pull docker images
    build_or_pull "$target"
    # Install compilers & Wandbox binaries
    do_install "$target"
  done

  echo >&2 "Updating cattleshed configuration..."
  mkdir -p $WANDBOX_BUILDER/wandbox/cattleshed-conf
  cd $WANDBOX_BUILDER/cattleshed-conf
  ./update.sh

  touch $HOME/.wandbox_targets_built
fi

if ! [[ -f $HOME/.wandbox_built ]]; then
  echo >&2 "Building Docker image for Wandbox service..."
  docker build -t wandbox /vagrant/wandbox

  touch $HOME/.wandbox_built
fi
