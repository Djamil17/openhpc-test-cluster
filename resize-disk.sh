#!/bin/bash

set -x
set -e

yum install -y cloud-utils-growpart

if growpart /dev/sda 1 >&2 ; then
   echo "partition grown"
else
   echo "growing partition..."
fi

xfs_growfs /dev/sda1

exit 0
