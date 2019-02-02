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
#systemctl enable syncthing@${USER}.service
#systemctl start syncthing@${USER}.service

#Add sudo
echo "${USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/users
