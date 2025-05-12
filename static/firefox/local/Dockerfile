FROM browsers/base:7.3.6

ARG VERSION=noop
ARG PACKAGE=firefox

LABEL browser=$PACKAGE:$VERSION

RUN \
        ( \
            ( \
                curl -O http://host.docker.internal:8080/firefox.deb && \
                apt-get update && \
                apt-get -y --no-install-recommends install libavcodec58 iproute2 iptables lsof python3-pip && \
                pip3 install --default-timeout=300 tcconfig && \
                # Workaround for tcset command (https://github.com/thombashi/tcconfig/issues/177)
                pip3 uninstall -y SimpleSQLite==1.5.1 && \
                pip3 install SimpleSQLite==1.4.0 && \
                # Check network utilities version
                ip -V && \
                iptables -V && \
                tcset -V && \
                apt-get -y install libgtk-3-0 libstartup-notification0 libdbus-glib-1-2 \
            ) || \
            ( \
                curl -O http://host.docker.internal:8080/firefox.deb && \
                dpkg --add-architecture i386 && \
                apt-get update && \
                apt-get -y --no-install-recommends install libavcodec58 iproute2 iptables lsof python3-pip && \
                pip3 install --default-timeout=300 tcconfig && \
                # Workaround for tcset command (https://github.com/thombashi/tcconfig/issues/177)
                pip3 uninstall -y SimpleSQLite==1.5.1 && \
                pip3 install SimpleSQLite==1.4.0 && \
                # Check network utilities version
                ip -V && \
                iptables -V && \
                tcset -V && \
                apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386 libgtk-3-0:i386 libasound2:i386 libdbus-glib-1-2:i386 libxt6:i386 libatomic1:i386 libcairo-gobject2:i386 libstartup-notification0:i386 libx11-xcb1:i386 && \
                mkdir flashplayer && \
                cd flashplayer && \
                curl -o flashplayer.tar.gz https://fpdownload.adobe.com/pub/flashplayer/pdc/32.0.0.387/flash_player_ppapi_linux.i386.tar.gz && \
                tar xvzf flashplayer.tar.gz && \
                cp libpepflashplayer.so /usr/lib/flashplugin-installer/libflashplayer.so && \
                cd .. && \
                rm -Rf flashplayer \
            ) \
        ) && \
        dpkg -i firefox.deb && \
        ( [ "$PACKAGE" != "firefox" ] && ln /usr/bin/$PACKAGE /usr/bin/firefox ) || true && \
        rm firefox.deb && \
        firefox --version && \
        rm -Rf /tmp/* && rm -Rf /var/lib/apt/lists/* && rm -f firefox*.deb
