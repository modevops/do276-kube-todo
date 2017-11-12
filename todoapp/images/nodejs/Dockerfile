FROM	rhel7.2
MAINTAINER Jim Rigsbee <jrigsbee@redhat.com>

ENV 	NODEJS_VERSION 0.10 
ENV	HOME /opt/app-root/src

ADD training.repo /etc/yum.repos.d/training.repo
RUN	yum update -y && \
	yum install -y --setopt=tsflags=nodocs \
bsdtar \
less \
libcurl-devel \
libxml2-devel \
libxslt-devel \
mariadb-devel \
mariadb-libs \
nodejs010 \
openssl-devel \
postgresql-devel \
procps-ng \
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
ADD	./enable-nodejs010.sh /etc/profile.d/

USER	appuser
WORKDIR	${HOME}


ONBUILD COPY run.sh build ${HOME}/
ONBUILD RUN scl enable nodejs010 'npm install'

CMD	["echo", "You must create your own container from this one."]
