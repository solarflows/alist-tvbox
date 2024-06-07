LOCAL="0.0"
if [ -f /config/alist-tvbox/atv/movie_version ]; then
  LOCAL=$(head -n 1 </config/alist-tvbox/atv/movie_version)
fi

echo "local movie data version: ${LOCAL}, remote version: ${REMOTE}"
if [ "$LOCAL" = "$1" ]; then
  exit
fi

echo "download diff.zip" && \
wget http://data.har01d.cn/diff.zip -O diff.zip && \
unzip -q -o diff.zip -d /config/alist-tvbox/atv/ && \
cat /config/alist-tvbox/atv/movie_version && \
rm -f /tmp/diff.zip
