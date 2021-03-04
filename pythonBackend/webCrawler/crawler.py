import requests
from bs4 import BeautifulSoup

url = "https://shop.rewe.de/"

def get_url_content(url):
    return requests.get(url).text



def get_soup_content(url):
    content = get_url_content(url)
    soup = BeautifulSoup(content, "html.parser")
    articles = soup.find_all("a", class_="home-page-category-tile")
    print(articles)

if __name__ == "__main__":
   get_soup_content(url)