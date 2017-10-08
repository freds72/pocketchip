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
export PASSPHRASE=$1
sed -e "s/PASSPHRASE/$PASSPHRASE/g" $SRC/etc/hostapd.d/pocketchip_ap.conf > /etc/hostapd.d/pocketchip_ap.conf
cp $SRC/lib/systemd/system/hostapd-systemd.service /lib/systemd/system/hostapd-systemd.service
update-rc.d hostapd disable
echo "1"
systemctl daemon-reload
echo "2"
systemctl enable hostapd-systemd
echo "3"
systemctl start hostapd-systemd
echo "Check:"
systemctl status hostapd-systemd

