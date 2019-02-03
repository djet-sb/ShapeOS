#!/bin/bash

#dconf load /org/gnome/terminal/legacy/profiles:/ < /usr/share/shapre-os/user-template/ShapeOS-theme.dconf
cp -r  /usr/share/shapre-os/user-template/{.oh-my-zsh,.zshrc} /home/${USER}
: > /home/${USER}/first.start
