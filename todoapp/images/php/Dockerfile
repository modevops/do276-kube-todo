FROM	rhel7.2
MAINTAINER Jim Rigsbee <jrigsbee@redhat.com>

ENV 	PHP_VERSION 5.6 
ENV	HOME /opt/app-root/src
ENV	PATH=$PATH:/opt/rh/rh-php56/root/usr/bin

ADD training.repo /etc/yum.repos.d/training.repo
RUN	yum update -y && \
	yum install -y --setopt=tsflags=nodocs \
bsdtar \
httpd24 \
less \
libcurl-devel \
libxml2-devel \
libxslt-devel \
mariadb-devel \
mariadb-libs \
openssl-devel \
postgresql-devel \
procps-ng \
rh-php56 \
rh-php56-php \
rh-php56-php-mysqlnd \
rh-php56-php-pgsql \
rh-php56-php-bcmath \
rh-php56-php-gd \
rh-php56-php-intl \
rh-php56-php-ldap \
rh-php56-php-mbstring \
rh-php56-php-pdo \
rh-php56-php-pecl-memcache \
rh-php56-php-process \
rh-php56-php-soap \
rh-php56-php-opcache \
rh-php56-php-xml \
rh-php56-php-pecl-xdebug \
scl-utils \
sqlite-devel \
tar \
unzip \
wget \
which \
zlib-devel && \
    	yum clean all -y

RUN	mkdir -p /opt/app-root && \
  	groupadd -r appuser -f -g 1001 && \
  	useradd -u 1001 -r -g appuser -m -d ${HOME} -s /sbin/nologin \
-c "Application User" appuser && \
  	chown -R appuser:appuser /opt/app-root && \
	chmod -R 755 /opt/app-root
ADD	./enable-php56.sh /etc/profile.d/
COPY	./contrib/ /opt/app-root/
RUN 	sed -i -f /opt/app-root/etc/httpdconf.sed /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf && \
    	sed -i '/php_value session.save_path/d' /opt/rh/httpd24/root/etc/httpd/conf.d/rh-php56-php.conf && \
    	head -n151 /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf | tail -n1 | grep "AllowOverride All" || exit && \
    	mkdir /tmp/sessions && \
    	chmod -R a+rwx /etc/opt/rh/rh-php56 && \
    	chmod -R a+rwx /opt/rh/httpd24/root/var/run/httpd && \
    	chmod -R a+rwx /tmp/sessions && \
    	chown -R appuser:appuser /opt/app-root /tmp/sessions

USER	appuser
WORKDIR	${HOME}

EXPOSE 8080

ADD	./compile.sh ./
ONBUILD COPY run.sh ./build ${HOME}/
ONBUILD RUN ./compile.sh 

CMD	["echo", "You must create your own container with your app source code."]
