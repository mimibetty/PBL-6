import requests

def get_city_names():
    try:
        response = requests.post("http://127.0.0.1:8000/city/cities-name")
        if response.status_code == 200:
            return response.json()  # Trả về list các tên thành phố
        else:
            print(f"Error: {response.status_code}")
            return None
    except requests.RequestException as e:
        print(f"Request failed: {e}")
        return None

# Sử dụng hàm
city_names = get_city_names()
if city_names:
    print("Danh sách các thành phố:")
    for name in city_names:
        print(name)