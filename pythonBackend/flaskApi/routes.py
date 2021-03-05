import sys, os
sys.path.append(os.path.dirname(__file__))

import json

from flaskApi import app, db
from flaskApi.models import User, Zipcode, Rewe, Product, Discount

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

@app.route('/products', methods=['GET'])
def products_json():
    products_dict = []
    if 'category' in request.args:
        products = Product.query.filter_by(category=request.args['category']).all()
    else:
        products = Product.query.all()

    for product in products:
        products_dict.append(
            {
                'id' : product.id,
                'name' : product.name,
                'price' : product.price,
                'img_src' : product.img_src,
                'category' : product.category,
                'on_sale' : product.on_sale
            }
        )

    return jsonify(products_dict)
           
    



