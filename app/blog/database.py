from sqlalchemy import create_engine, select
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

# Tải các biến môi trường từ tệp .env
load_dotenv()

DATABASE_URL = os.getenv('DATABASE_URL')
# Communicate DB and our app
engine = create_engine(DATABASE_URL)

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
    # Create a new session
    db = next(get_db())
    
    # Check if there are any users in the database
    existing_users = db.execute(select(User)).scalars().all()
    
    if not existing_users:  # Nếu không có người dùng nào
        # Create sample users
        user1_data = schemas.User(username='user1', email='user1@gmail.com', password='123')
        user2_data = schemas.User(username='user2', email='user2@gmail.com', password='123')
        user3_data = schemas.User(username='user3', email='user3@gmail.com', password='123')

        # Call the create function for each user
        user2 = user.create(user2_data, db)
        user3 = user.create(user3_data, db)
        user1 = user.create(user1_data, db)

        # Create user information related to user1 and user2
        user_info1 = UserInfo(business_description='Tour operator', phone_number='123456789', user=user1_data)
        user_info2 = UserInfo(business_description='Hotel owner', phone_number='987654321', user=user2_data)

        # Add user information to the session
        db.add_all([user_info1, user_info2])

        # Commit the transaction
        db.commit()
        print("Sample data created.")
    else:
        print("Sample data already exists.")

    # Close the session
    db.close()
