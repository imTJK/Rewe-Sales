import sys, os
sys.path.append(os.path.dirname(__file__))


from flaskApi import app, db
from flaskApi.models import User, Zipcode, Rewe, Product, Discount

from flask import Flask, request, jsonify
import sqlite3

### local functions

## SQL ##

# temporary SQL #






### routing
@app.route('/', methods=['GET'])
def index():
    if 'id' in request.args:
        return str(request.args.get('id'))
    else:
        return 'Thats some whack stuff'


@app.route('/user-test', methods=['GET'])
def test_user():
    u = User(username='test', email='john@sda.com')
    db.session.add(u)
    db.session.commit()

    return str(u.username)