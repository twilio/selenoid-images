FROM browsers/base:7.4.0

ARG VERSION
ARG PACKAGE=microsoft-edge-stable
ARG INSTALL_DIR=msedge

LABEL browser=$PACKAGE:$VERSION

RUN \
        apt-get update && \
        apt-get -y --no-install-recommends install software-properties-common apt-transport-https curl ca-certificates && \
        curl -fSsL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /usr/share/keyrings/microsoft-edge.gpg > /dev/null && \
        echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main' | tee /etc/apt/sources.list.d/microsoft-edge.list && \
        apt-get update && \
        apt-get -y --no-install-recommends install iproute2 iptables lsof python3-pip $PACKAGE=$VERSION && \
        pip3 install --default-timeout=300 tcconfig && \
        # Workaround for tcset command (https://github.com/thombashi/tcconfig/issues/177)
        pip3 uninstall -y SimpleSQLite==1.5.1 && \
        pip3 install SimpleSQLite==1.4.0 && \
        ip -V && \
        iptables -V && \
        tcset -V && \
        (  \
          sed -i -e 's@exec -a "$0" "$HERE/msedge"@& --no-sandbox --disable-gpu@' /opt/microsoft/$INSTALL_DIR/$PACKAGE || \
          sed -i -e 's@exec -a "$0" "$HERE/msedge"@& --no-sandbox --disable-gpu@' /opt/microsoft/$INSTALL_DIR/microsoft-edge \
        ) && \
        chown root:root /opt/microsoft/$INSTALL_DIR/msedge-sandbox && \
        chmod 4755 /opt/microsoft/$INSTALL_DIR/msedge-sandbox && \
        microsoft-edge --version && \
        rm -Rf /tmp/* && rm -Rf /var/lib/apt/lists/*
