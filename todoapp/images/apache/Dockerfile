# we expect rhel7.2 but use rhel7 to match the RHCSL MySQL image
FROM	rhel7.2

MAINTAINER Jim Rigsbee <jrigsbee@redhat.com>

ENV	HOME /var/www/html

ADD training.repo /etc/yum.repos.d/training.repo
RUN	yum update -y && \
	yum install -y --setopt=tsflags=nodocs \
httpd \
less \
openssl-devel \
procps-ng \
tar \
unzip \
wget \
which && \
    	yum clean all -y

EXPOSE  80

ONBUILD	COPY ./src/ ${HOME}/ 

CMD	["httpd", "-D", "FOREGROUND"]
