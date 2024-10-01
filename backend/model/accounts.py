from typing import List
from pydantic import BaseModel
from fastapi import HTTPException
from pymongo import MongoClient

from config.database import client
from model.auth import Hash

class AccountModel():
    # username: str
    # password: str
    
    def __init__(self, db_client: MongoClient = client):
        database = client.get_database() 
        self.collection =  database['accounts']
    async def getAccounts(self) -> List[BaseModel]:
        try:
            cursor = self.collection.find({})
            accounts = await cursor.to_list(length=None)
            for account in accounts:
                account['_id'] = str(account['_id'])
            return accounts
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Database query failed: {e}")

    async def getAccountByUsername(self, username: str):
        try:
            account = await self.collection.find_one({"username": username})
            if account:
                account['_id'] = str(account['_id'])
                return account
            else:
                raise HTTPException(status_code=404, detail=f"Account {username} not found")
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Database operation failed: {e}")

    async def createAccount(self, account: BaseModel):
        try:
            existing_account = await self.collection.find_one({"username": account.username})
            if existing_account:
                raise HTTPException(status_code=400, detail="Account already exists")
            
            hashed_pass = Hash.get_password_hash(account.password)
            result = await self.collection.insert_one({
                "username": account.username,
                "password": hashed_pass
            })
            if result.inserted_id:
                return account
            else:
                raise HTTPException(status_code=500, detail="Account creation failed")
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Database operation failed: {e}")

    async def deleteAccount(self, username: str):
        try:
            result = await self.collection.delete_one({"username": username})
            if result.deleted_count == 0:
                raise HTTPException(status_code=404, detail=f"Account {username} not found")
            return {"detail": "Account deleted successfully"}
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Database operation failed: {e}")

    async def updateAccount(self,username: str, account_update: BaseModel):
        try:
            update_data = {k: v for k, v in account_update.dict().items() if v is not None}
            result = await self.collection.update_one({"username": username}, {"$set": update_data})
            
            if result.matched_count == 0:
                raise HTTPException(status_code=404, detail="Account not found")
            
            updated_account = await self.collection.find_one({"username": username})
            updated_account['_id'] = str(updated_account['_id'])
            return updated_account
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"Database operation failed: {e}")

    async def checkLogin(self, username: str, password: str):
        try:
            user = await self.collection.find_one({"username": username})
            if not user:
                raise HTTPException(status_code=404, detail="Invalid username or password")

            if not Hash.verify_password(password, user["password"]):
                raise HTTPException(status_code=401, detail="Invalid username or password")

            return user
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"An error occurred during login: {e}")
    
