FROM browsers/base:7.4.0

ARG VERSION
ARG PACKAGE=google-chrome-stable
ARG INSTALL_DIR=chrome

LABEL browser=$PACKAGE:$VERSION

#Use root user
USER root

RUN mv /bin/uname /bin/uname.orig
RUN printf '#!/bin/bash\n\nif [[ "$1" == "-r" ]] ;then\n echo '4.9.250'\n exit\nelse\n uname.orig "$@"\nfi' > /bin/uname
RUN chmod 755 /bin/uname

RUN \
        curl -s https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
        echo 'deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google.list && \
        apt-get update && \
        apt-get -y --no-install-recommends install iproute2 iptables lsof python3-pip $PACKAGE=$VERSION && \
        pip3 install --default-timeout=300 tcconfig && \
        sed -i -e 's@exec -a "$0" "$HERE/chrome"@& --no-sandbox --disable-gpu@' /opt/google/$INSTALL_DIR/google-chrome && \
        chown root:root /opt/google/$INSTALL_DIR/chrome-sandbox && \
        chmod 4755 /opt/google/$INSTALL_DIR/chrome-sandbox && \
        google-chrome --version && \
        rm -Rf /tmp/* && rm -Rf /var/lib/apt/lists/*
