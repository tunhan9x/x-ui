# x-ui

X-UI is a webUI pannel based on xray-core which supports multi protocols and multi users.
This project is a fork of [vaxilu&#39;s project](https://github.com/vaxilu/x-ui),and it is a experiental project which used by myself for learning golang
For some basic usages,please visit my [blog post](https://coderfan.net/how-to-use-x-ui-pannel-to-set-up-proxies-for-bypassing-gfw.html)

# changes

- 2022.06.19：Add shadowsocks 2022 Ciphers,add inbounds search,traffic clear function in WebUI
- 2022.05.14：Add Telegram bot commands,support enable/disable/delete/status check
- 2022.04.25：Add SSH login notify
- 2022.04.23：Add WebUi login notify
- 2022.04.16：Add Telegram bot set up in WebUi pannel
- 2022.04.12：Optimize Telegram bot notify,more human friendly
- 2022.04.06：Add cert issue function，optimize installation/update and add telegram bot notify

# basics

- support system status info check
- support multi protocols and multi users
- support protocols：vmess、vless、trojan、shadowsocks、dokodemo-door、socks、http
- support many transport method including tcp、udp、ws、kcp etc
- traffic counting,traffic restrict and time restrcit
- support custom configuration template
- support https access fot WebUI
- support SSL cert issue by Acme
- support telegram bot notify and control
- more functions

# installation
Make sure your system `bash` and `curl` and network are ready,here we go

```
bash <(curl -Ls https://raw.githubusercontent.com/FranzKafkaYu/x-ui/master/install.sh)
```

if your system is too old and you got this error：GLIBC_2.28 not found，please use the specific version -- 0.3.3.9

```
bash <(curl -Ls https://raw.githubusercontent.com/FranzKafkaYu/x-ui/master/install.sh) 0.3.3.9  
```

But this may cause some unexpected errors,plz upgrade you system as soon as possible

suggested system as follows:
- CentOS 7+
- Ubuntu 16+
- Debian 8+

# telegram

[CoderfanBaby](https://t.me/CoderfanBaby)
[FranzKafka‘sPrivateGroup](https://t.me/franzkafayu)

# credits
- [vaxilu/x-ui](https://github.com/vaxilu/x-ui)
- [XTLS/Xray-core](https://github.com/XTLS/Xray-core)
- [telegram-bot-api](https://github.com/go-telegram-bot-api/telegram-bot-api)

## Stargazers over time

[![Stargazers over time](https://starchart.cc/FranzKafkaYu/x-ui.svg)](https://starchart.cc/FranzKafkaYu/x-ui)
