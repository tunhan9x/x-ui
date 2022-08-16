FROM golang:latest AS builder
WORKDIR /root
COPY . .
RUN go build main.go


FROM debian:11-slim
RUN apt-get update && apt-get install -y --no-install-recommends -y ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
WORKDIR /root
COPY --from=builder  /root/main /root/x-ui
run apt-get update && apt-get install wget -y
run apt install unzip
RUN wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-arm64-v8a.zip
RUN unzip Xray-linux-arm64-v8a.zip
RUN rm -f Xray-linux-arm64-v8a.zip geoip.dat geosite.dat
RUN wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
RUN wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
run mv xray xray-linux-arm64
RUN mv xray-linux-arm64 /root/bin/
RUN mv geoip.dat /root/bin/
RUN mv geosite.dat /root/bin/
#COPY bin/. /root/bin/.
VOLUME [ "/etc/x-ui" ]
CMD [ "./x-ui" ]
