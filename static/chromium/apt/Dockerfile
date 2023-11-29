FROM browsers/base:7.4.0

ARG VERSION
ARG PACKAGE=chromium-browser

LABEL browser=$PACKAGE:$VERSION

RUN \
    apt-get update && \
    apt-get -y --no-install-recommends install \
      iproute2 \
      iptables \
      lsof \
      python3-pip \
      libgtk-3-0 \
      ${PACKAGE}=${VERSION} \
      chromium-chromedriver=${VERSION} && \
    pip3 install --default-timeout=300 tcconfig && \
    # Workaround for tcset command (https://github.com/thombashi/tcconfig/issues/177)
    pip3 uninstall -y SimpleSQLite==1.5.1 && \
    pip3 install SimpleSQLite==1.4.0 && \
    # Check network utilities version
    ip -V && \
    iptables -V && \
    tcset -V && \
    chromium-browser --version && \
    rm -Rf /tmp/* && rm -Rf /var/lib/apt/lists/*
