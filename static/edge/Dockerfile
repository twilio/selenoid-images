ARG VERSION
FROM selenoid/dev_edge:$VERSION

ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
COPY msedgedriver /usr/bin/
COPY entrypoint.sh /

RUN chmod +x /usr/bin/msedgedriver

# Use root user: allows running network manipulation commands (tc)
USER root

# Bug ticket: https://bugs.launchpad.net/ubuntu/+source/glibc/+bug/1962225
RUN mv /bin/uname /bin/uname.orig
RUN printf '#!/bin/bash\n\nif [[ "$1" == "-r" ]] ;then\n echo '4.9.250'\n exit\nelse\n uname.orig "$@"\nfi' > /bin/uname
RUN chmod 755 /bin/uname

EXPOSE 4444
ENTRYPOINT ["/entrypoint.sh"]
