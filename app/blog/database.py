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
    from .repository import user
    from .models import User, UserInfo
    from . import schemas  # Import schemas nếu cần
    # Lấy phiên làm việc với cơ sở dữ liệu
    db = next(get_db())
    
    try:
        # Kiểm tra xem có người dùng nào trong cơ sở dữ liệu không
        existing_users = db.execute(select(User)).scalars().all()
        
        if not existing_users:  # Nếu không có người dùng nào
            # Tạo dữ liệu mẫu cho người dùng
            user1_data = schemas.User(username='user1', email='user1@gmail.com', password='123', role="guest")
            business1_data = schemas.User(username='business1', email='business1@gmail.com', password='123', role="business")
            admin1_data = schemas.User(username='admin1', email='admin1@gmail.com', password='123', role="admin")

            # Gọi hàm create cho mỗi người dùng
            user1 = user.create_business_admin(user1_data, db)
            business1 = user.create_business_admin(business1_data, db)
            admin1 = user.create_business_admin(admin1_data, db)

            # Tạo thông tin người dùng liên quan đến user1 và user2
            user1_info = UserInfo(business_description='Tour operator', phone_number='123456789', user=user1)
            business1_info = UserInfo(business_description='Hotel owner', phone_number='987654321', user=business1)
            admin1_info = UserInfo(phone_number='987654321', user=admin1)

            # Thêm thông tin người dùng vào phiên làm việc
            db.add_all([user1_info, business1_info, admin1_info])

            # Commit giao dịch
            db.commit()
            print("Sample data created.")
        else:
            print("Sample data already exists.")

    except Exception as e:
        # Xử lý lỗi
        raise HTTPException(status_code=500, detail=f"Error creating sample data: {str(e)}")

    finally:
        # Đóng phiên làm việc
        db.close()