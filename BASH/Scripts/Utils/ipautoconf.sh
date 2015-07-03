#!/bin/bash
 
HOSTNAME=$1
IP=$2
SUBNET=$3
GATEWAY=$4
 
rm -rf /etc/udev/rules.d/70-persistent-net.rules
 
echo $HOSTNAME > /etc/hostname
 
echo "# This file describes the network interfaces available on your system" > /etc/network/interfaces
echo "# and how to activate them. For more information, see interfaces(5)." >> /etc/network/interfaces
echo "" >> /etc/network/interfaces
echo "# The loopback network interface" >> /etc/network/interfaces
echo "auto lo" >> /etc/network/interfaces
echo "iface lo inet loopback" >> /etc/network/interfaces
echo ""  >> /etc/network/interfaces
echo "auto eth0" >> /etc/network/interfaces
echo "iface eth0 inet static" >> /etc/network/interfaces
echo "  address $IP" >> /etc/network/interfaces
echo "  netmask $SUBNET" >> /etc/network/interfaces
echo "  gateway $GATEWAY" >> /etc/network/interfaces
 
rm -rf /root/customization.sh
