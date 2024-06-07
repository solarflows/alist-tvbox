#!/bin/sh

restore_database() {
  if [ -f "/config/alist-tvbox/database.zip" ]; then
    echo "=== restore database ==="
    rm -f /config/alist-tvbox/atv.mv.db /config/alist-tvbox/atv.trace.db
    java -cp /opt/atv/BOOT-INF/lib/h2-*.jar org.h2.tools.RunScript -url jdbc:h2:/config/alist-tvbox/atv -user sa -password password -script /config/alist-tvbox/database.zip -options compression zip
    rm -f /config/alist-tvbox/database.zip
  fi
}

init() {
  mkdir -p /var/lib/pxg /www/cgi-bin /config/alist-tvbox/atv /config/alist-tvbox/index /config/alist-tvbox/backup
  if [ -d /index ]; then
    rm -rf /index
  fi
  ln -sf /config/alist-tvbox/index /
  ln -sf /config/alist-tvbox/config .
  cd /var/lib/pxg
  unzip -q /var/lib/data.zip
  mv search /www/cgi-bin/search
  mv sou /www/cgi-bin/sou
  mv header.html /www/cgi-bin/header.html
  mv nginx.conf /etc/nginx/http.d/default.conf

  mv mobi.tgz /www/mobi.tgz
  cd /www/
  tar zxf mobi.tgz

  sed -i 's/127.0.0.1/0.0.0.0/' /opt/alist/data/config.json

  sqlite3 /opt/alist/data/data.db ".read /alist.sql"

  wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppelWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36" -T 30 -t 2 http://docker.xiaoya.pro/update/tvbox.zip -O tvbox.zip ||
  wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppelWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36" --header="Host:docker.xiaoya.pro" -T 30 -t 2 http://104.21.17.247/update/tvbox.zip -O tvbox.zip || \
  wget -T 30 -t 2 https://github.com/xiaoyaliu00/data/raw/main/tvbox.zip -O tvbox.zip || \
  wget -T 30 -t 2 http://data.har01d.cn/tvbox.zip -O tvbox.zip || \
  cp /tvbox.zip ./

  unzip -q -o tvbox.zip

  rm -f mobi.tgz tvbox.zip index.zip index.txt version.txt update.zip
}

echo "Install mode: $INSTALL"
cat data/app_version
date
uname -mor

restore_database
if [ -f /opt/alist/data/data.db ]; then
  echo "已经初始化成功"
else
  init
fi

if [ ! -d /www/cat ]; then
  mkdir /www/cat
  unzip -q -o /cat.zip -d /www/cat
fi
[ -d /config/alist-tvbox/cat ] && cp -r /config/alist-tvbox/cat/* /www/cat/

if [ ! -d /www/pg ]; then
  mkdir /www/pg
  unzip -q -o /pg.zip -d /www/pg
fi
[ -d /config/alist-tvbox/pg ] && cp -r /config/alist-tvbox/pg/* /www/pg/
