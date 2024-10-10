from datetime import date
from fastapi import HTTPException
from sqlalchemy import create_engine, select
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv
import pymysql

# DATABASE_URL=mysql+pymysql://travel_user:password@localhost:3306/db_connect
# cnx = mysql.connector.connect(user="travel_user", password="{your_password}", host="travel-sql.mysql.database.azure.com", port=3306, database="{your_database}", ssl_ca="{ca-cert filename}", ssl_disabled=False)


# Tải các biến môi trường từ tệp .env
load_dotenv()
DATABASE_URL = os.getenv('DATABASE_URL')
SSL_CA_PATH = os.getenv('SSL_CA_PATH')

print('dasd', os.path.exists(SSL_CA_PATH))

# Kiểm tra xem SSL_CA_PATH có tồn tại không
if not SSL_CA_PATH or not os.path.exists(SSL_CA_PATH):
    raise ValueError("SSL_CA_PATH không hợp lệ hoặc không tồn tại")

# Cấu hình kết nối SSL
ssl_args = {
    "ssl": {
        "ssl_ca": SSL_CA_PATH
    }
}

# Tạo engine với cấu hình SSL
try:
    engine = create_engine(DATABASE_URL, connect_args=ssl_args)
except Exception as e:
    raise HTTPException(status_code=500, detail=f"Không thể kết nối đến database: {str(e)}")


# high-level abstract (ORM) -> manage database through Object in code. Unlike Engine -> manage db through SQL command
SessionLocal = sessionmaker(autocommit=False, autoflush = False, bind = engine)
# Create base class for all models (code -> DB)
Base = declarative_base()
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def create_sample_data():
    from blog import repository
    from blog import models
    from . import schemas  # Import schemas nếu cần
    # Lấy phiên làm việc với cơ sở dữ liệu
    db = next(get_db())
    
    try:
        # Kiểm tra xem có người dùng nào trong cơ sở dữ liệu không
        existing_users = db.execute(select(models.User)).scalars().all()
        
        if not existing_users:  # Nếu không có người dùng nào
            # Tạo dữ liệu mẫu cho người dùng
            user1_data = schemas.User(username='user1', email='user1@gmail.com', password='123', role="guest")
            business1_data = schemas.User(username='business1', email='business1@gmail.com', password='123', role="business")
            admin1_data = schemas.User(username='admin1', email='admin1@gmail.com', password='123', role="admin")

            # Gọi hàm create cho mỗi người dùng
            user1 = repository.user.create_business_admin(user1_data, db)
            business1 = repository.user.create_business_admin(business1_data, db)
            admin1 = repository.user.create_business_admin(admin1_data, db)

            # Tạo thông tin người dùng liên quan đến user1 và user2
            user1_info = models.UserInfo(business_description='Tour operator', phone_number='123456789', user=user1)
            business1_info = models.UserInfo(business_description='Hotel owner', phone_number='987654321', user=business1)
            admin1_info = models.UserInfo(phone_number='987654321', user=admin1)

            # Thêm thông tin người dùng vào phiên làm việc
            db.add_all([user1_info, business1_info, admin1_info])

            # Commit giao dịch
            db.commit()
            
            city1 = models.City(
                name="Đà Nẵng",
                description="Thành phố biển xinh đẹp",
                user_id=1  # Giả định user_id = 1 tồn tại
            )

            city2 = models.City(
                name="Hà Nội",
                description="Thủ đô của Việt Nam",
                user_id=1  # Giả định user_id = 1 tồn tại
            )

            db.add(city1)
            db.add(city2)
            db.commit()  # Lưu thay đổi vào cơ sở dữ liệu

            # Thêm một số Destination
            destination1 = models.Destination(
                name="Bãi biển Mỹ Khê",
                address="Đà Nẵng, Việt Nam",
                price_bottom=200000,
                price_top=500000,
                date_create=date.today(),
                age=2,
                opentime="06:00:00",
                duration=3,
                user_id=1,  # Giả định user_id = 1 tồn tại
                city_id=city1.id  # Sử dụng ID của city1
            )

            destination2 = models.Destination(
                name="Phố cổ Hà Nội",
                address="Hà Nội, Việt Nam",
                price_bottom=50000,
                price_top=300000,
                date_create=date.today(),
                age=5,
                opentime="08:00:00",
                duration=2,
                user_id=1,  # Giả định user_id = 1 tồn tại
                city_id=city2.id  # Sử dụng ID của city2
            )

            db.add(destination1)
            db.add(destination2)
            db.commit()  # Lưu thay đổi vào cơ sở dữ liệu

            # Thêm một số Review
            review1 = models.Review(
                title="Review tuyệt vời cho Bãi biển Mỹ Khê",
                content="Bãi biển Mỹ Khê là nơi tuyệt vời để thư giãn và tắm biển!",
                rating=4.8,
                date_create=date.today(),
                user_id=1,  # Giả định user_id = 1 tồn tại
                destination_id=destination1.id  # Sử dụng ID của destination1
            )

            review2 = models.Review(
                title="Khám phá Phố cổ Hà Nội",
                content="Phố cổ Hà Nội rất đẹp và có nhiều món ăn ngon!",
                rating=4.5,
                date_create=date.today(),
                user_id=1,  # Giả định user_id = 1 tồn tại
                destination_id=destination2.id  # Sử dụng ID của destination2
            )

            db.add(review1)
            db.add(review2)
            db.commit()  # Lưu thay đổi vào cơ sở dữ liệu
            
            
            print("Sample data created.")
        else:
            print("Sample data already exists.")

    except Exception as e:
        # Xử lý lỗi
        raise HTTPException(status_code=500, detail=f"Error creating sample data: {str(e)}")

    finally:
        # Đóng phiên làm việc
        db.close()
