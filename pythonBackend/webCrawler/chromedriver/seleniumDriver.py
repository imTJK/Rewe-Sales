from selenium import webdriver
from selenium.webdriver import ChromeOptions

class Driver(webdriver.Chrome):
    def __init__(self):
        options = ChromeOptions()
        options.binary_location = "D:\Programmieren\AndroidStudio\Projects\Rewe-Sales\pythonBackend\webCrawler\chromedriver\chromedriver.exe"
        options.add_argument("start-maximized")
        options.add_argument("disable-infobars")
        options.add_argument("--disable-extensions")
        options.add_argument("--disable-gpu")
        options.add_argument("--disable-dev-shm-usage")
        options.add_argument("--no-sandbox")
        options.add_argument("user-data-dir=C:\\Users\\Tjorven\\AppData\\Local\\Google\\Chrome\\User Data\\Default")
        super().__init__(executable_path="webCrawler\chromedriver\chromedriver.exe", keep_alive=True, options=options)

