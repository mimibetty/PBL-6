from fastapi import APIRouter
from .. import database, schemas, models
from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends, status
from ..repository import city

router = APIRouter(
    prefix="/city",
    tags=['City']
)

get_db = database.get_db


@router.post("/", response_model=schemas.ShowCity)
def create_city_by_userid(request: schemas.City, user_id: int, db: Session = Depends(get_db)):
    return city.create_city_by_userid(request, user_id, db)

@router.get("/{user_id}", response_model=schemas.ShowCity)
def get_city_by_userid(user_id: int, db: Session = Depends(get_db)):
    print(user_id)
    return city.get_city_by_userid(user_id, db)

@router.get("/", response_model=schemas.ShowCity)
def get_all_city(db: Session = Depends(get_db)):
    return city.get_all_city(db)


@router.put("/{user_id}", response_model=schemas.ShowCity)
def update_city_by_userid(user_id: int, request: schemas.City, db: Session = Depends(get_db)):
    return city.update_city_by_userid(user_id, request, db)

@router.delete("/{user_id}")
def delete_city_by_userid(user_id: int, db: Session = Depends(get_db)):
    return city.delete_city_by_userid(user_id, db)
