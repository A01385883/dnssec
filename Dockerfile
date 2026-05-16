FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    bind9 \
    bind9utils \
    dnsutils

COPY named.conf.local /etc/bind/named.conf.local
COPY named.conf.options /etc/bind/named.conf.options
COPY db.test.lab /etc/bind/db.test.lab
COPY setup.sh /setup.sh

RUN chmod +x /setup.sh

EXPOSE 53/udp
EXPOSE 53/tcp

CMD ["/setup.sh"]
