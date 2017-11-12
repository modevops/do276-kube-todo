import os


class db:
    username = os.environ.get("MYSQL_ENV_MYSQL_USER")
    password = os.environ.get("MYSQL_ENV_MYSQL_PASSWORD")
    host = os.environ.get("MYSQL_PORT_3306_TCP_ADDR")
    port = os.environ.get("MYSQL_PORT_3306_TCP_PORT")
    name = os.environ.get("MYSQL_ENV_MYSQL_DATABASE")

