#!/bin/bash

# Build compilers and Wandbox binaries into $WANDBOX_BUILDER/wandbox/$target
#
# Usage:
# $ export WANDBOX_BUILDER=/var/src/wandbox-builder
# $ ./build_wandbox.sh

set -eu
set +x

verion_name() {
  local suffix

  local target="$1"
  local version="${2:-}"
  case $target in
  boost-head)
    local compiler="$3"
    suffix="boost-$version/$compiler"
    ;;
  boost)
    local compiler="$3"
    local compiler_version="$4"
    suffix="boost-${version}/${compiler}-${compiler_version}"
    ;;
  *-head)
    suffix="$target"
    ;;
  *)
    if [[ -n "$version" ]]; then
      suffix="$target-$version"
    else
      suffix="$target"
    fi
    ;;
  esac

  echo "${WANDBOX_BUILDER}/wandbox/$suffix"
}

# Run ./install.sh of target into Docker container.
do_install() {
  if [[ -d "$(verion_name "$@")" ]]; then
    return
  fi

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

do_install "$@"
