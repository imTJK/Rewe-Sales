# scraper-imports #
import requests
import cloudscraper
from bs4 import BeautifulSoup
import json

# python standard imports #
import time
import csv
import pandas as pd
import sys

from sqlalchemy import and_

# local imports # 
sys.path.insert(1, r'D:\Programmieren\Flutter\Rewe-Sales\pythonBackend')
from flaskApi import app, db
from flaskApi.models import User, Zipcode, Rewe, Product


class ReweCrawler(object):
    def __init__(self):
        super().__init__()
        self.options = json.load(open('options.json'))
        self.parser = 'html.parser'
        self.scraper = cloudscraper.create_scraper()
    

    def start_crawl(self, option : str):
        if option in self.options['functions']:
            #manual adjustment of pass-over variables necessary to crawl products
            getattr(self, self.options['functions'][option]['function'])(self.options['functions'][option]['url'])

    ### gets entirity of products excluding products from the on_sale category
    def crawl_products(self, url):
        Product.query.delete()
        db.session.commit()
        categories = self.get_category_links(url)[1:] 
        
        for plz, cookie in self.options['cookies'].items():
            self.scraper.cookies.set('marketsCookie', self.options['cookies'][plz])
            for category in categories:
                search_url = url + category
                while search_url:          
                    page_soup = BeautifulSoup(self.scraper.get(search_url).text, self.parser)
                    if len(page_soup.find_all("div", {"class" : "search-service-productDetailsWrapper"})) == 0:
                        break

                    for product in page_soup.find_all("div", {"class" : "search-service-productDetailsWrapper"}):
                        _product = Product(rewe_plz = plz, category = category.replace('c','').replace('/',''))
                        divs = product.findChildren('div')
                        price, amount, on_sale_in  = "", "", "" 

                        for div in divs:
                            if div.attrs and div.attrs['class'] == ['search-service-productPicture']:
                                _product.img_src = div.contents[0].contents[0].contents[3].attrs['src'].split('?')[0]
                            
                            if div.attrs and div.attrs['class'] == ['search-service-productDetails']:
                                _product.name = div.contents[1].contents[0].contents[0].text

                                if div.contents[4].next.attrs['class'] == ['search-service-productOffer']:
                                    _product.on_sale = True
                                    _product.price = float(div.contents[4].contents[0].contents[1].text.replace('€', '').replace("'",  '').replace(' ', '').replace(',', '.'))

                                else:
                                    _product.price = float(div.contents[4].contents[0].text.replace('€', '').replace("'",  '').replace(' ', '').replace(',', '.'))
                                if Product.query.filter(
                                    and_(
                                        Product.name == _product.name,
                                        Product.category == _product.category,
                                        Product.price == _product.price,
                                        Product.rewe_plz == _product.rewe_plz
                                    )
                                ).first() == None:
                                    db.session.add(_product)

                    if len(search_url.split('?')) > 1:
                        search_url = search_url.replace(str(search_url.split('page=')[1]), str(int(search_url.split('page=')[1]) + 1))
                    else:
                        search_url += '?page=2'        
        db.session.commit()
        self.scraper.cookies.set('marketsCookie', '')




    def crawl_rewes(self, url):  
        rewes = []
        for zipcode in Zipcode.query.all():
            time.sleep(1)
            content = self.scraper.get(url + str(zipcode.id)).text
            page_soup = BeautifulSoup(content, self.parser)

            if page_soup.contents[0] != '[]':
                try:
                    for rewe in json.loads(page_soup.contents[0]):
                        if rewe not in rewes:
                            rewes.append(rewe)
                        else:
                            print('duplicate')
                except Exception as e:
                    print(e)
        
        for rewe in rewes:
            db_rewe = Rewe(
                name = rewe['companyName'],
                adress = rewe['contactStreet'] + ' ' + rewe['contactHouseNumber'],
                plz = rewe['contactZipCode']
            )
            if Rewe.query.filter_by(adress=str(db_rewe.adress)).first() is None:
                db.session.add(db_rewe)
        db.session.commit()
            



    ### scrapes the Site for links to each category of Product ###
    def get_category_links(self, url):
        content = self.scraper.get(url).text
        page_soup = BeautifulSoup(content, "html.parser")
        categories = []

        for category in page_soup.find_all("a", {"class":"home-page-category-tile"}):
            categories.append(category['href'])
        
        return categories

    ### scrapes site for products and their metadata 


if __name__ == "__main__":
    crawler = ReweCrawler()

    #  crawler.start_crawl(option="rewes")
    crawler.start_crawl(option="products")