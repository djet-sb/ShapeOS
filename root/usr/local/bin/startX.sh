#!/bin/sh
su -c '/usr/bin/X vt4' ${USER} &
sleep 5
if [ -f /home/${USER}/first.start ]
then
	dconf load /org/gnome/terminal/ < /usr/share/shapre-os/user-template/ShapeOS-theme.dconf
	rm /home/${USER}/first.start
fi
	#!!!! Need fix it
#su -c '/usr/bin/i3' ${USER}
su --preserve-environment -c '/usr/bin/i3 -c ~/.config/i3/config' ${USER}

