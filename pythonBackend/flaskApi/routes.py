import sys, os
sys.path.append(os.path.dirname(__file__))

import json

from flask import Flask, request, jsonify

from flaskApi import app, db
from flaskApi.models import User, Rewe, Product
from werkzeug.security import check_password_hash

from sqlalchemy import and_, or_
import sqlite3
import datetime

### local functions ###

## SQL ##

# temporary SQL #

### routing ###
@app.route('/', methods=['GET'])
def index():
    if 'id' in request.args:
        return str(request.args.get('id'))
    else:
        return 'Thats some whack stuff'


@app.route('/products/<int:page>/<int:amount>', methods=['GET', "POST"])
def get_sales(page, amount):
    if 'name' not in request.args:
        return 'invalid Query'

    products_dict = {
        "products" : []
    }

    products = Product.query.filter(
        and_(
        Product.name.contains(request.args.get('name')),
        Product.category == (request.args.get('category') if 'category' in request.args else ""),
        Product.on_sale == (request.args.get('on_sale') if 'on_sale' in request.args else False)
        )
    ).all()

    for i in range(page*amount, (page+1)*amount):
        if i == len(products) - 1:
            break
        products_dict['products'].append(
                {
                    'id' : products[i].id,
                    'name' : products[i].name,
                    'price' : products[i].price,
                    'img_src' : products[i].img_src,
                    'category' : products[i].category,
                    'on_sale' : products[i].on_sale
                })

    return jsonify(products_dict)


@app.route('/login', methods=['POST'])
def login_user():
    def get_user(name_email):
        return User.query.filter(
            or_(
                User.name == name_email,
                User.email == name_email,
            )
        ).first()

    if request.is_json():
        content = request.get_json()
        if content['login_success'] != None:
            _user = get_user(content['name_email'])
            if _user != None:
                return json.dump({"password_hash" : _user.password_hash})
            else: return "Invalid Query"

        else:
            _user = get_user(content['name_email'])
            _user.last_login_at = datetime.datetime.utcnow()
            return json.dumps({
                "id" : _user.id,
                "name" : _user.name,
                "email" : _user.email
            })
        
    return "Invalid Query"


        




@app.route('/register', methods=['POST'])
def register_user():
    if request.is_json():
        content = request.get_json()
        
        if User.query.filter_by(email = content['email']).first() != None:
            return(str(json.dump({"Error" : "This Email is already in use"})))

        elif User.query.filter_by(name = content['name']).first() != None:
            return(str(json.dump({"Error" : "This Username is already in use"})))

        db.session.add(User(
            name = content['name'],
            email = content['email'],
            password_hash = content['passwort'],
            plz = ""
        ))
        db.session.commit()

    return(str(json.dumps({"Error" : "No Json posted"})))
    
