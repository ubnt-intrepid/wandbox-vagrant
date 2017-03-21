#!/bin/bash

set -e
set +x

# Disable SELinux
which setenforce > /dev/null && setenforce 0 || true

# Install dependencies
sudo apt-get install -y git

# Clone builder script
[[ -d /root/src/wandbox-builder ]] || {
  git clone --depth 1 \
    https://github.com/melpon/wandbox-builder.git \
    /root/src/wandbox-builder
}

# Append supplemental scripts
cd /root/src/wandbox-builder
cp /vagrant/docker-exec.sh ./build/docker-exec.sh
chmod +x ./build/docker-exec.sh

# Build docker images
# cd /root/src/wandbox-builder/build
# ./docker-build.sh ldc-head
# ./docker-build.sh go-head

# Install compilers & Wandbox binaries
cd /root/src/wandbox-builder/build
[[ -f ../wandbox/cattleshed/bin/cattleshed ]] || ./docker-exec.sh cattleshed ./install.sh
[[ -d ../wandbox/kennel/bin ]] || ./docker-exec.sh kennel ./install.sh
[[ -d ../wandbox/go-head/bin ]] || ./docker-exec.sh go-head ./install.sh
[[ -d ../wandbox/ocaml-head/bin ]] || ./docker-exec.sh ocaml-head ./install.sh

# Update cattleshed.conf
cd /root/src/wandbox-builder/cattleshed-conf
mkdir -p ../wandbox/cattleshed-conf
./update.sh

# Start service
cd /root/src/wandbox-builder/test
docker rm -f wandbox || true
docker run -d \
  --name wandbox \
  --privileged=true \
  -p "3500:3500" \
  -v /vagrant:/var/work \
  -v /root/src/wandbox-builder/wandbox:/opt/wandbox \
  "melpon/wandbox:test-server" \
  /bin/bash -c "
    set -e

    mkdir /usr/share/perl || true
    /opt/wandbox/cattleshed/bin/cattleshed \
      -c /opt/wandbox/cattleshed/etc/cattleshed.conf \
      -c /opt/wandbox/cattleshed-conf/compilers.default &
    sleep 1

    /opt/wandbox/kennel/bin/kennel \
      -c /var/work/kennel.json &

    while true; do
      sleep 10
    done
 "
