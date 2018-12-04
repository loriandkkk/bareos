#!/usr/bin/env bash

if [ ! -f /etc/bareos/bareos-config.control ]
  then
  tar xfvz /bareos-fd.tgz

  # Force client/file daemon password
  sed -i "s#Password = .*#Password = \"${BAREOS_FD_PASSWORD}\"#" /etc/bareos/bareos-fd.d/director/bareos-dir.conf

  # Force client/file daemon plugin config
  sed -i "s#\# Plugin Directory = .*#Plugin Directory = /usr/lib64/bareos/plugins#" /etc/bareos/bareos-fd.d/client/myself.conf
  sed -i "s#\# Plugin Names = .*#Plugin Names = \"python\"#" /etc/bareos/bareos-fd.d/client/myself.conf
  # Control file
  touch /etc/bareos/bareos-config.control
fi

find /etc/bareos/bareos-fd.d ! -user bareos -exec chown bareos {} \;
exec "$@"
