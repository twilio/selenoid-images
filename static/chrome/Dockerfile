ARG VERSION
FROM golang:1.18 as go

COPY devtools /devtools

RUN \
    apt-get update && \
    apt-get install -y upx-ucl && \
    cd /devtools && \
    go test -race && \
    GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" && \
    upx /devtools/devtools

FROM selenoid/dev_chrome:$VERSION

ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
COPY --from=go /devtools/devtools /usr/bin/
COPY policies.json /etc/opt/chrome/policies/managed/
COPY chromedriver /usr/bin/
COPY entrypoint.sh /

RUN \
    chmod +x /usr/bin/chromedriver && \
    chown -R selenium:nogroup /etc/opt/chrome/policies/managed/

# Use root user: allows running network manipulation commands (tc)
USER root

# Bug ticket: https://bugs.launchpad.net/ubuntu/+source/glibc/+bug/1962225
RUN mv /bin/uname /bin/uname.orig
RUN printf '#!/bin/bash\n\nif [[ "$1" == "-r" ]] ;then\n echo '4.9.250'\n exit\nelse\n uname.orig "$@"\nfi' > /bin/uname
RUN chmod 755 /bin/uname

EXPOSE 4444
ENTRYPOINT ["/entrypoint.sh"]
