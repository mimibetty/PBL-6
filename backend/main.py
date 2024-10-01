from fastapi import Depends, FastAPI, HTTPException, Query, status
from typing import List, Dict, Optional, Annotated

from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from pydantic import BaseModel

from routes.account import accountRouter
from routes.authentication import authenticationRouter

app = FastAPI()

app.include_router(accountRouter)
app.include_router(authenticationRouter)


