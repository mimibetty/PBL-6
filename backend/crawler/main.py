import os
import time

import pandas as pd
from bs4 import BeautifulSoup
from loguru import logger
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import NoSuchElementException, ElementClickInterceptedException

# Ref: https://selenium-python.readthedocs.io/locating-elements.html

EBAY_URL = "https://www.ebay.com/globaldeals/fashion/handbags-and-accessories"
WAIT_TIMEOUT = 5 # wait for some seconds

# Allow a pop-up window to be in cognito mode
chrome_options = Options()
chrome_options.add_argument("--incognito")
driver = webdriver.Chrome(options=chrome_options)

# Specify the URL to get the data from
driver.get(EBAY_URL)

# Scroll to the end of the page and wait for some seconds
# so that the page can be fully loaded
driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
time.sleep(WAIT_TIMEOUT)

while True:
    try:
        
        # Scroll to the end of the page and wait for some seconds
        # so that the page can be fully loaded
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        time.sleep(WAIT_TIMEOUT)
        # Locate the "Show more" button
        show_more_button = driver.find_element(By.XPATH, '//button[text()="Show more"]')
        # Click on it
        print("Click `Show more` button")
        show_more_button.click()
        # # Sleep for some seconds for loading items
        time.sleep(WAIT_TIMEOUT)
    except NoSuchElementException:
        # If the "Show more" button is not found, break the loop
        print("No more 'Show more' button found. The page is fully loaded.")
        break
    except ElementClickInterceptedException:
        # If the button is not clickable at the moment, wait and try again
        print("Button not clickable, retrying...")
        time.sleep(WAIT_TIMEOUT)

# Wait for a while to be fully loaded
time.sleep(WAIT_TIMEOUT)

# Scrape the current page by BeautifulSoup
page = BeautifulSoup(driver.page_source, features="html.parser")
import pdb; pdb.set_trace()

# Find all deals using the <img> tag
deals = page.find_all("div", {"itemscope": "itemscope"})
logger.info(f"Num of deals: {len(deals)}")

# Let's see what we have
products = []
for deal in deals:
    try:
        # import pdb; pdb.set_trace()
        # Find the tag "img" and get src containing 
        # the image link
        img_url = deal.find_all("img")[0]["src"]

        # Find the tag "span" with the attribute itemprop="name"
        product_name = deal.find_all("span", {"itemprop": "name"})[0].get_text()
        products.append({"product_name": product_name, "img_url": img_url})
    except:
        print("Either image's URL or product name can not be found, skipped!")

# Convert the list of products to dataframe
df = pd.DataFrame.from_dict(products)

# Write the new products to a products.csv file
dest = os.path.join("data", "products.csv")
if os.path.exists(dest):
    # If this file already exists, append to it
    df.to_csv(dest, mode="a", index=False, header=False)
else:
    # Else, create a new file and write to it
    df.to_csv(dest, mode="w", index=False, header=False)
