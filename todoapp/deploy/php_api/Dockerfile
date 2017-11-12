FROM	do276/php
MAINTAINER Jim Rigsbee <jrigsbee@redhat.com>
# exposed port is hardcoded on base image Apache config
USER appuser

#RUN ls -l . ; mkdir -p todo/api ; echo "mkdir status: $?" ; \
#    ln -s composer.json composer.lock vendor dao  index.php  model  service todo/api ; \
#    echo "ln status: $?" ; ls -l todo/api

#RUN ./compile.sh

CMD	["scl","enable","httpd24","./run.sh"]
