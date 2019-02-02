#!/bin/bash
echo "Configure syncthing for $USER"
systemctl enable syncthing@${USER}.service
systemctl start syncthing@${USER}.service
/lib/systemd/systemd
#/usr/bin/startx 
