FROM browsers/base:7.3.6

ARG VERSION
ARG PACKAGE=firefox
ARG PPA

LABEL browser=$PACKAGE:$VERSION

RUN  \
        ( [ "$PPA" != "" ] && \
            apt-get update && \
            apt-get install -y software-properties-common && \
            apt-get update && \
            add-apt-repository -y $PPA \
        ) || true && \
        apt-get update && \
        apt-get -y --no-install-recommends install iproute2 iptables lsof python3-pip libavcodec58 $PACKAGE=$VERSION && \
        pip3 install --default-timeout=300 tcconfig && \
        # Workaround for tcset command (https://github.com/thombashi/tcconfig/issues/177)
        pip3 uninstall -y SimpleSQLite==1.5.1 && \
        pip3 install SimpleSQLite==1.4.0 && \
        # Check network utilities version
        ip -V && \
        iptables -V && \
        tcset -V && \
        ( [ "$PACKAGE" != "firefox" ] && ln /usr/bin/$PACKAGE /usr/bin/firefox ) || true && \
        firefox --version && \
        rm -Rf /tmp/* && rm -Rf /var/lib/apt/lists/*
