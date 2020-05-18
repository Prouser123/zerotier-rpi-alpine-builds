#!/bin/sh

# ZeroTier One Unofficial Installer Script for Alpine Linux on armv6 (All Raspberry Pi Models)

set -x

mkdir -p /tmp/zt-inst-rpi
cd /tmp/zt-inst-rpi

curl -L https://ci.jcx.ovh/job/zerotier-rpi-alpine-builds/job/master/lastSuccessfulBuild/artifact/zerotier-one-armv6.tar.gz | tar -zxvf -

# Move exec to sbin
mv zerotier-one /sbin

# Setup symbolic links
(cd /sbin; ln -s zerotier-one zerotier-cli; ln -s zerotier-one zerotier-idtool)

# Enable the 'tun' kernel module.
modprobe tun
echo tun >> /etc/modules

# Remove the temp files we created
cd / && rm -r /tmp/zt-inst-rpi

# Create a service to autostart the daemon
echo -e '#!/sbin/openrc-run

name="Zerotier One Daemon"
command=/sbin/zerotier-one
command_args="-d"

depend() {
	need net
}
' > /etc/init.d/zerotier-one

chmod 775 /etc/init.d/zerotier-one

# Have the service start at boot.
ln -s /etc/init.d/zerotier-one /etc/runlevels/default/zerotier-one

# Add to LBU
lbu add /sbin/zerotier-cli
lbu add /sbin/zerotier-idtool
lbu add /sbin/zerotier-one

lbu add /etc/modules

# Commit the changes to RAM.
lbu commit -d