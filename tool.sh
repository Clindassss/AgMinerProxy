#!/bin/bash
[[ $(id -u) != 0 ]] && echo -e "��ʹ��rootȨ�����а�װ�ű�" && exit 1

cmd="apt-get"
if [[ $(command -v apt-get) || $(command -v yum) ]] && [[ $(command -v systemctl) ]]; then
    if [[ $(command -v yum) ]]; then
        cmd="yum"
    fi
else
    echo "�˽ű���֧�ָ�ϵͳ" && exit 1
fi

install() {
    if [ -d "/root/kt_proxy" ]; then
        echo -e "���Ѱ�װ�˸����,���ȷ��û�а�װ,������rm -rf /root/kt_proxy" && exit 1
    fi
    if screen -list | grep -q "ktproxy"; then
        echo -e "��⵽����������KTProxy,��رպ��ٰ�װ" && exit 1
    fi

    $cmd update -y
    $cmd install curl wget screen -y
    mkdir /root/kt_proxy

    echo "��ѡ������汾"
    echo "  1��v0.0.4"
    echo "  2��v0.0.6"
    echo "  3��v0.0.6���޸��棩"
    read -p "$(echo -e "������[1-3]��")" choose
    case $choose in
    1)
        wget https://raw.githubusercontent.com/Clindassss/proxyrun/master/release/ktproxy_v0.0.4_linux -O /root/kt_proxy/ktproxy
        ;;
    2)
        wget https://raw.githubusercontent.com/Clindassss/proxyrun/master/release/ktproxy_v0.0.6_linux -O /root/kt_proxy/ktproxy
        ;;
    3)
        wget https://raw.githubusercontent.com/Clindassss/proxyrun/master/release/ktproxy_v0.0.6.1_linux -O /root/kt_proxy/ktproxy
        ;;
    *)
        echo "��������ȷ������"
        ;;
    esac
    chmod 777 /root/kt_proxy/ktproxy

    wget https://raw.githubusercontent.com/Clindassss/proxyrun/main/run.sh -O /root/kt_proxy/run.sh
    chmod 777 /root/kt_proxy/run.sh
    echo "���û�б�����װ�ɹ�"
    echo "��������..."
    screen -dmS ktproxy
    sleep 0.2s
    screen -r ktproxy -p 0 -X stuff "cd /root/kt_proxy"
    screen -r ktproxy -p 0 -X stuff $'\n'
    screen -r ktproxy -p 0 -X stuff "./run.sh"
    screen -r ktproxy -p 0 -X stuff $'\n'
    sleep 1s
    cat /root/miner_proxy/configV6.yml
    echo "Ĭ���˺�admin  Ĭ������admin123 Ĭ�϶˿�16777"
    echo "������web��̨ �������� screen -r ktproxy �鿴�������"
}

uninstall() {
    read -p "�Ƿ�ȷ��ɾ��KTProxy[yes/no]��" flag
    if [ -z $flag ]; then
        echo "�������" && exit 1
    else
        if [ "$flag" = "yes" -o "$flag" = "ye" -o "$flag" = "y" ]; then
            screen -X -S ktproxy quit
            rm -rf /root/kt_proxy
            echo "ж��KTProxy�ɹ�"
        fi
    fi
}

update() {
    if screen -list | grep -q "ktproxy"; then
        screen -X -S ktproxy quit
    fi
    rm -rf /root/kt_proxy/ktproxy
    echo "��ѡ��v4����v5�汾"
    echo "  1��v0.0.4"
    echo "  2��v0.0.6"
    echo "  3��v0.0.6���޸��棩"
    read -p "$(echo -e "������[1-3]��")" choose
    case $choose in
    1)
        wget https://raw.githubusercontent.com/Clindassss/proxyrun/master/release/ktproxy_v0.0.4_linux -O /root/kt_proxy/ktproxy
        ;;
    2)
        wget https://raw.githubusercontent.com/Clindassss/proxyrun/master/release/ktproxy_v0.0.6_linux -O /root/kt_proxy/ktproxy
        ;;
    3)
        wget https://raw.githubusercontent.com/Clindassss/proxyrun/master/release/ktproxy_v0.0.6.1_linux -O /root/kt_proxy/ktproxy
        ;;
    *)
        echo "��������ȷ������"
        ;;
    esac
    chmod 777 /root/kt_proxy/ktproxy

#    echo "Ⱥ������ �ٷ���ַhttps://github.com/kt007007/KTMinerProxy"
#    read -p "�Ƿ�ɾ�������ļ�[yes/no]��" flag
#    if [ -z $flag ]; then
#        echo "�������" && exit 1
#    else
#        if [ "$flag" = "yes" -o "$flag" = "ye" -o "$flag" = "y" ]; then
#            rm -rf /root/kt_proxy/config.yml
#            echo "ɾ�������ļ��ɹ�"
#        fi
#    fi
    screen -dmS ktproxy
    sleep 0.2s
    screen -r ktproxy -p 0 -X stuff "cd /root/kt_proxy"
    screen -r ktproxy -p 0 -X stuff $'\n'
    screen -r ktproxy -p 0 -X stuff "./run.sh"
    screen -r ktproxy -p 0 -X stuff $'\n'

    sleep 1s
    cat /root/miner_proxy/configV6.yml
    echo "�ٷ�github��ַ��https://github.com/kt007007/KTMinerProxy"
    echo "�������� screen -r ktproxy �鿴�������"
}

start() {
    if screen -list | grep -q "ktproxy"; then
        echo -e "KTProxy������,�����ظ�����" && exit 1
    fi
    screen -dmS ktproxy
    sleep 0.2s
    screen -r ktproxy -p 0 -X stuff "cd /root/kt_proxy"
    screen -r ktproxy -p 0 -X stuff $'\n'
    screen -r ktproxy -p 0 -X stuff "./run.sh"
    screen -r ktproxy -p 0 -X stuff $'\n'

    echo "KTProxy������"
    echo "������ʹ��ָ��screen -r ktproxy�鿴�������"
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

    echo "KTProxy ���������ɹ�"
    echo "�������� screen -r ktproxy �鿴�������"
}

stop() {
    if screen -list | grep -q "ktproxy"; then
        screen -X -S minerProxy quit
    fi
    echo "KTProxy ��ֹͣ"
}

change_limit(){
    num="n"
    if [ $(grep -c "root soft nofile" /etc/security/limits.conf) -eq '0' ]; then
        echo "root soft nofile 102400" >>/etc/security/limits.conf
        num="y"
    fi

    if [[ "$num" = "y" ]]; then
        echo "�������������޸�Ϊ102400,��������������Ч"
    else
        echo -n "��ǰ���������ƣ�"
        ulimit -n
    fi
}

check_limit(){
    echo -n "��ǰ���������ƣ�"
    ulimit -n
}

echo "======================================================="
echo "ktProxy һ������"
echo "  1����װ(Ĭ�ϰ�װ��/root/kt_proxy)"
echo "  2��ж��"
echo "  3������"
echo "  4������"
echo "  5������"
echo "  6��ֹͣ"
echo "  7�����linuxϵͳ����������(��Ҫ������������Ч)"
echo "  8���鿴��ǰϵͳ����������"
#echo "  9�����ÿ�������"
echo "======================================================="
read -p "$(echo -e "��ѡ��[1-8]��")" choose
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
    echo "����������������룡"
    ;;
esac