#!/bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

cur_dir=$(pwd)

  arch=$(arch)
  last_version=${last_version}

if [[ $arch == "x86_64" || $arch == "x64" || $arch == "amd64" ]]; then
    arch="amd64"
elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
    arch="arm64"
else
    arch="amd64"
    echo -e "${red}fail to check system arch,will use default arch here: ${arch}${plain}"
fi

 if [ $# == 0 ]; then
        last_version=$(curl -Ls "https://api.github.com/repos/FranzKafkaYu/x-ui/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        if [[ ! -n "$last_version" ]]; then
            echo -e "${red}refresh x-ui version failed,it may due to Github API restriction,please try it later${plain}"
            exit 1
        fi
        echo -e "get x-ui latest version succeed:${last_version},begin to install..."
        wget -N --no-check-certificate -O /root/x-ui-linux-${arch}-english.tar.gz https://github.com/FranzKafkaYu/x-ui/releases/download/${last_version}/x-ui-linux-${arch}-english.tar.gz
        if [[ $? -ne 0 ]]; then
            echo -e "${red}dowanload x-ui failed,please be sure that your server can access Github{plain}"
            exit 1
        fi
    else
        last_version=$1
        url="https://github.com/FranzKafkaYu/x-ui/releases/download/${last_version}/x-ui-linux-${arch}-english.tar.gz"
        echo -e "begin to install x-ui v$1 ..."
        wget -N --no-check-certificate -O /root/x-ui-linux-${arch}-english.tar.gz ${url}
        if [[ $? -ne 0 ]]; then
            echo -e "${red}dowanload x-ui v$1 failed,please check the verison exists${plain}"
            exit 1
        fi
    fi


    tar zxvf x-ui-linux-${arch}-english.tar.gz
    rm x-ui-linux-${arch}-english.tar.gz -f
 