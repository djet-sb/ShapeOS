FROM ubuntu:18.10

LABEL \
    maintainer="sergey@b-res.space" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.name=ShapeOS \
    org.label-schema.url="https://github.com/d00t-b-res/ShapeOS" \
    org.label-schema.vcs-url="https://github.com/d00t-b-res/ShapeOS.git" 

ENV DEBIAN_FRONTEND noninteractive
ENV DISPLAY :0
RUN apt-get update -qqy && apt-get upgrade -y && DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
      dpkg-reconfigure --frontend=noninteractive locales && \
      update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN apt-get update -qqy \
   && apt-get -qqy install apt-transport-https ca-certificates curl gnupg2 software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
   && curl -fsSL https://download.docker.com/linux/debian/gpg |  apt-key add - \
   && add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install primary apps 
RUN apt-get update -qqy  \
   && apt-get -qqy install zsh vim wget git i3blocks sudo docker xorg  xcb libxcb-ewmh2 \ 
      dbus-x11 xserver-xorg-input-libinput xserver-xorg-input-all  dh-autoreconf x11-xserver-utils
    
# Run make
RUN apt-get update -qqy \
    && apt-get -qqy install make gcc libxcb1-dev \
      libxcb-keysyms1-dev libpango1.0-dev \
      libxcb-util0-dev libxcb-icccm4-dev libyajl-dev \
      libstartup-notification0-dev libxcb-randr0-dev \
      libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
      libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
      libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev \
      dmenu gnome-terminal cmake cmake-data libcairo2-dev \
      libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev \
      libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config \
      python-xcbgen xcb-proto libxcb-xrm-dev libasound2-dev \
      libmpdclient-dev libiw-dev libcurl4-openssl-dev libpulse-dev libxcb-composite0-dev \
   # Install i3-gaps
   && cd /tmp/ \
   && git clone https://www.github.com/Airblader/i3 i3-gaps && cd i3-gaps \
   && autoreconf --force --install && mkdir -p build && cd build/ \
   && ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers \
   && make && make install && cd .. && rm -rf i3-gaps \
   # Install zsh
   && wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh  && sh ./install.sh && rm ./install.sh  \
   # Install polybar
   && git clone https://github.com/jaagr/polybar.git && cd polybar && ./build.sh && cd .. && rm -rf polybar \
   # Clean
   && apt-get remove -y *-dev && apt-get autoremove -y  && apt-get clean

# SystemD
RUN cd /lib/systemd/system/sysinit.target.wants/ && \
      ls | grep -v systemd-tmpfiles-setup.service | xargs rm -f && \
      rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
      systemctl mask -- \
            tmp.mount \
            etc-hostname.mount \
            etc-hosts.mount \
            etc-resolv.conf.mount \
            -.mount \
            swap.target \
            getty.target \
            getty-static.service \
            dev-mqueue.mount \
            cgproxy.service \
            systemd-tmpfiles-setup-dev.service \
            systemd-remount-fs.service \
            systemd-ask-password-wall.path \
            systemd-udevd \
            systemd-logind.service && \
      systemctl set-default multi-user.target || true

RUN sed -ri /etc/systemd/journald.conf \
      -e 's!^#?Storage=.*!Storage=volatile!'

ADD container-boot.service /etc/systemd/system/container-boot.service
RUN mkdir -p /etc/container-boot.d && \
      systemctl enable container-boot.service

# run stuff
ADD configurator.sh configurator_dumpenv.sh /root/
ADD configurator.service configurator_dumpenv.service startx.service udev.service systemd-logind.service /etc/systemd/system/
RUN chmod 700 /root/configurator.sh /root/configurator_dumpenv.sh && \
                systemctl enable configurator.service configurator_dumpenv.service startx.service udev.service systemd-logind.service

# Add configs

ADD ./i3wm-config /etc/i3/config
ADD ./launch.sh /root/launch.sh
ADD ./polybar_config /root/.config/polybar/config
ADD ./xorg-xinitrc /root/.xinitrc

CMD ["/lib/systemd/systemd"]

