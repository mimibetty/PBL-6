from typing import List, Optional
from pydantic import BaseModel


class BlogBase(BaseModel):
    title: str
    body: str

class Blog(BlogBase):
    class Config():
        from_attributes = True
class UserInfoBase(BaseModel):
    business_description: str# Thông tin mô tả doanh nghiệp
    phone_number: str

class User(BaseModel):
    username:str
    email:str
    password:str
    role: str

class ShowUserInfo(BaseModel):
    business_description: Optional[str]  # Thông tin mô tả doanh nghiệp
    phone_number: Optional[str]  
    user: User
    class Config:
        from_attributes = True
class ShowUser(BaseModel):
    username:str
    email:str
    user_info: Optional[UserInfoBase] = None
    class Config():
        from_attributes = True
        orm_mode = True
class ShowBlog(BaseModel):
    title: str
    body:str
    creator: ShowUser

    class Config():
        from_attributes = True


class Login(BaseModel):
    email: str
    password:str


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    email: Optional[str] = None
    role: Optional[str] = None
    

