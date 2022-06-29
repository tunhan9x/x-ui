# x-ui|

支持多协议多用户的 xray 面板
原版本由[vaxilu](https://github.com/vaxilu)进行开发，项目地址请参考[链接](https://github.com/vaxilu/x-ui)
本项目由原项目fork而来,初衷只是为了学习golang，并添加自己觉得有用的功能。
具体使用教程可以参考个人博客文章[链接](https://coderfan.net/how-to-use-x-ui-pannel-to-set-up-proxies-for-bypassing-gfw.html)
欢迎大家使用并反馈意见,提交Pr,帮助项目更好的改善~

# 变更记录

- 2022.06.19：增加Shadowsocs2022新的Cipher，增加节点搜索、一键清除流量功能
- 2022.05.14：增加Telegram bot Command控制功能，支持关闭/开启/删除节点等
- 2022.04.25：增加SSH登录提醒
- 2022.04.23：增加更多Telegram bot提醒功能
- 2022.04.16：增加面板设置Telegram bot功能
- 2022.04.12：优化Telegram Bot通知提醒
- 2022.04.06：优化安装/更新流程，增加证书签发功能，添加Telegram bot机器人推送功能

# 功能介绍

- 系统状态监控
- 支持多用户多协议，网页可视化操作
- 支持的协议：vmess、vless、trojan、shadowsocks、dokodemo-door、socks、http
- 支持配置更多传输配置
- 流量统计，限制流量，限制到期时间
- 可自定义 xray 配置模板
- 支持 https 访问面板（自备域名 + ssl 证书）
- 支持一键SSL证书申请且自动续签
- Telegram bot通知、控制功能
- 更多高级配置项，详见面板

# 安装

```
bash <(curl -Ls https://raw.githubusercontent.com/FranzKafkaYu/x-ui/master/install.sh)
```

如果你的系统版本比较老旧，安装后报错：GLIBC_2.28 not found，请使用如下命令安装0.3.3.9版本

```
bash <(curl -Ls https://raw.githubusercontent.com/FranzKafkaYu/x-ui/master/install.sh) 0.3.3.9  
```

但该版本会在切换xray内核时报错，建议尽快升级系统

## 建议系统

- CentOS 7+
- Ubuntu 16+
- Debian 8+

# Telegram

[CoderfanBaby](https://t.me/CoderfanBaby)
[FranzKafka‘sPrivateGroup](https://t.me/franzkafayu)

# 致谢

- [vaxilu/x-ui](https://github.com/vaxilu/x-ui)
- [XTLS/Xray-core](https://github.com/XTLS/Xray-core)
- [telegram-bot-api](https://github.com/go-telegram-bot-api/telegram-bot-api)

## Stargazers over time

[![Stargazers over time](https://starchart.cc/FranzKafkaYu/x-ui.svg)](https://starchart.cc/FranzKafkaYu/x-ui)
