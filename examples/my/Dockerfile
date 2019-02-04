FROM bres/shape-os
RUN apt update -y \
    && add-apt-repository ppa:atareao/telegram \
    && apt-get install --no-install-recommends -y  \
                          chromium-browser \
                          iproute2 htop aptitude \
                          telegram-desktop \
                          nemo \
                          docker-ce

