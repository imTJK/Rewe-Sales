
from flaskApi import app, db
from flaskApi.models import User, Zipcode, Rewe, Product, Discount

from webCrawler.crawler import ReweCrawler

import csv
import pandas as pd

def start_crawler():
    url = "https://shop.rewe.de"
    crawler = ReweCrawler(url)

    crawler.start_crawl()
    for category, products in crawler.products.items():
        for product in products:
            p = Product(
                name = product['name'],
                price = product['price'],
                img_src = product['img_url'],
                on_sale = product['on_sale'],
                category = category
            )
            db.session.add(p)
    db.session.commit()

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
    
if __name__ == "__main__":
    url = "https://shop.rewe.de"
    crawler = ReweCrawler(url)

    crawler.start_crawl(option="rewes")
    


        