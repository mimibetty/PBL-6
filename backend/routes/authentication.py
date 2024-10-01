from datetime import datetime, timedelta, timezone
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from schema import schemas

from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from typing import Annotated

from model.accounts import AccountModel
from model.auth import Hash
import jwt

# to get a string like this run:
# openssl rand -hex 32
SECRET_KEY = "238a06a0282ad771bbd21bfdea152d11d4deb2f501e91ed28fada1d175683ca3"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

authenticationRouter = APIRouter(
    tags=["authentication"]
)

accountModel = AccountModel()


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: str | None = None


class User(BaseModel):
    username: str
    email: str | None = None
    full_name: str | None = None
    disabled: bool | None = None


class UserInDB(User):
    password: str

# Login 
@authenticationRouter.post("/login")
async def login(form_data: Annotated[OAuth2PasswordRequestForm, Depends()]):
    ms = await accountModel.checkLogin(form_data.username, form_data.password)
    if ms is None:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    return ms


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

def create_access_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(token: Annotated[str, Depends(oauth2_scheme)]):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("username")
        if username is None:
            raise credentials_exception
        token_data = TokenData(username=username)
    except jwt.exceptions.InvalidTokenError as e:
        raise credentials_exception
    user = await accountModel.getAccountByUsername(username=token_data.username)
    if user is None:
        raise credentials_exception
    return UserInDB(**user)



async def get_current_active_user(
    current_user: Annotated[User, Depends(get_current_user)],):
    if current_user.disabled:
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user



@authenticationRouter.post("/token")
async def login_for_access_token(
    form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
) -> Token:
    user_dict = await accountModel.checkLogin( form_data.username, form_data.password)
    user = UserInDB(**user_dict)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"username": user.username}, expires_delta=access_token_expires
    )
    return Token(access_token=access_token, token_type="bearer")


@authenticationRouter.get("/users/me/", response_model=User)
async def read_users_me(
    current_user: Annotated[User, Depends(get_current_active_user)],
):
    return current_user

