FROM browsers/base:7.4.2

ARG VERSION
ARG PACKAGE=microsoft-edge-stable
ARG INSTALL_DIR=msedge

LABEL browser=$PACKAGE:$VERSION

RUN \
        apt-get update && \
        apt-get -y --no-install-recommends install software-properties-common apt-transport-https curl ca-certificates gnupg iproute2 iptables lsof python3-pip && \
        curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-edge.gpg && \
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list && \
        apt-get update && \
        apt-get -y --no-install-recommends install $PACKAGE=$VERSION || true && \
        sed -i 's/install_deb822_sources/#install_deb822_sources/' /var/lib/dpkg/info/microsoft-edge-dev.postinst && \
        dpkg --configure -a && \
        pip3 install --default-timeout=300 tcconfig && \
        # Check network utilities version
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
