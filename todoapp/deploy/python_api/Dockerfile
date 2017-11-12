FROM	do276/python
RUN     source /etc/profile.d/enable-python34.sh && pip install https://cdn.mysql.com/Downloads/Connector-Python/mysql-connector-python-2.0.4.tar.gz
EXPOSE	8080
USER	appuser

ADD	./run.sh ./

CMD	["./run.sh"]
