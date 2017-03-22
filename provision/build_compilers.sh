#!/bin/bash

# Build compilers and Wandbox binaries into $WANDBOX_BUILDER/wandbox
# 
# Usage:
# $ export WANDBOX_BUILDER=/var/src/wandbox-builder
# $ ./build_wandbox.sh

set -eu
set +x

# Run ./install.sh of target into Docker container.
do_install() {
  echo >&2 "Installing target '$1'..."

  # Pull image for installation, or build if not exists.
  docker pull "melpon/wandbox:$1"
  if [[ -z "$(docker images -q melpon/wandbox:$1)" ]]; then
    (cd "$WANDBOX_BUILDER/build" && ./docker-build.sh "$1")
  fi

  # Run $target/install.sh $args
  docker run --net=host --rm \
    -v $WANDBOX_BUILDER/build:/var/work \
    -v $WANDBOX_BUILDER/wandbox:/opt/wandbox \
    -w /var/work/$1 \
    "melpon/wandbox:$1" ./install.sh "${@:2}"
}

main() {
  # Install Wandbox binaries
  do_install cattleshed
  do_install kennel

  # Install compilers
  do_install clang 3.7.1
  do_install clang-head
  do_install rust 1.15.0

  # Install Boost
  do_install boost-head 1.61.0 clang-head
  do_install boost      1.61.0 clang      3.7.1
}

main "$@"