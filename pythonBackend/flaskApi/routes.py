import sys, os
sys.path.append(os.path.dirname(__file__))

import json

from flaskApi import app, db
from flaskApi.models import User, Rewe, Product, Discount, Prices

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
    if 'plz' not in request.args or 'name' not in request.args:
        return 'invalid Query'

    products_dict = {
        "products" : []
    }
    prices = Prices.query.filter(Prices.rewe_plz.like(request.args['plz']))

    if 'category' in request.args:
        products = Product.query.filter(Product.name.contains(request.args['name'])).filter(Product.category.like(request.args['category']))
    else:
        products = Product.query.filter(Product.name.contains(request.args['name']))
  

    for product in products[page*amount: (page+1)*amount]:
        for price in prices:
            if price.product_id == product.id:
                products_dict['products'].append(
                    {
                        'id' : product.id,
                        'name' : product.name,
                        'price' : price.price,
                        'img_src' : product.img_src,
                        'category' : product.category,
                        'on_sale_in' : product.on_sale_in
                    }
                )
    if len(products_dict['products'] == 0):
        return 'No results for: query = {}, plz = {}, category = {}'.format(request.args['name'], request.args['plz'], request.args['category'] if 'category' in request.args else "")
    
    return json.dumps(products_dict)
           

@app.route('/addUser', methods=['POST'])
def add_user():
    if request.is_json():
        content = request.get_json()

        return 'JSON posted: {}'.format(str(json.loads(content)))