from typing import List, Optional
from pydantic import BaseModel
from datetime import date, time
class BlogBase(BaseModel):
    title: str
    body: str

class Blog(BlogBase):
    id: int
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
    id: str
    business_description: Optional[str]  # Thông tin mô tả doanh nghiệp
    phone_number: Optional[str]  
    class Config:
        from_attributes = True
class ShowUser(BaseModel):
    id: int
    username:str
    email:str
    role: str
    class Config():
        from_attributes = True

class ShowBlog(BaseModel):
    id: int
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
    
class SignUp(BaseModel):
    email: str
    password:str
    username: str
    
class Destination(BaseModel):
    name : str
    address : str
    price_bottom : int
    price_top : int  
    date_create : date  
    age : int  
    opentime : time  
    duration : int  
    
class City(BaseModel):
    name: str
    description: str
    
class ShowCity(City):
    id: int
    destination: List[Destination] = []
    
    class Config():
        from_attributes = True
        
class Destination(BaseModel):
    name : str
    address : str
    price_bottom : int  
    price_top : int  
    date_create : date 
    age : int  
    opentime : time
    duration : int 

class ShowDestination(Destination):
    id: int
    
    class Config():
        from_attributes = True
        
class Review(BaseModel):
    title :str 
    content :str 
    rating : float
    date_create :date
    
    
    
class ShowReview(Review):
    id: int
    # Foreign Key
    user : ShowUser
    destination :ShowDestination
    class Config():
        from_attributes = True