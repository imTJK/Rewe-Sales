import sys, os
sys.path.append(os.path.dirname(__file__))

import json

from flaskApi import app, db
from flaskApi.models import User, Rewe, Product, Discount, Prices

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
        Product.category == request.args.get('category') if 'category' in request.args else True
        )
    ).all()

    for i in range(page*amount, (page+1)*amount):
        if i == len(products) - 1:
            break
        price = Prices.query.filter_by(id = products[i].id).first()
        if price != None:
           products_dict['products'].append(
                    {
                        'id' : products[i].id,
                        'name' : products[i].name,
                        'price' : price.price,
                        'img_src' : products[i].img_src,
                        'category' : products[i].category,
                        'on_sale_in' : products[i].on_sale_in
                    })

    return json.dumps(products_dict)
           

@app.route('/addUser', methods=['POST'])
def add_user():
    if request.is_json():
        content = request.get_json()

        return 'JSON posted: {}'.format(str(json.loads(content)))