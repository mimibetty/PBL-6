from typing import List
from fastapi import APIRouter
from .. import database, schemas, models
from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends, status
from ..repository import destination

router = APIRouter(
    prefix="/destination",
    tags=['Destination']
)

get_db = database.get_db


@router.post("/", response_model=schemas.ShowDestination)
def create_destination_by_cityID(request: schemas.Destination, city_id: int, db: Session = Depends(get_db)):
    return destination.create_by_cityID(request, city_id, db)

@router.get("/{id}", response_model=schemas.ShowDestination)
def get_destination_by_id(id: int, db: Session = Depends(get_db)):
    return destination.get_by_id(id, db)

@router.get("/", response_model=List[schemas.ShowDestination])
def get_all_destination(db: Session = Depends(get_db)):
    return destination.get_all(db)

@router.get("/sorting_by_reviews/", response_model=List[schemas.ShowDestination])
def sorting_by_ratings_and_quantity_of_reviews(db: Session = Depends(get_db)):
    return destination.sorting_by_ratings_and_quantity_of_reviews(db)

@router.put("/{id}", response_model=schemas.ShowDestination)
def update_destination_by_id(id: int, request: schemas.Destination, db: Session = Depends(get_db)):
    return destination.update_by_id(id, request, db)

@router.delete("/{id}")
def delete_destination_by_id(id: int, db: Session = Depends(get_db)):
    return destination.delete_by_id(id, db)


@router.get("/city/{city_id}", response_model=List[schemas.ShowDestination])
def get_destination_by_city_id(city_id: int, db: Session = Depends(get_db)):
    return destination.get_by_city_id(city_id, db)

@router.post("/restaurant/{destination_id}", response_model=schemas.ShowRestaurant)
def create_destination_by_cityID(request: schemas.Restaurant, destination_id: int, db: Session = Depends(get_db)):
    return destination.create_restaurant_info_by_destinationID(request=request, destination_id=destination_id, db=db)

@router.put("/restaurant/{restaurant_id}", response_model=schemas.ShowRestaurant)
def update_restaurant_info_by_id(request: schemas.Restaurant, restaurant_id: int, db: Session = Depends(get_db)):
    return destination.update_restaurant_info_by_id(request=request, id=restaurant_id, db=db)