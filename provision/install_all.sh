#!/bin/bash

set -euo
set +x

BASE_DIR="$(cd $(dirname $0); pwd)"

# Install Wandbox binaries
$BASE_DIR/do_install.sh cattleshed
$BASE_DIR/do_install.sh kennel

# Install compilers
$BASE_DIR/do_install.sh clang 3.7.1
$BASE_DIR/do_install.sh go-head
$BASE_DIR/do_install.sh pony-head

# Install Boost
$BASE_DIR/do_install.sh boost 1.61.0 clang 3.7.1