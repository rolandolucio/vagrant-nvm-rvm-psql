#!/usr/bin/env bash



#Set the SWAP mem

echo "================================
 SWAP   
================================"

sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo /sbin/swapon /var/swap.1

sudo cat >> /etc/fstab <<EOL
/var/swap.1 swap swap defaults 0 0
EOL
sudo cat /etc/fstab 