import sys, os
sys.path.append(os.path.dirname(__file__))

import json

from flaskApi import app, db
from flaskApi.models import User, Rewe, Product

from sqlalchemy import and_

from flask import Flask, request, jsonify
import sqlite3

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
        Product.category == request.args.get('category') if 'category' in request.args else True,
        Product.on_sale == request.args.get('on_sale') if 'on_sale' in request.args else False
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
                    'on_sale_in' : products[i].on_sale_in
                })

    return json.dumps(products_dict)


@app.route('/login', methods=['POST'])
def login_user():
    if request.is_json():
        pass


@app.route('/register', methods=['POST'])
def register_user():
    if request.is_json():
        content = request.get_json()
        
        if User.query.filter_by(email = content['email']).first() != None:
            return(str(json.dump({"Error" : "This Email is already in use"})))

        elif User.query.filter_by(name = content['name']).first() != None:
            return(str(json.dump({"Error" : "This Username is already in use"})))

        


        return 'JSON posted: {}'.format(str(json.loads(content)))

    return(str(json.loads({"Error" : "No Json posted"})))
    

    