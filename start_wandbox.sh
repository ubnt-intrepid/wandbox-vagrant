#!/bin/bash

echo "Removing existed containers..."
docker rm -f $(docker ps -aq) || true

echo "Starting Wandbox service..."
docker run -d --name wandbox \
  --restart=always \
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
