from datetime import date, datetime
import json
import asyncio
import logging
import random
from types import NoneType
from fastapi import HTTPException
from sqlalchemy.orm import Session
from blog import models, schemas, repository
# from blog.repository.image_handler import ImageHandler
from blog.repository import city, destination, tag, image_handler
from sqlalchemy import create_engine, select, text

logging.basicConfig(level=logging.INFO)

def load_data_from_json(file_path):
    """Load data from a JSON file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            return json.load(file)
    except FileNotFoundError:
        logging.error(f"{file_path} not found.")
        return {}
    except json.JSONDecodeError:
        logging.error(f"Error decoding JSON from {file_path}.")
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
def check_city_in_json(data):
    cnt = 0
    for city_name, destinations in data.items():
        cnt +=1
        print(f"stt: {cnt}. city_name: {city_name}")
async def add_data_to_db(db: Session, data):
    try:
        for city_name, destinations in data.items():
            for dest in destinations:
                try:
                #  [Done]Get name, address, tag
                    d_tag = dest["Tag"]
                    d_address = dest["Address"]
                    d_name = dest["Name"]
                #  [Done] Process Address
                    dest_city = city.get_id_by_name(db=db, name= city_name)
                    sc_address = schemas.Address(
                        district=d_address["district"],
                        street=d_address["street"],
                        ward=d_address["ward"],
                        city_id=dest_city.id,
                    )
                except AttributeError:
                    logging.warning(f"Destination {d_name} have invalid address {d_address} ")
                    continue
                
                sh_destination = schemas.Destination(
                    #match city_id to business_id
                    user_id=dest_city.id + 2,
                    
                    name=d_name,
                    date_create = datetime.now(),
                    price_bottom=0,
                    price_top=random.randint(10, 30) * 100000,  # Random từ 10 đến 30, nhân với 10000
                    age=random.randint(4, 18),  # Random từ 4 đến 18
                    duration=random.randint(4, 24),  # Random từ 4 đến 24
                    description="Wonderful place for your destination",
                )
                
                
                new_dest = destination.create(sh_destination, db)
                new_dest = destination.create_address_of_destination(db=db, destination=new_dest, address=sc_address)
                
                # Crawl images for the new destination
                logging.info(f"Crawling images for destination {new_dest.name}.")
                img_crawler = image_handler.ImageHandler()
                await img_crawler.crawl_image_for_dest(db, new_dest)
                # Add Tag to destination Tag(id - name)
                    # 1 - Food & Drink
                    # 7 - Nightlife
                    # 9 - Shopping
                    # 10 - Outdoor Activities
                    # 11 - General
                    # 12 - Hotel
                tag_id = tag.get_id_by_name(db=db, name = d_tag)
                tag.add_tag_to_destination(db=db, dest_id=new_dest.id, tag_id = tag_id)

                

    except Exception as e:
        print(f"Add data fail: {e.detail}")

async def delete_duplicate_dest(db: Session, start_id:int, end_id: int):
    for i in range(start_id, end_id):
        logging.info(f"Deleting destination with id: {i}")

        await repository.destination.delete_by_id(db=db, id = i)
        
def delete_noUse_address(db:Session):
    addresses = db.query(models.Address).all()
    for addr in addresses:
        if not addr.destination:
            repository.address.delete_by_id(db = db, id = addr.id)

#[Needed] Chia Nếu là food&Drink và Hotel thì xử lý data như thế nào 
def process_hotel_rest(db:Session):
    # tag == hotel but id == null -> add new
    dests = db.query(models.Destination).all()
    for dest in dests:
        print(dest.tags)
        tag_list = [tag.name for tag in dest.tags]
        print(tag_list)
        if ("Hotel" in tag_list) and not dest.hotel_id: 
            # Add Hotel
            print(f"Add hotel to {dest.id}")
            sc_hotel = schemas.Hotel(
                        property_amenities='Free WiFi, Pool, Gym',
                        room_features='AC, TV, Minibar',
                        room_types='Suite, Deluxe',
                        hotel_class=random.randint(3, 5),  # Hotel class từ 3-5 sao
                        hotel_styles='Luxury, Modern',
                        languages='English, Vietnamese',
                        phone='0905993000',
                        email="dulichVietNam@gmail.com",
                        website="travelWebsite.com"
                    )
            repository.hotel.create_by_destinationID(destination_id=dest.id, request = sc_hotel, db=db)
            
        
        if "Food & Drink" in tag_list and not dest.restaurant_id:
            # Add Rest
            print(f"Add Rest to {dest.id}")
            sc_restaurant = schemas.Restaurant(
                cuisine='Vietnamese, International',
                special_diet='Vegetarian, Vegan',
                feature='outdoor sitting',
                meal='breakfast, dinner',
            )   
            repository.restaurant.create_by_destinationID(destination_id=dest.id, request = sc_restaurant, db=db)            
    
async def create_sample_data(db: Session):
    # Lấy phiên làm việc với cơ sở dữ liệu

    try:
        imageHandler =image_handler.ImageHandler()

        # Kiểm tra xem có người dùng nào trong cơ sở dữ liệu không
        existing_users = db.execute(select(models.User)).scalars().all()
        if not existing_users:  # Nếu không có người dùng nào
            # Tạo dữ liệu mẫu cho người dùng
            user1_data = schemas.User(username='user1', email='user1@gmail.com', password='123', role="guest", status="enable")
            admin1_data = schemas.User(username='admin1', email='admin1@gmail.com', password='123', role="admin", status="enable")

            # Gọi hàm create cho mỗi người dùng
            user1 = repository.user.create_business_admin(user1_data, db)
            admin1 = repository.user.create_business_admin(admin1_data, db)

            # Tạo thông tin người dùng liên quan đến user1 và user2
            user1_info = models.UserInfo(description='Tour operator', phone_number='123456789', user=user1)
            admin1_info = models.UserInfo(phone_number='987654321', user=admin1)
            
            db.add_all([user1_info, admin1_info])
            db.commit()
            
            # Tạo 61 người dùng với phân quyền là business
            cities = [
                "Hà Nội", "TP Hồ Chí Minh", "Đà Nẵng", "Hải Phòng", "Nha Trang", 
                "Cần Thơ", "Huế", "Quảng Ninh", "Vĩnh Phúc", "Đồng Nai",
                "Bà Rịa - Vũng Tàu", "Bắc Ninh", "Thái Nguyên", "Nam Định", "Ninh Bình",
                "Hà Nam", "Hưng Yên", "Điện Biên", "Hà Tĩnh", "Quảng Bình",
                "Quảng Trị", "Thừa Thiên Huế", "Bình Định", "Phú Yên", "Khánh Hòa",
                "Gia Lai", "Kon Tum", "Đắk Lắk", "Đắk Nông", "Lâm Đồng",
                "Tây Ninh", "Long An", "Tiền Giang", "Bến Tre", "Trà Vinh",
                "Vĩnh Long", "Hậu Giang", "Sóc Trăng", "Đồng Tháp", "An Giang",
                "Kiên Giang", "Cà Mau", "Bạc Liêu", "Hà Giang", "Lào Cai",
                "Yên Bái", "Tuyên Quang", "Hòa Bình", "Ninh Thuận", "Bình Thuận",
                "Cao Bằng", "Thái Bình", "Bắc Kạn", "Lạng Sơn", "Đắk Lắk",
                "Lâm Đồng", "Bến Tre", "Bình Dương", "Bình Phước", "Hưng Yên", "Vĩnh Phúc"
            ]

            for i in range(61):
                username = f'business{i+1}'
                email = f'business{i+1}@gmail.com'
                password = '123'

                # Tạo người dùng
                user_data = schemas.User(username=username, email=email, password=password, role="business", status="enable")
                user = repository.user.create_business_admin(user_data, db)

                # Tạo thông tin người dùng
                user_info = models.UserInfo(description='Business Owner', phone_number='0123456789', user=user)
                db.add(user_info)

                # Tạo thành phố
                city = models.City(
                    name=cities[i],
                    description=f"{cities[i]} - một tỉnh thành tuyệt đẹp",
                    user_id=user.id  # Liên kết với user vừa tạo
                )
                db.add(city)
                db.commit()
                db.refresh(city)
                
                # crawl data cho city
                # await ImageHandler.crawl_image(db=db, city= city)
                # imageHandler.crawl_image(db=db, city=city )
                # ImageHandler.crawl_image(db=db, city= city)
                # image.crawl_image(db=db, city=city )
                
                # Thêm 1 điểm đến cho mỗi user
                for j in range(2):
                    
                    address = models.Address(
                        district = f"district of {cities[i]}",
                        street = f"street of {cities[i]}",
                        ward = f"ward of {cities[i]}",
                        city = city
                    )
                    db.add(address)
                    db.commit()
                    destination = models.Destination(
                        description = "description",
                        name=f"Destination {j+1} tại {cities[i]}",
                        # address=f"Địa chỉ {j+1}, {cities[i]}",
                        address = address,
                        price_bottom=0,
                        price_top=0,
                        date_create=date.today(),
                        age=0,
                        opentime="00:00:00",
                        duration=24,
                        user_id=user.id,
                    )
                    db.add(destination)
                    db.commit()
                    db.refresh(destination)
                    
                    # await imageHandler.fake_db_destination(db, destination=destination)
                    # imageHandler = ImageHandler()
                    # imageHandler.fake_db_destination(db, destination=destination)
                    
                    hotel = models.Hotel(
                        property_amenities='Free WiFi, Pool, Gym',
                        room_features='AC, TV, Minibar',
                        room_types='Suite, Deluxe',
                        hotel_class=random.randint(3, 5),  # Hotel class từ 3-5 sao
                        hotel_styles='Luxury, Modern',
                        languages='English, Vietnamese',
                    )
                    
                    # restaurant = models.Restaurant(
                    #     cuisine='Vietnamese, International',
                    #     special_diet='Vegetarian, Vegan',
                    # )
                    # destination.restaurant = restaurant
                    destination.hotel = hotel
                    db.add_all([hotel,  destination,address ])
                    db.commit()
                    
                    
                    # Tạo 3-5 reviews cho mỗi destination
                    num_reviews = random.randint(0, 7)
                    for k in range(num_reviews):
                        review = models.Review(
                            title=f"Review {k + 1} for Destination {j + 1}",
                            content=f"This is review {k + 1} for Destination {j + 1}.",
                            rating= float(random.randint(1, 10)/2),  # Rating từ 1.0 đến 5.0
                            date_create=date.today(),
                            user_id=user.id,  # Gán user_id của user đã tạo
                            destination_id=destination.id  # Gán destination_id của destination đã tạo
                        )
                        db.add(review)
                        db.commit()
                        db.refresh(review)
                        # await imageHandler.fake_db_review(db, review=review)
                        # imageHandler.fake_db_review(db, review=review)
                        
    
            db.commit()
            # destination.update_all_destination_ratings(db)

            # for user_id in range(1, 5):
            #     for destination_id in range(1, 11):
            #         if random.randint(0, 1) == 1:
            #             like = models.UserDestinationLike(
            #                 user_id=user_id,
            #                 destination_id=destination_id
            #             )
            #             db.add(like)
            
            # # Tạo sample data cho DestinationTag
            # for destination_id in range(1, 11):
            #     for tag_id in range(1, 6):
            #         if random.randint(0, 1) == 1:
            #             destination_tag = models.DestinationTag(
            #                 destination_id=destination_id,
            #                 tag_id=tag_id
            #             )
            #             db.add(destination_tag)
            
            # db.commit()
            

            # 
            print("Sample data created.")
        else:
            print("Sample data already exists.")

    except Exception as e:
        # Xử lý lỗi
        raise HTTPException(status_code=500, detail=f"Error creating sample data: {str(e)}")

    finally:
        # Đóng phiên làm việc
        db.close()
async def main(db: Session, data_path: str = "classified_data.json"):
    data = load_data_from_json(data_path)
    check_city_in_json(data=data)
    # await add_data_to_db(db = db, data=data)

 
