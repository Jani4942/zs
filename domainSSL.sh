#!/bin/sh

read -p "请输入域名:" domain && cd /tmp
if [ ! -f "lego_v3.8.0_freebsd_amd64.tar.gz" ]; then
  wget https://cdn.jsdelivr.net/gh/moeik/domainSSL@master/lego/lego_v3.8.0_linux_amd64.tar.gz
fi
tar zxvf lego_v3.8.0_linux_amd64.tar.gz
chmod 755 *
service nginx stop
./lego --email="admin@$domain" --domains="$domain" --http -a run
service nginx start
if ls ./.lego/certificates | grep "$domain"
    then
    mkdir -p /home/ssl/$domain
    cp ./.lego/certificates/$domain.crt /etc/x-ui/server.crt
    cp ./.lego/certificates/$domain.key /etc/x-ui/server.key
    path="/home/ssl/$domain/"
    echo '证书签发成功，证书文件保存在/etc/x-ui/。'
else
    echo '证书签发失败，请检查80端口是否被占用，域名解析或者输入域名是否正确。'
fi
