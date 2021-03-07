
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
from flaskApi.models import User, Zipcode, Rewe, Product, Discount


class ReweCrawler(object):
    def __init__(self):
        super().__init__()
        self.options = json.load(open(r'pythonBackend\webCrawler\options.json'))
        self.parser = 'html.parser'
        self.scraper = cloudscraper.create_scraper()
    

    def __get_token_from_plz(self, plz):
        pass

    
    def start_crawl(self, option : str):
        if option in self.options['functions']:
            getattr(self, self.options['functions'][option]['function'])(self.options['functions'][option]['url'])

    def crawl_sales(self, url):
        for plz, cookie in self.options['cookies'].items():
            print(str(plz) + "  " + str(cookie))


    



    ### gets entirity of products excluding products from the on_sale category
    def crawl_products(self, url, token):
        self.scraper.cookies.set('marketsCookie', token)
        products = {}
        for category in self.get_category_links()[1:]:
            product = self.get_products(url + category, get_sales=False)
            products.update({
                str(category.replace('c','').replace('/','')) : product
            })

        for category, products in products.items():
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
            
    def check_for_discount(self):
        products = Product.query.filter_by(on_sale='1').all()
        return products




    ### scrapes the Site for links to each category of Product ###
    def get_category_links(self):
        content = self.scraper.get(self.start_url).text
        page_soup = BeautifulSoup(content, "html.parser")
        categories = []

        for category in page_soup.find_all("a", {"class":"home-page-category-tile"}):
            categories.append(category['href'])
        
        return categories

    ### scrapes site for products and their metadata 
    def get_products(self, url, get_sales : bool):
        products = []

        while url:          
            page_soup = BeautifulSoup(self.scraper.get(url).text, self.parser)
            if len(page_soup.find_all("div", {"class" : "search-service-productDetailsWrapper"})) == 0:
                break

            for product in page_soup.find_all("div", {"class" : "search-service-productDetailsWrapper"}):
                divs = product.findChildren('div')

                for div in divs:
                    if div.attrs and div.attrs['class'] == ['search-service-productPicture']:
                        img_url = div.contents[0].contents[0].contents[3].attrs['src'].split('?')[0]


                    if div.attrs and div.attrs['class'] == ['search-service-productDetails']:
                        amount = 'unknown'
                        if get_sales:
                            if div.contents[4].next.attrs['class'] == ['search-service-productOffer']:
                                price = float(div.contents[4].contents[0].contents[1].text.replace('€', '').replace("'",  '').replace(' ', '').replace(',', '.'))
                                on_sale = True       
                            else: break                
                        else: 
                            
                            price = float(div.contents[4].contents[0].text.replace('€', '').replace("'",  '').replace(' ', '').replace(',', '.'))
                            on_sale = False

                        if div.contents[2].attrs['class'] == ['search-service-productGrammage']:
                            amount = div.contents[2].contents[0].contents[0].split(' ')[0]


                        products.append({
                            'name' : div.contents[1].contents[0].contents[0].text,
                            'price' : price,
                            'menge' : amount,
                            'on_sale' : on_sale,
                            'img_url' : img_url
                        })

            if len(url.split('?')) > 1:
                url = url.replace(str(url.split('page=')[1]), str(int(url.split('page=')[1]) + 1))
            else:
                url += '?page=2'

        return products[1:]


if __name__ == "__main__":
    crawler = ReweCrawler()

    #  crawler.start_crawl(option="rewes")
    crawler.start_crawl(option="sales")
    pass
