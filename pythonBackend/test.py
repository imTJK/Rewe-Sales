
from flaskApi import app, db
from flaskApi.models import User, Zipcode, Rewe, Product, Discount

from webCrawler.crawler import ReweCrawler

import csv
import pandas as pd

def csv_to_db():
    fields = ['PLZ', 'Stadtteil_Name']
    df = pd.read_csv(r'pythonBackend\rewe.csv', skipinitialspace=True, usecols=fields)
    mydict = {}
    for PLZ, Stadtteil_Name in df.values:
        z = Zipcode(
            id = PLZ,
            district = Stadtteil_Name
        )
        db.session.add(z)
    db.session.commit()


