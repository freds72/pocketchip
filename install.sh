#!/bin/sh
# apt-get install dnsmasq
if [ $# -eq 0 ]
  then
    echo "$0: No arguments supplied"
fi
if [ -z "$1" ]
  then
    echo "$0: Missing passphrase"
fi
SRC=$(dirname "$0")
cp $SRC/etc/dnsmasq.d/access_point.conf /etc/dnsmasq.d/access_point.conf
cp $SRC/etc/network/interfaces /etc/network/interfaces
/etc/init.d/dnsmasq restart
mkdir -p /etc/hostapd.d
cp $SRC/etc/hostapd.d/pocket_chip.conf /etc/hostapd.d/pocket_chip.conf
export PASSPHRASE=$1
sed -e "s/PASSPHRASE/$PASSPHRASE/g" input.file
cp $SRC/lib/systemd/system/hostapd-systemd.service lib/systemd/system/hostapd-systemd.service
update-rc.d hostapd disable
systemctl daemon-reload
systemctl enable hostapd-systemd
systemctl start hostapd-systemd
systemctl status hostapd-systemd

