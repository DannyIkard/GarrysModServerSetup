#!/bin/bash
LATESTKERNEL = apt-cache search linux-image | grep "linux-image" | grep -v "dbg" | grep -v "meta" | tail -1
cat >> /etc/apt/preferences << EOF
Package: *
Pin: release o=Debian,a=stable-proposed-updates
Pin-Priority: 102
EOF
echo "deb http://ftp.us.debian.org/debian stable-proposed-updates main" >> /etc/apt/sources.list
apt-get update
apt-get -t stable-proposed-updates install $LATESTKERNEL