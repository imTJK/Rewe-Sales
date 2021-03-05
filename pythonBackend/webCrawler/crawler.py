import requests
import cloudscraper

from bs4 import BeautifulSoup

class ReweCrawler(object):
    def __init__(self, url):
        super().__init__()
        self.start_url = url
        self.products = {}
        self.scraper = cloudscraper.create_scraper()
        self.scraper.cookies.set('marketsCookie', '%7B%22online%22%3A%7B%22wwIdent%22%3A%22540902%22%2C%22marketZipCode%22%3A%2228329%22%2C%22serviceTypes%22%3A%5B%22PICKUP%22%5D%2C%22customerZipCode%22%3A%2228213%22%7D%2C%22stationary%22%3A%7B%7D%7D')
    
    
    def start_crawl(self):
        for category in self.get_category_links():
            product = self.get_products(self.start_url + category)
            self.products.update({
                str(category.replace('c','').replace('/','')) : product
            })


    




    ### scrapes the Site for links to each category of Product ###
    def get_category_links(self):
        content = self.scraper.get(self.start_url).text
        page_soup = BeautifulSoup(content, "html.parser")
        categories = []

        for category in page_soup.find_all("a", {"class":"home-page-category-tile"}):
            categories.append(category['href'])
        
        return categories

    ### scrapes site for products and their metadata 
    def get_products(self, url):
        products = []

        while url:          
            page_soup = BeautifulSoup(self.scraper.get(url).text, "html.parser")
            if len(page_soup.find_all("div", {"class" : "search-service-productDetailsWrapper"})) == 0:
                break

            for product in page_soup.find_all("div", {"class" : "search-service-productDetailsWrapper"}):
                divs = product.findChildren('div')

                for div in divs:
                    if div.attrs and div.attrs['class'] == ['search-service-productPicture']:
                        img_url = div.contents[0].contents[0].contents[3].attrs['src'].split('?')[0]


                    if div.attrs and div.attrs['class'] == ['search-service-productDetails']:
                        amount = 'unknown'
                        if div.contents[4].next.attrs['class'] == ['search-service-productOffer']:
                            price = float(div.contents[4].contents[0].contents[1].text.replace('€', '').replace("'",  '').replace(' ', '').replace(',', '.'))
                            on_sale = True
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