#!/bin/bash

set -eu
set +x

echo >&2 "Updating cattleshed configuration..."
install -m 755 /vagrant/scripts/compilers.py "$WANDBOX_BUILDER/cattleshed-conf/compilers.py"
mkdir -p $WANDBOX_BUILDER/wandbox/cattleshed-conf
cd $WANDBOX_BUILDER/cattleshed-conf
./update.sh

if [[ -z "$(docker images -q wandbox-service)" ]]; then
  echo >&2 "Building Docker image for Wandbox service..."
  docker build -t ubntintrepid/wandbox-service:latest /vagrant/wandbox
fi

echo >&2 "Removing existed containers..."
docker rm -f $(docker ps -aq) || true

echo >&2 "Starting Wandbox service..."
docker run -d \
  --name wandbox \
  --restart=always \
  --privileged=true \
  -v /vagrant/work:/var/work \
  -v $WANDBOX_BUILDER/wandbox:/opt/wandbox \
  -p "3500:3500" \
  ubntintrepid/wandbox-service:latest \
  usr/bin/supervisord -c /var/work/supervisord.conf
