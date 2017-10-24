#!/bin/sh
apt-get -y install dnsmasq
apt-get -y install xinput
apt-get -y install x11vnc

if [ $# -eq 0 ]
then
    echo "$0: No arguments supplied"
    exit -1
fi
if [ -z "$1" ]
then
    echo "$0: Missing passphrase"
    exit -1
fi
SRC=$(dirname "$0")
echo "Copying misc. tools..."
cp -r $SRC/usr/* /usr/.
chmod +x /usr/bin/touch_on
chmod +x /usr/bin/touch_off
chmod +x /usr/bin/vnc_onoff
cp -r usr/share/* /usr/share/
echo "Setting up wireless access point..."
cp $SRC/etc/dnsmasq.d/access_point.conf /etc/dnsmasq.d/access_point.conf
cp $SRC/etc/network/interfaces /etc/network/interfaces
/etc/init.d/dnsmasq restart
mkdir -p /etc/hostapd.d
export PASSPHRASE=$1
sed -e "s/PASSPHRASE/$PASSPHRASE/g" $SRC/etc/hostapd.d/pocketchip_ap.conf > /etc/hostapd.d/pocketchip_ap.conf
cp $SRC/lib/systemd/system/hostapd-systemd.service /lib/systemd/system/hostapd-systemd.service
update-rc.d hostapd disable
echo "Reloading services configuration..."
systemctl daemon-reload
echo "Enabling wireless service..."
systemctl enable hostapd-systemd
echo "Starting wireless service..."
systemctl start hostapd-systemd
echo "Wireless network check:"
systemctl status hostapd-systemd

