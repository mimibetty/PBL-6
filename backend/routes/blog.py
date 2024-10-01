from fastapi import APIRouter, HTTPException, Query
from typing import List, Dict, Optional, Annotated

from schema import  schemas
from config.database import accounts_collection


blogRouter = APIRouter()



@blogRouter.get("/blog/{id}")
# id: from path, limit: from query   
async def get_status(id: int, limit: Annotated[str | None, Query(min_length=3, max_length=50)] = None):
    return {"data": id, "limit": limit}

@blogRouter.get("/blog")
async def get_status():
    return {"data": 100}