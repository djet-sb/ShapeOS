udevadm trigger --action=change
cp /root/.Xauthority /home/${USER}/
export XAUTHORITY=/home/${USER}/.Xauthority
export DISAPLY=:0
su --preserve-environment -c '/usr/bin/i3 -c ~/.config/i3/config' ${USER}
