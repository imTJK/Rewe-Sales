
from flaskApi import app, db
from flaskApi.models import User, Zipcode, Rewe, Product
import hashlib
from werkzeug.security import generate_password_hash, check_password_hash
from webCrawler.crawler import ReweCrawler
import json

from flask import Flask, request, jsonify

from werkzeug.security import check_password_hash

from sqlalchemy import and_, or_
import sqlite3
import datetime

import csv
import pandas as pd

def csv_to_db():
    fields = ['PLZ', 'Stadtteil_Name']
    df = pd.read_csv(r'pythonBackend\rewe.csv', skipinitialspace=True, usecols=fields)

    for plz, stadtteil_name in df.values:
        z = Zipcode(
            id = plz,
            district = stadtteil_name
        )
        db.session.add(z)
    db.session.commit()


if __name__ == "__main__":
    products = Product.query.filter(
        and_(
        Product.name.contains("wurst"),
        Product.category == ("nahrungsmittel"),
        Product.on_sale == (False),
        Product.rewe_plz == 28213
        )
    ).all()
    print(products)