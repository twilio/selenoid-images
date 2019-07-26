FROM selenoid/base:5.0

ARG VERSION
ARG CLEANUP
ARG ADDITIONAL_APT_INSTALL_OPTS
ARG CHANNEL_ALIAS
ARG CHANNEL_PATH

RUN \
        ( [ "$CLEANUP" != "true" ] && rm -f /etc/apt/apt.conf.d/docker-clean ) || true && \
        wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
        echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google.list && \
        apt-get update && \
        apt-get -y --no-install-recommends $ADDITIONAL_APT_INSTALL_OPTS install iproute2 google-chrome-$CHANNEL_ALIAS=$VERSION && \
        chown root:root /opt/google/$CHANNEL_PATH/chrome-sandbox && \
        chmod 4755 /opt/google/$CHANNEL_PATH/chrome-sandbox && \
        google-chrome-$CHANNEL_ALIAS --version && \
        ($CLEANUP && rm -Rf /tmp/* && rm -Rf /var/lib/apt/lists/*) || true
