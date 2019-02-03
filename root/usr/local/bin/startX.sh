#!/bin/sh
su -c '/usr/bin/X' ${USER} &
sleep 5
if [ -f ~/first.start ]
then
	dconf load /org/gnome/terminal/legacy/profiles:/ < /usr/share/shapre-os/user-template/ShapeOS-theme.dconf
fi
	#!!!! Need fix it
su -c '/usr/bin/i3' ${USER}
