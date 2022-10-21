#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

cur_dir=$(pwd)

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}Error：${plain} This script must be run as root user！\n" && exit 1

# check os
if [[ -f /etc/redhat-release ]]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
else
    echo -e "${red}System version not detected, please contact the script author!${plain}\n" && exit 1
fi

arch=$(arch)

if [[ $arch == "x86_64" || $arch == "x64" || $arch == "amd64" ]]; then
    arch="amd64"
elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
    arch="arm64"
else
    arch="amd64"
    echo -e "${red}Failed to detect schema, use default schema: ${arch}${plain}"
fi

echo "Architecture: ${arch}"

if [ $(getconf WORD_BIT) != '32' ] && [ $(getconf LONG_BIT) != '64' ]; then
    echo "This software does not support 32-bit system (x86), please use 64-bit system (x86_64), if the detection is wrong, please contact the author"
    exit -1
fi

os_version=""

# os version
if [[ -f /etc/os-release ]]; then
    os_version=$(awk -F'[= ."]' '/VERSION_ID/{print $3}' /etc/os-release)
fi
if [[ -z "$os_version" && -f /etc/lsb-release ]]; then
    os_version=$(awk -F'[= ."]+' '/DISTRIB_RELEASE/{print $2}' /etc/lsb-release)
fi

if [[ x"${release}" == x"centos" ]]; then
    if [[ ${os_version} -le 6 ]]; then
        echo -e "${red}Please use CentOS 7 or later！${plain}\n" && exit 1
    fi
elif [[ x"${release}" == x"ubuntu" ]]; then
    if [[ ${os_version} -lt 16 ]]; then
        echo -e "${red}Please use Ubuntu 16 or later！${plain}\n" && exit 1
    fi
elif [[ x"${release}" == x"debian" ]]; then
    if [[ ${os_version} -lt 8 ]]; then
        echo -e "${red}Please use Debian 8 or later！${plain}\n" && exit 1
    fi
fi

install_base() {
    if [[ x"${release}" == x"centos" ]]; then
        yum install wget curl tar -y
    else
        apt install wget curl tar -y
    fi
}

#This function will be called when user installed x-ui out of sercurity
config_after_install() {
    echo -e "${yellow}For security reasons, the port and account password need to be modified after installation/update is completed.${plain}"
    read -p "Confirm whether to continue, if you choose n, you will skip this port and account password setting[y/n]": config_confirm
    if [[ x"${config_confirm}" == x"y" || x"${config_confirm}" == x"Y" ]]; then
        read -p "Please set your account name:" config_account
        echo -e "${yellow}Your account name will be set to:${config_account}${plain}"
        read -p "Please set your account password:" config_password
        echo -e "${yellow}Your account password will be set to:${config_password}${plain}"
        read -p "Please set the panel access port:" config_port
        echo -e "${yellow}Your panel access port will be set to:${config_port}${plain}"
        echo -e "${yellow}Confirming, Setting up...${plain}"
        /usr/local/x-ui/x-ui setting -username ${config_account} -password ${config_password}
        echo -e "${yellow}Account password setting completed${plain}"
        /usr/local/x-ui/x-ui setting -port ${config_port}
        echo -e "${yellow}Panel port setting completed${plain}"
    else
        echo -e "${red}Automatic Installation...${plain}"
        echo -e "${red}For a fresh installation, the default web port is ${green}54321${plain}，Username and password both are ${green}admin${plain}"
        echo -e "${red}If it is a version upgrade, port, login credentials and inbounds will remain unchanged. You can enter x-ui and then type the number 7 to view the login information${plain}"
    fi
}

install_x-ui() {
    systemctl stop x-ui
    cd /usr/local/

    if [ $# == 0 ]; then
        last_version=$(curl -Ls "https://api.github.com/repos/NidukaAkalanka/x-ui-english/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        if [[ ! -n "$last_version" ]]; then
            echo -e "${red}x-ui version check failed, it may be beyond Github API limit. Please try again later, or specify manually${plain}"
            exit 1
        fi
        echo -e "x-ui The latest version is: ${last_version}, start installation"
        wget -N --no-check-certificate -O /usr/local/x-ui-linux-${arch}.tar.gz https://github.com/NidukaAkalanka/x-ui-english/releases/download/${last_version}/x-ui-linux-${arch}.tar.gz
        if [[ $? -ne 0 ]]; then
            echo -e "${red}x-ui Download Failed, please make sure your server can download from Github${plain}"
            exit 1
        fi
    else
        last_version=$1
        url="https://github.com/NidukaAkalanka/x-ui-english/releases/download/${last_version}/x-ui-linux-${arch}.tar.gz"
        echo -e "start installation x-ui v$1"
        wget -N --no-check-certificate -O /usr/local/x-ui-linux-${arch}.tar.gz ${url}
        if [[ $? -ne 0 ]]; then
            echo -e "${red}x-ui Download v$1 fail, Please make sure this version exists${plain}"
            exit 1
        fi
    fi

    if [[ -e /usr/local/x-ui/ ]]; then
        rm /usr/local/x-ui/ -rf
    fi

    tar zxvf x-ui-linux-${arch}.tar.gz
    rm x-ui-linux-${arch}.tar.gz -f
    cd x-ui
    chmod +x x-ui bin/xray-linux-${arch}
    cp -f x-ui.service /etc/systemd/system/
    wget --no-check-certificate -O /usr/bin/x-ui https://raw.githubusercontent.com/NidukaAkalanka/x-ui-english/main/x-ui.sh
    chmod +x /usr/local/x-ui/x-ui.sh
    chmod +x /usr/bin/x-ui
    config_after_install
    #echo -e "If it is a new installation, the default web port port is ${green}54321${plain}，The username and password are default ${green}admin${plain}"
    #echo -e "Please make sure that this port is not occupied by other programs，${yellow}Make sure 54321 is open${plain}"
    #    echo -e "If you want to modify the 54321 to other ports and enter the X-UI command to modify it, you must also ensure that the port you modify is also open"
    #echo -e ""
    #echo -e "If it is a panel update, access the panel in your previous way"
    #echo -e ""
    systemctl daemon-reload
    systemctl enable x-ui
    systemctl start x-ui
    echo "------------------------------------------"
    echo -e "${green}\\  //  ||   || ||${plain}"
    echo -e "${green} \\//   ||   || ||${plain}"
    echo -e "${green} //\\   ||___|| ||${plain}"
    echo -e "${green}//  \\  |_____| ||${plain}"
    echo "------------------------------------------"
    echo -e "${green}x-ui v${last_version}${plain}The installation is complete, the panel has been started"
    echo -e ""
    echo -e "x-ui Management script usage: "
    echo -e "----------------------------------------------"
    echo -e "x-ui              - Show the management menu"
    echo -e "x-ui start        - Start X-UI panel"
    echo -e "x-ui stop         - Stop X-UI panel"
    echo -e "x-ui restart      - Restart X-UI panel"
    echo -e "x-ui status       - View X-UI status"
    echo -e "x-ui enable       - Set X-UI boot self-starting"
    echo -e "x-ui disable      - Cancel X-UI boot self-starting"
    echo -e "x-ui log          - View x-ui log"
    echo -e "x-ui v2-ui        - Migrate V2-UI account data of this machine to X-UI"
    echo -e "x-ui update       - Update X-UI panel"
    echo -e "x-ui install      - Install X-UI panel"
    echo -e "x-ui uninstall    - Uninstall X-UI panel"
    echo -e "----------------------------------------------"
    echo -e "Please comsider supporting authors"
    echo -e "----------------------------------------------"
    echo -e "vaxilu            - https://github.com/vaxilu"    
    echo -e "LuckyHunter       - https://github.com/Chasing66"
    echo -e "Yu FranzKafka     - https://github.com/FranzKafkaYu"
    echo -e "Niduka Akalanka   - https://github.com/NidukaAkalanka"

}

echo -e "${green}start installation${plain}"
install_base
install_x-ui $1
