#!/bin/sh

if [ -f /config/alist-tvbox/proxy.txt ]; then
  proxy_url=$(head -n1 /config/alist-tvbox/proxy.txt)
  export HTTP_PROXY=$proxy_url
  export HTTPS_PROXY=$proxy_url
  export no_proxy="*.aliyundrive.com"
fi

chmod a+x /init.sh /index.sh

if [ ! -d /config/alist-tvbox/log ]; then
  mkdir -p /config/alist-tvbox/log
fi
ln -sf /config/alist-tvbox/log /opt/atv/log

/init.sh 2>&1 | tee /opt/atv/log/init.log 2>&1

/bin/busybox-extras httpd -p "$1" -h /www
/usr/sbin/nginx
shift

./atv "$@"
