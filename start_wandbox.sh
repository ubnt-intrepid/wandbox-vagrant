#!/bin/bash

echo >&2 "Removing existed containers..."
docker rm -f $(docker ps -aq) || true

echo >&2 "Starting Wandbox service..."
docker run -d \
  --name wandbox \
  --restart=always \
  --privileged=true \
  -v /vagrant:/var/work \
  -v /root/src/wandbox-builder/wandbox:/opt/wandbox \
  -p "3500:3500" \
  "wandbox"
