from geopy.geocoders import Nominatim

def get_coordinates(location_name):
    # Khởi tạo geocoder
    geolocator = Nominatim(user_agent="my_app")
    
    try:
        # Tìm kiếm địa điểm
        location = geolocator.geocode(location_name)
        
        if location:
            return (location.latitude, location.longitude)
        else:
            return None
            
    except Exception as e:
        print(f"Lỗi: {e}")
        return None

# Sử dụng
locations = [
    "Cầu rồng đà nẵng",
    "Đại học bách khoa đà nẵng",
    "Đại học bách khoa hà nội"
    # "Đại học bách khoa hà nội",
    # "Đại học y hà nội",
    # "Đại học sư phạm hà nội",
    # "Đại học sư phạm Đà Nẵng"
    

]

# location = "Ha Noi, Vietnam"
for location in locations:
    coordinates = get_coordinates(location)
    if coordinates:
        print(f"Tọa độ của {location}:")
        print(f"Vĩ độ: {coordinates[0]}, Kinh độ: {coordinates[1]}")
    else:
        print(f"Không tìm thấy tọa độ cho {location}.")