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

@app.route('/products/<int:page>/<int:amount>', methods=['GET', "POST"])
def products_json(page, amount):
    products_dict = {
        "products" : []
    }
    if 'category' in request.args:
        products = Product.query.filter_by(category=request.args['category']).all()
    else:
        products = Product.query.all()

    for i in range(page*amount, (page+1)*amount):
        products_dict["products"].append(
            {   
                'id' : products[i].id,
                'name' : products[i].name,
                'price' : products[i].price,
                'img_src' : products[i].img_src,
                'category' : products[i].category,
                'on_sale' : products[i].on_sale
            }
        )

    return json.dumps(products_dict)
           
    



