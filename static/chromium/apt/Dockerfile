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
      libgtk-3-0 \
      ${PACKAGE}=${VERSION} \
      chromium-chromedriver=${VERSION} && \
    ip -V && \
    iptables -V && \
    chromium-browser --version && \
    rm -Rf /tmp/* && rm -Rf /var/lib/apt/lists/*
