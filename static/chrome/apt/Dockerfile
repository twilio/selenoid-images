FROM browsers/base:7.4.0

ARG VERSION
ARG PACKAGE=google-chrome-stable
ARG INSTALL_DIR=chrome

LABEL browser=$PACKAGE:$VERSION

RUN \
        curl -s https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
        echo 'deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google.list && \
        apt-get update && \
        apt-get -y --no-install-recommends install iproute2 iptables lsof python3-pip $PACKAGE=$VERSION && \
        pip3 install --default-timeout=300 tcconfig && \
        # Workaround for tcset command (https://github.com/thombashi/tcconfig/issues/177)
        pip3 uninstall -y SimpleSQLite==1.5.1 && \
        pip3 install SimpleSQLite==1.4.0 && \
        # Check network utilities version
        ip -V && \
        iptables -V && \
        tcset -V && \
        sed -i -e 's@exec -a "$0" "$HERE/chrome"@& --no-sandbox --disable-gpu@' /opt/google/$INSTALL_DIR/google-chrome && \
        chown root:root /opt/google/$INSTALL_DIR/chrome-sandbox && \
        chmod 4755 /opt/google/$INSTALL_DIR/chrome-sandbox && \
        google-chrome --version && \
        rm -Rf /tmp/* && rm -Rf /var/lib/apt/lists/*
