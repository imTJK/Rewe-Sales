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


# local imports # 
sys.path.insert(1, r'D:\Programmieren\AndroidStudio\Projects\Rewe-Sales\pythonBackend')
from flaskApi import app, db
from flaskApi.models import User, Zipcode, Rewe, Product, Discount, Prices


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


    def crawl_prices(self, url):
        add_length = len(Product.query.all())
        categories = self.get_category_links(url)[1:] 
        Prices.query.delete()

        for plz, cookie in self.options['cookies'].items():
            self.scraper.cookies.set('marketsCookie', cookie)
            if plz != "":
                for category in categories:
                    search_url = url + category
                    while search_url:          
                        page_soup = BeautifulSoup(self.scraper.get(search_url).text, self.parser)
                        if len(page_soup.find_all("div", {"class" : "search-service-productDetailsWrapper"})) == 0:
                            break

                        for product in page_soup.find_all("div", {"class" : "search-service-productDetailsWrapper"}):
                            _product = Product()
                            divs = product.findChildren('div')
                            price, amount, on_sale_in  = "", "", "" 

                            for div in divs:
                                if div.attrs and div.attrs['class'] == ['search-service-productPicture']:
                                    _product.img_src = div.contents[0].contents[0].contents[3].attrs['src'].split('?')[0]
                                
                                if div.attrs and div.attrs['class'] == ['search-service-productDetails']:
                                    name=div.contents[1].contents[0].contents[0].text
                                    indexed_products = Product.query.filter_by(name=name).all()
                                    if len(indexed_products) == 0:
                                        add_length += 1
                                        _product.id = add_length
                                        _product.name = name
                                        _product.category = category
                                        if div.contents[4].next.attrs['class'] == ['search-service-productOffer']:
                                            _product.on_sale_in = plz
                                        db.session.add(_product)
                                        indexed_products.append(_product)

                                    prices = Prices(rewe_plz = plz)
                                    
                                    for product in indexed_products:
                                        prices.product_id = product.id  

                                        if div.contents[4].next.attrs['class'] == ['search-service-productOffer']:
                                            prices.on_sale = True
                                            prices.price = float(div.contents[4].contents[0].contents[1].text.replace('€', '').replace("'",  '').replace(' ', '').replace(',', '.'))


                                            if plz not in str(product.on_sale_in):
                                                if product.on_sale_in:
                                                    product.on_sale_in += ", {}".format(plz)
                                                product.on_sale_in = "{}".format(plz)
                                            
                                        else:
                                            prices.price = float(div.contents[4].contents[0].text.replace('€', '').replace("'",  '').replace(' ', '').replace(',', '.'))
                                    
                                    db.session.add(prices)

                        if len(search_url.split('?')) > 1:
                            search_url = search_url.replace(str(search_url.split('page=')[1]), str(int(search_url.split('page=')[1]) + 1))
                        else:
                            search_url += '?page=2'        
            db.session.commit()
            self.scraper.cookies.set('marketsCookie', '')


    ### gets entirity of products excluding products from the on_sale category
    def crawl_products(self, url, zipcode):
        for category in self.get_category_links(url)[1:]:
            self.scraper.cookies.set('marketsCookie', self.options['cookies'][zipcode])
            search_url = url + category
            while search_url:          
                page_soup = BeautifulSoup(self.scraper.get(search_url).text, self.parser)
                if len(page_soup.find_all("div", {"class" : "search-service-productDetailsWrapper"})) == 0:
                    break

                for product in page_soup.find_all("div", {"class" : "search-service-productDetailsWrapper"}):
                    found_other = False
                    divs = product.findChildren('div')
                    price, amount, on_sale_in  = "", "", "" 
                    p = Product(category = category)

                    for div in divs:
                        if div.attrs and div.attrs['class'] == ['search-service-productPicture']:
                            p.img_src = div.contents[0].contents[0].contents[3].attrs['src'].split('?')[0]

                        if div.attrs and div.attrs['class'] == ['search-service-productDetails']:
                            p.name =  div.contents[1].contents[0].contents[0].text
                            if zipcode != "" and div.contents[4].next.attrs['class'] == ['search-service-productOffer']:
                                other_products = Product.query.filter_by(name=p.name).all()
                                for other_product in other_products:
                                    if other_product.name == p.name and other_product.category == p.category and p.on_sale_in != "":
                                        found_other = True
        
                    if not found_other:
                        db.session.add(p)

                if len(search_url.split('?')) > 1:
                    search_url = search_url.replace(str(search_url.split('page=')[1]), str(int(search_url.split('page=')[1]) + 1))
                else:
                    search_url += '?page=2'        
        db.session.commit()

    
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
            if Rewe.query.filter_by(adress=str(db_rewe.adress).first() is None):
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
    crawler.start_crawl(option="prices")

    pass
