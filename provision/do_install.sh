#!/bin/bash

# Build compilers and Wandbox binaries into $WANDBOX_BUILDER/wandbox/$target
#
# Usage:
# $ export WANDBOX_BUILDER=/var/src/wandbox-builder
# $ ./build_wandbox.sh

set -eu
set +x

# Run ./install.sh of target into Docker container.
do_install() {
  echo "[debug] args: $@"

  local suffix="$1"
  local target="$2"
  
  if [[ -d "${WANDBOX_BUILDER}/wandbox/$suffix" ]]; then
    return
  fi

  echo >&2 "Installing target '$target'..."

  # Pull image for installation, or build if not exists.
  docker pull "melpon/wandbox:$target"
  if [[ -z "$(docker images -q melpon/wandbox:$target)" ]]; then
    (cd "$WANDBOX_BUILDER/build" && ./docker-build.sh "$target")
  fi

  # Run $target/install.sh $args
  docker run --net=host --rm \
    -v $WANDBOX_BUILDER/build:/var/work \
    -v $WANDBOX_BUILDER/wandbox:/opt/wandbox \
    -w "/var/work/$target" \
    "melpon/wandbox:$target" ./install.sh "${@:3}"
}


main_boost() {
  local compiler="$(echo "$2" | cut -d- -f1)"
  local compiler_version="$(echo "$2" | cut -d- -f2)"

  if [[ "$compiler_version" = "head" ]]; then
    do_install "boost-$1/$2" boost-head "$1" "${compiler}-head"
  else
    do_install "boost-$1/$2" boost "$1" "${compiler}" "${compiler_version}"
  fi
}

main() {
  local compiler compiler_version
  case "$1" in
    boost-*)
      main_boost "$(echo "$1" | cut -d- -f2)" "$2"
    ;;
    *-*)
      compiler="$(echo "$1" | cut -d- -f1)"
      compiler_version="$(echo "$1" | cut -d- -f2)"
      if [[ "$compiler_version" = "head" ]]; then
        do_install "$1" "${compiler}-head"
      else
        do_install "$1" "${compiler}" "${compiler_version}"
      fi
      ;;
    *)
      do_install "$1" "$1"
  esac
}

main "$@"