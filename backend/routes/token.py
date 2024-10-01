
from datetime import timedelta

from pydantic import BaseModel


SECRET_KEY = "bd8af6419ba28ef0a018e15eea4fd2a5026f671a195a321cb6817d54a109c740"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

class Token(BaseModel):
    access_token: str
    token_type: str

class Token():
    def create_access_token(data:dict, expires_data: timedelta = timedelta(minutes= ACCESS_TOKEN_EXPIRE_MINUTES)):
        to_encode = data.copy()
        expire = data.utcnow() + expires_data
        
        to_encode.update({"exp": expire})