FROM browsers/base:7.3.6

ARG VERSION
ARG PACKAGE=firefox

LABEL browser=$PACKAGE:$VERSION

RUN  \
        apt-get update && \
        apt-get install -y software-properties-common wget && \
        # https://support.mozilla.org/en-US/kb/install-firefox-linux#w_install-firefox-deb-package-for-debian-based-distributions-recommended
        install -d -m 0755 /etc/apt/keyrings && \
        wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null && \
        echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null && \
        printf 'Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000\n' | tee /etc/apt/preferences.d/mozilla && \
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
