from flask import Flask, jsonify
from flask import g
from flask import Response
from flask import request
from flask import abort
from flask import render_template
import json
import mysql.connector
import os
from db import db
from mysql.connector import errorcode

app = Flask(__name__)


@app.before_request
def db_connect():
    db_config = db()

    try:
        g.cnx = mysql.connector.connect(user=db_config.username,
                                        password=db_config.password,
                                        host=db_config.host,
                                        port=db_config.port,
                                        database=db_config.name)
        g.cursor = g.cnx.cursor()
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your user name or password")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")
        else:
            print(err)
    else:
        print("Database connected fine")


@app.after_request
def db_disconnect(response):
    g.cursor.close()
    g.cnx.close()
    return response


def query_db(query, args=(), one=False):
    try:
        g.cursor.execute(query, args)
        rv = [dict((g.cursor.description[idx][0], value)
                   for idx, value in enumerate(row)) for row in g.cursor.fetchall()]
    except mysql.connector.Error as err:
        print("Database Error:")
        print(err)
    else:
        return (rv[0] if rv else None) if one else rv


def count_items():
    query = "SELECT COUNT(*) FROM Item"
    g.cursor.execute(query)
    data = g.cursor.fetchone()[0]
    return data


def find_items(start_position, max_results, sort_fields, sort_directions):
    query = "SELECT * FROM Item ORDER BY Item." + sort_fields + " " + sort_directions + " limit " + \
            str(start_position) + "," + str(max_results)

    result = query_db(query)
    return result


@app.route("/todo/", methods=['GET', 'POST'])
def index():
    return render_template("index.html")


@app.route("/todo/api/items", methods=['GET'])
def list_items():
    page_size = 10
    page = request.args.get('page')
    if page is None:
        page = 1
    sort_fields = request.args.get('sortFields')
    sort_directions = request.args.get('sortDirections')
    start = (int(page) - 1) * page_size
    result = find_items(start, page_size, sort_fields, sort_directions)
    for dict in result:
        if dict['done']:
            dict['done'] = True
        else:
            dict['done'] = False
    full_response = ({
        "currentPage": page,
        "list": result,
        "pageSize": page_size,
        "sortDirections": sort_directions,
        "sortFields": sort_fields,
        "totalResults": count_items()
    })
    json_resp = json.dumps(full_response)
    print(json_resp)
    return Response(json_resp, status=200, mimetype='application/json')


@app.route("/todo/api/items/<id>", methods=['DELETE'])
def delete_item(id):
    query = "DELETE FROM Item WHERE Item.id = " + id
    g.cursor.execute(query)
    g.cnx.commit()
    resp = Response("Deleted", status=200, mimetype='application/json')
    return resp


@app.route("/todo/api/items/<id>", methods=['GET'])
def get_item(id):
    result = query_db("SELECT * FROM Item WHERE Item.id = " + id)
    dict = result[0]
    if dict['done']:
        dict['done'] = True
    else:
        dict['done'] = False
    data = json.dumps(dict)
    resp = Response(data, status=200, mimetype='application/json')
    return resp


@app.route("/todo/api/items", methods=['POST'])
def save_item():
    the_request = request.get_json(force=True)
    if not the_request:
        abort(400)
    item = {
        'id': the_request.get('id', ""),
        'description': the_request.get('description', ""),
        'done': the_request.get('done', "")
    }

    if not item.get('id', ""):
        query = "INSERT INTO Item(description, done) VALUES(%s,%s)"
    else:
        query = "UPDATE Item SET description = %s, done = %s WHERE Item.id = " + str(item.get('id', ""))
    args = (item.get('description', ""), item.get('done', ""))
    g.cursor.execute(query, args)
    g.cnx.commit()
    data = json.dumps(item)
    resp = Response(data, status=201, mimetype='application/json')
    return resp


if __name__ == "__main__":
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port)
