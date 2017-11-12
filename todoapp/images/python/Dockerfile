FROM	rhel7.2
MAINTAINER Jim Rigsbee <jrigsbee@redhat.com>

ENV 	PYTHON_VERSION 3.4
ENV	HOME /opt/app-root/src
ENV	PATH .local/bin/:$PATH:/opt/rh/rh-python34/root/usr/bin

ADD training.repo /etc/yum.repos.d/training.repo
RUN	yum update -y && \
	yum install -y --setopt=tsflags=nodocs \
bsdtar \
iputils \
less \
libcurl-devel \
libxml2-devel \
libxslt-devel \
mariadb-devel \
mariadb-libs \
net-tools \
nmap-ncat \
openssl-devel \
postgresql-devel \
procps-ng \
rh-python34 \
rh-python34-python-devel \
rh-python34-python-setuptools \
rh-python34-python-pip \
scl-utils \
sqlite-devel \
tar \
traceroute \
unzip \
wget \
which \
zlib-devel && \
    	yum clean all -y

RUN	mkdir -p /opt/app-root && \
  	groupadd -r appuser -f -g 1001 && \
  	useradd -u 1001 -r -g appuser -m -d ${HOME} -s /sbin/nologin \
-c "Application User" appuser
ADD	./enable-python34.sh /etc/profile.d/
COPY    ./contrib/ /opt/app-root/
ADD	./compile.sh ${HOME}/
RUN  	chown -R appuser:appuser /opt/app-root && \
	chmod -R og+rwx /opt/app-root

WORKDIR	${HOME}

ONBUILD COPY ./build/ ${HOME}/
ONBUILD RUN ./compile.sh

CMD	["echo", "You must create your own container with your app source code."]
