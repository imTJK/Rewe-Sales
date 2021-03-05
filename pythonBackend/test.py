
from flaskApi import app, db
from flaskApi.models import User, Zipcode, Rewe, Product, Discount

from webCrawler.crawler import ReweCrawler


if __name__ == "__main__":
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