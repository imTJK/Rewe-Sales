
from flaskApi import app, db
from flaskApi.models import User, Zipcode, Rewe, Product
import hashlib
from werkzeug.security import generate_password_hash, check_password_hash
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
    print(generate_password_hash("Hello"))
    print(check_password_hash(("pbkdf2:sha256:150000$ISxC3oIG$" + "185f8db32271fe25f561a6fc938b2e264306ec304eda518007d1764826381969"),"Hello" ))
                            
                            