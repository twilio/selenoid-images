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
        ( [ "$PACKAGE" != "firefox" ] && ln /usr/bin/$PACKAGE /usr/bin/firefox ) || true && \
        firefox --version && \
        rm -Rf /tmp/* && rm -Rf /var/lib/apt/lists/*
