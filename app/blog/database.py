from fastapi import HTTPException
from sqlalchemy import select
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker,AsyncSession

# Tải các biến môi trường từ tệp .env
load_dotenv()
DATABASE_URL = os.getenv('DATABASE_URL')
engine = create_async_engine(DATABASE_URL, echo=False)

# Tạo sessionmaker bất đồng bộ
AsyncSessionLocal = async_sessionmaker(bind=engine, class_=AsyncSession, expire_on_commit=False)

''' Synchronous
# Communicate DB and our app
engine = create_engine(DATABASE_URL)

# high-level abstract (ORM) -> manage database through Object in code. Unlike Engine -> manage db through SQL command
SessionLocal = sessionmaker(autocommit=False, autoflush = False, bind = engine)
'''
# Create base class for all models (code -> DB)
Base = declarative_base()
async def get_db():
    async with AsyncSessionLocal() as db:
        yield db


async def create_sample_data():
    from .repository import user
    from .models import User, UserInfo
    from . import schemas  # Import schemas nếu cần
    
    # Lấy phiên làm việc với cơ sở dữ liệu
    async for db in get_db():  # Sử dụng async with để quản lý phiên làm việc
        try:
            # Kiểm tra xem có người dùng nào trong cơ sở dữ liệu không
            result = await db.execute(select(User))  # Await the execution
            existing_users = result.scalars().all()  # Now call scalars() on the awai
            if not existing_users:  # Nếu không có người dùng nào
                user1_data = schemas.User(username='user1', email='user1@gmail.com', password='123', role="guest")
                business1_data = schemas.User(username='business1', email='business1@gmail.com', password='123', role="business")
                admin1_data = schemas.User(username='admin1', email='admin1@gmail.com', password='123', role="admin")

                user1 = await user.create_business_admin(user1_data, db)  
                business1 = await user.create_business_admin(business1_data, db)
                admin1 = await user.create_business_admin(admin1_data, db)

                user1_info = UserInfo(business_description='Tour operator', phone_number='123456789', user=user1)
                business1_info = UserInfo(business_description='Hotel owner', phone_number='987654321', user=business1)
                admin1_info = UserInfo(phone_number='987654321', user=admin1)

                db.add_all([user1_info, business1_info, admin1_info])

                await db.commit()  
                print("Sample data created.")
            else:
                print("Sample data already exists.")

        except Exception as e:
            # Xử lý lỗi
            raise HTTPException(status_code=500, detail=f"Error creating sample data: {str(e)}")

        # Không cần finally ở đây vì async with đã đảm bảo rằng db sẽ được đóng