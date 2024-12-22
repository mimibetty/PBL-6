from typing import List
from fastapi import APIRouter
from .. import database, schemas, models
from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends, status
from ..repository import address, city, destination

router = APIRouter(
    prefix="/address",
    tags=['Address']
)

get_db = database.get_db

@router.get("/cities")
def read_distinct_cities(db: Session = Depends(get_db)):
    cities = address.get_distinct_cities(db)
    return cities

@router.get("/districts/{city_id}", response_model=list[str])
def read_distinct_districts(city_id: int, db: Session = Depends(get_db)):
    districts = address.get_distinct_districts(db=db, city_id=city_id)
    return [district[0] for district in districts]  # Chuyển đổi tuple thành danh sách

@router.get("/wards/{district_name}", response_model=list[str])
def read_distinct_wards(district_name: str, db: Session = Depends(get_db)):
    wards = address.get_distinct_wards(db=db, district=district_name)
    return [ward[0] for ward in wards]  # Chuyển đổi tuple thành danh sách


@router.get("/destination/{destination_id}")
def get_destination_address(destination_id: int, db: Session = Depends(get_db)):
    """
    Lấy địa chỉ đầy đủ của một destination dựa trên ID.
    Trả về list gồm 2 string:
    - String 1: Full address bao gồm tên destination
    - String 2: Full address không bao gồm tên destination
    - String 3: Tên địa điểm
    """
    return destination.get_full_address_by_id(destination_id, db)