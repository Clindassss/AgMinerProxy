#!/bin/bash
[[ $(id -u) != 0 ]] && echo -e "请使用root权限运行安装脚本" && exit 1

cmd="apt-get"
if [[ $(command -v apt-get) || $(command -v yum) ]] && [[ $(command -v systemctl) ]]; then
    if [[ $(command -v yum) ]]; then
        cmd="yum"
    fi
else
    echo "此脚本不支持该系统" && exit 1
fi

install() {
    if [ -d "/root/kt_proxy" ]; then
        echo -e "您已安装了该软件,如果确定没有安装,请输入rm -rf /root/kt_proxy" && exit 1
    fi
    if screen -list | grep -q "ktproxy"; then
        echo -e "检测到您已启动了KTProxy,请关闭后再安装" && exit 1
    fi

    $cmd update -y
    $cmd install curl wget screen -y
    mkdir /root/kt_proxy

    echo "请选择软件版本"
    echo "  1、v0.0.4"
    echo "  2、v0.0.6"
    echo "  3、v0.0.7"
    read -p "$(echo -e "请输入[1-3]：")" choose
    case $choose in
    1)
        wget https://raw.githubusercontent.com/Clindassss/proxyrun/master/release/ktproxy_v0.0.4_linux -O /root/kt_proxy/ktproxy
        ;;
    2)
        wget https://raw.githubusercontent.com/Clindassss/proxyrun/master/release/ktproxy_v0.0.6_linux -O /root/kt_proxy/ktproxy
        ;;
    3)
        wget https://raw.githubusercontent.com/Clindassss/proxyrun/master/release/ktproxy_v0.0.7_darwin -O /root/kt_proxy/ktproxy
        ;;
    *)
        echo "请输入正确的数字"
        ;;
    esac
    chmod 777 /root/kt_proxy/ktproxy

    wget https://raw.githubusercontent.com/Clindassss/proxyrun/main/run.sh -O /root/kt_proxy/run.sh
    chmod 777 /root/kt_proxy/run.sh
    echo "如果没有报错则安装成功"
    echo "正在启动..."
    screen -dmS ktproxy
    sleep 0.2s
    screen -r ktproxy -p 0 -X stuff "cd /root/kt_proxy"
    screen -r ktproxy -p 0 -X stuff $'\n'
    screen -r ktproxy -p 0 -X stuff "./run.sh"
    screen -r ktproxy -p 0 -X stuff $'\n'
    sleep 1s
    echo "默认账号admin  默认密码admin123 默认端口16777"
    echo "已启动web后台 您可运行 screen -r ktproxy 查看程序输出"
}

uninstall() {
    read -p "是否确认删除KTProxy[yes/no]：" flag
    if [ -z $flag ]; then
        echo "输入错误" && exit 1
    else
        if [ "$flag" = "yes" -o "$flag" = "ye" -o "$flag" = "y" ]; then
            screen -X -S ktproxy quit
            rm -rf /root/kt_proxy
            echo "卸载KTProxy成功"
        fi
    fi
}

update() {
    if screen -list | grep -q "ktproxy"; then
        screen -X -S ktproxy quit
    fi
    rm -rf /root/kt_proxy/ktproxy
    echo "请选择v4还是v5版本"
    echo "  1、v0.0.4"
    echo "  2、v0.0.6"
    echo "  3、v0.0.7"
    read -p "$(echo -e "请输入[1-3]：")" choose
    case $choose in
    1)
        wget https://raw.githubusercontent.com/Clindassss/proxyrun/master/release/ktproxy_v0.0.4_linux -O /root/kt_proxy/ktproxy
        ;;
    2)
        wget https://raw.githubusercontent.com/Clindassss/proxyrun/master/release/ktproxy_v0.0.6_linux -O /root/kt_proxy/ktproxy
        ;;
    3)
        wget https://raw.githubusercontent.com/Clindassss/proxyrun/master/release/ktproxy_v0.0.7_darwin -O /root/kt_proxy/ktproxy
        ;;
    *)
        echo "请输入正确的数字"
        ;;
    esac
    chmod 777 /root/kt_proxy/ktproxy

#    echo "群友制作 官方地址https://github.com/kt007007/KTMinerProxy"
#    read -p "是否删除配置文件[yes/no]：" flag
#    if [ -z $flag ]; then
#        echo "输入错误" && exit 1
#    else
#        if [ "$flag" = "yes" -o "$flag" = "ye" -o "$flag" = "y" ]; then
#            rm -rf /root/kt_proxy/config.yml
#            echo "删除配置文件成功"
#        fi
#    fi
    screen -dmS ktproxy
    sleep 0.2s
    screen -r ktproxy -p 0 -X stuff "cd /root/kt_proxy"
    screen -r ktproxy -p 0 -X stuff $'\n'
    screen -r ktproxy -p 0 -X stuff "./run.sh"
    screen -r ktproxy -p 0 -X stuff $'\n'

    sleep 1s
    echo "官方github地址：https://github.com/kt007007/KTMinerProxy"
    echo "您可运行 screen -r ktproxy 查看程序输出"
}

start() {
    if screen -list | grep -q "ktproxy"; then
        echo -e "KTProxy已启动,请勿重复启动" && exit 1
    fi
    screen -dmS ktproxy
    sleep 0.2s
    screen -r ktproxy -p 0 -X stuff "cd /root/kt_proxy"
    screen -r ktproxy -p 0 -X stuff $'\n'
    screen -r ktproxy -p 0 -X stuff "./run.sh"
    screen -r ktproxy -p 0 -X stuff $'\n'

    echo "KTProxy已启动"
    echo "您可以使用指令screen -r ktproxy查看程序输出"
}

restart() {
    if screen -list | grep -q "ktproxy"; then
        screen -X -S ktproxy quit
    fi
    screen -dmS ktproxy
    sleep 0.2s
    screen -r ktproxy -p 0 -X stuff "cd /root/kt_proxy"
    screen -r ktproxy -p 0 -X stuff $'\n'
    screen -r ktproxy -p 0 -X stuff "./run.sh"
    screen -r ktproxy -p 0 -X stuff $'\n'

    echo "KTProxy 重新启动成功"
    echo "您可运行 screen -r ktproxy 查看程序输出"
}

stop() {
    if screen -list | grep -q "ktproxy"; then
        screen -X -S ktproxy quit
    fi
    echo "KTProxy 已停止"
}

change_limit(){
    num="n"
    if [ $(grep -c "root soft nofile" /etc/security/limits.conf) -eq '0' ]; then
        echo "root soft nofile 102400" >>/etc/security/limits.conf
        num="y"
    fi

    if [[ "$num" = "y" ]]; then
        echo "连接数限制已修改为102400,重启服务器后生效"
    else
        echo -n "当前连接数限制："
        ulimit -n
    fi
}

check_limit(){
    echo -n "当前连接数限制："
    ulimit -n
}

echo "======================================================="
echo "ktProxy 一键工具"
echo "  1、安装(默认安装到/root/kt_proxy)"
echo "  2、卸载"
echo "  3、更新"
echo "  4、启动"
echo "  5、重启"
echo "  6、停止"
echo "  7、解除linux系统连接数限制(需要重启服务器生效)"
echo "  8、查看当前系统连接数限制"
#echo "  9、配置开机启动"
echo "======================================================="
read -p "$(echo -e "请选择[1-8]：")" choose
case $choose in
1)
    install
    ;;
2)
    uninstall
    ;;
3)
    update
    ;;
4)
    start
    ;;
5)
    restart
    ;;
6)
    stop
    ;;
7)
    change_limit
    ;;
8)
    check_limit
    ;;
*)
    echo "输入错误请重新输入！"
    ;;
esac
