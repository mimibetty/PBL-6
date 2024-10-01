from pymongo import MongoClient
from motor.motor_asyncio import AsyncIOMotorClient #Use this for Async Query
# Connect to MongoDB
try:
    uri = "mongodb://localhost:27017/mydb"
    client = AsyncIOMotorClient(uri)
    database = client.get_database()
    accounts_collection = database['accounts']
    print("DB Connect Success")
except Exception as e:
    print(f"DB Failed: {e}")