#!/bin/bash - 

set -o errexit
set -o nounset

for conffile in $(env | sed -n '/^conff./{s///;p}')
do
	eval $(awk -F'=' '{print "service=\"" $1 "\""; print "conffile=\"" $2 "\""}' <<<$conffile)

	if [ ! -f "$conffile.tmpl" ] ; then
		cp "$conffile" "$conffile.tmpl"
	fi

	perl -pe 's/%%([^%]+)%%/$ENV{$1}/' < "$conffile.tmpl" > "$conffile"
done
if [ -S /docker.sock ]
then
	ln -sf /docker.sock /var/run/docker.sock
fi
# udev
udevadm trigger --action=change
#Add user
useradd --user-group --create-home --shell /bin/zsh --home-dir /home/$USER  $USER &> /dev/null
usermod -a -G tty,video,audio $USER 
chown -R ${USER}. /custom
# Mount home dir for syncthing
if [ -d "/opt/user_data/${USER}" ]
then    
	rm -rf /home/${USER}
	ln -sf /opt/user_data/${USER} /home/${USER}
	mkdir -p /home/${USER}/.config/
#	ln -sf /opt/user_data/syncthing/${USER}/.config/syncthing /home/${USER}/.config/syncthing
	chown -R ${USER}. /opt/user_data/${USER}
else
	cp -r /home/${USER} /opt/user_data/${USER}
	rm -rf /home/${USER}
	ln -sf /opt/user_data/${USER} /home/${USER}
	mkdir -p /home/${USER}/.config/
#	ln -sf /opt/user_data/syncthing/${USER}/.config/syncthing /home/${USER}/.config/syncthing
        /usr/share/shapre-os/user-template/apply.sh 
	chown -R ${USER}. /opt/user_data/${USER}
fi
systemctl enable syncthing@${USER}.service
systemctl start syncthing@${USER}.service

#Add sudo
echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/users
