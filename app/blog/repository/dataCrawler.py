import json
import time
import logging
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait, Select
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException

logging.basicConfig(level=logging.INFO)

chrome_options = Options()
chrome_options.add_argument("--incognito")

URL_TAG_MAPPING = {
    "https://csdl.vietnamtourism.gov.vn/tt": "Outdoor Activities",
    "https://csdl.vietnamtourism.gov.vn/rest": "Food & Drink",
    "https://csdl.vietnamtourism.gov.vn/shop": "Shopping",
    "https://csdl.vietnamtourism.gov.vn/cslt":  "Hotel",
    "https://csdl.vietnamtourism.gov.vn/vcgt": "Nightlife",
    "https://csdl.vietnamtourism.gov.vn/dest": "General",
}

VERTICLE_LISTING_CLASS = "verticle-listing-caption"
SEARCH_BUTTON_ID = "searchbutton"


def load_existing_data(file_path):
    """Load existing data from a JSON file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            return json.load(file)
    except FileNotFoundError:
        logging.info(f"{file_path} not found. Starting with an empty dataset.")
        return {}
    except json.JSONDecodeError:
        logging.error(f"Error decoding JSON from {file_path}. Starting with an empty dataset.")
        return {}
def parse_address(address):
    # Khởi tạo các biến
    street = ""
    ward = ""
    city = ""
    district = ""
    
    datas = address.strip().split(",")
    city = datas[-1].replace("Thanh pho", "")

    # Tìm kiếm từ khóa trong địa chỉ
    # Tìm kiếm từ khóa "Thành phố"
    if "Thành phố" in address:
        # Tách phần thành phố
        datas = address.strip().split(",")
        city_part = datas[-1].replace("Thành phố", "").strip()
        city = city_part  # Lấy tên thành phố
        address = address.rsplit(",", 1)[0].strip()  # Cắt bỏ phần cuối cùng
    else:
        city = address.split(",")[-1].strip()  # Lấy phần sau dấu phẩy cuối cùng
        address = address.rsplit(",", 1)[0].strip()  # Cắt bỏ phần cuối cùng

    if "Quận" in address or "Huyện" in address:
        # Tách phần phường
        district = address.split(",")[-1].replace("Quận", "").replace("Huyện", "").strip()
        address = address.rsplit(",", 1)[0].strip()
    
    if "Phường" in address:
        # Tách phần phường
        ward_part = address.split("Phường")[-1]
        ward = ward_part.split(",")[0].strip()  # Lấy tên phường
        address = address.split("Phường")[0].strip()  # Cắt bỏ phần phường
    


    # Phần còn lại sẽ là street và district
    street = address.replace("Đường", "").strip()
    
    # Tạo object với các trường cần thiết
    data_object = {
        "street": street,
        "ward": ward,
        "district": district,
        "city": city
    }
    
    return data_object
def get_title_and_address(driver: webdriver.Chrome, tag: str):
    """Retrieve titles and addresses from the page and add a tag."""
    try:
        wait = WebDriverWait(driver, 5)
        elements = wait.until(EC.presence_of_all_elements_located((By.CLASS_NAME, VERTICLE_LISTING_CLASS)))
        
        data = []
        for element in elements:
            title = element.find_element(By.TAG_NAME, 'h4').text
            address = element.find_element(By.CSS_SELECTOR, 'span.d-block').text
            clean_address = address.strip().replace("Địa chỉ: ", "").strip(", ")
            clean_address = parse_address(clean_address)
            data.append({
                "Name": title,
                "Address": clean_address,
                "Tag": tag
            })

            logging.info(f"Name: {title}")
            logging.info(f"Address: {clean_address}")
            logging.info(f"Tag: {tag}")
            logging.info("-" * 40)
        
        return data
    except TimeoutException:
        logging.error("TimeoutException: Elements not found within the given time.")
        return []

def select_item(driver, dropdown_id, value):
    """Select item from dropdown."""
    wait = WebDriverWait(driver, 5)
    dropdown = wait.until(EC.presence_of_element_located((By.ID, dropdown_id)))
    select = Select(dropdown)
    select.select_by_value(value=value)
    click_button(driver=driver, button_id=SEARCH_BUTTON_ID)
    time.sleep(3)  # Add a delay to ensure the page has loaded

def click_button(driver, button_id):
    """Click a button by ID."""
    wait = WebDriverWait(driver, 2)
    button = wait.until(EC.element_to_be_clickable((By.ID, button_id)))
    button.click()

def merge_data(existing_data, new_data):
    """Merge new data into existing data without duplicates."""
    for city_name, places in new_data.items():
        if city_name not in existing_data:
            existing_data[city_name] = places
        else:
            existing_places = existing_data[city_name]
            for place in places:
                if place not in existing_places:
                    existing_places.append(place)
                    
def crawl_data_by_city(out_file_path, city_json_file_path):
    """Crawl data for each city and classify it by city name."""
    existing_data = load_existing_data(out_file_path)

    with open(city_json_file_path, 'r', encoding='utf-8') as json_file:
        options_dict = json.load(json_file)

    new_data = {}

    try:
        with webdriver.Chrome(options=chrome_options) as driver:
            for url, tag in URL_TAG_MAPPING.items():
                driver.get(url)
                time.sleep(1)

                for city_name, city_value in options_dict.items():
                    logging.info(f"Processing city: {city_name} for URL: {url}")
                    select_item(driver=driver, dropdown_id="province", value=city_value)
                    time.sleep(1)  # Wait for the page to load
                    city_data = get_title_and_address(driver=driver, tag=tag)
                    if city_name not in new_data:
                        new_data[city_name] = []
                    new_data[city_name].extend(city_data)
    except Exception as e:
        logging.error(f"An error occurred: {e}")
    finally:
        # Merge new data with existing data
        merge_data(existing_data, new_data)

        # Write the merged data to a JSON file
        with open(out_file_path, 'w', encoding='utf-8') as output_file:
            json.dump(existing_data, output_file, ensure_ascii=False, indent=4)
        logging.info(f"Data has been written to {out_file_path}")

if __name__ == "__main__":
    crawl_data_by_city(out_file_path="classified_data.json", city_json_file_path="option.json")