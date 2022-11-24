FROM debian:11-slim
WORKDIR /root
COPY en.sh /root/en.sh
RUN apt-get update && apt-get install -y --no-install-recommends -y  systemctl curl bash v2ray gzip wget ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN systemctl start v2ray
RUN bash /root/en.sh
WORKDIR /root


VOLUME [ "/etc/x-ui" ]
CMD [ "/root/x-ui/x-ui" ]