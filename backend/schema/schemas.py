from pydantic import BaseModel
from typing import Optional

# Pydantic model for Account
class Account(BaseModel):
    username: str
    password: str

# Pydantic model for Account update (optional fields)
class AccountUpdate(BaseModel):
    username: Optional[str] = None
    password: Optional[int] = None

class Token(BaseModel):
    access_token: str
    token_type: str
    
class TokenData(BaseModel):
    username: Optional[str] = None

class User(BaseModel):
    username: str
    email: Optional[str] = None
    full_name: Optional[str] = None
    disable: Optional[bool] = None

class UserInDB(BaseModel):
    hashed_password: str
    