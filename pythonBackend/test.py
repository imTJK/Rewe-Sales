
from flaskApi import app, db
from flaskApi.models import User, Zipcode, Rewe, Product

from webCrawler.crawler import ReweCrawler

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
    csv_to_db()