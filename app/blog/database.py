
from fastapi import HTTPException
from sqlalchemy import create_engine, select, text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv
import pymysql
from datetime import date  # Đảm bảo bạn import date
from fastapi import HTTPException



# from blog.repository import destination

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


def delete_all(engine):
    pass
