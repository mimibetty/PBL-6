from datetime import date, datetime, time
from typing import List, Optional
from fastapi import APIRouter, Body, HTTPException, Path, Query, UploadFile
from .. import database, schemas, models
from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends, status
from ..repository import destination, city,dashboard

router = APIRouter(
    prefix="/dashboard",
    tags=['Dashboard']
)

get_db = database.get_db

@router.get("/search", description="Search city and destination by name, the result contains 2 list: cities and destinations")
def search_by_name_of_destination_and_city(
    text: str = None,    
    db: Session = Depends(get_db)
):
    city_list = city.search_by_name(db=db, text=text)
    destination_list = destination.search_by_name(db=db, text=text)
    
    results = {
        "cities": [{"id": city.id, "name": city.name} for city in city_list],
        "destinations": [{"id": destination.id, "name": destination.name} for destination in destination_list]
    }

    return results

@router.get("/usercounts/month/{year}", response_model=List[schemas.UserCountByMonth])
def read_user_counts_by_month(
    year: int,
    is_business: bool,
    db: Session = Depends(get_db)
):
    return dashboard.get_account_counts_by_month(db=db, year=year, is_business= is_business)

@router.get("/usercounts/{year}/{month}/days", response_model=List[schemas.UserCountDetail])
def read_user_counts_by_day(
    year: int,
    month: int,
    is_business: bool,
    db: Session = Depends(get_db)):
    if month < 1 or month > 12:
        raise HTTPException(status_code=400, detail="Invalid month. Month must be between 1 and 12.")
    return dashboard.get_account_counts_by_day(db=db, year=year, is_business= is_business,month= month)


@router.get("/business/stacked_review",
            description=(
                "### Get review_count of 1 dest based on: month + review rating\n\n"
                "- **Example**: destination_id = 6, year = 2024 \n\n"
                "{ \n\n"
                ' "1": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0],\n\n'
                ' "2": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],\n\n'
                ' "3": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 4],\n\n'
                ' "4": [0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 1],\n\n'
                ' "5": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0],\n\n'
                "}\n\n"
                "- **Explain:** tháng 11 có : 1 đánh giá 1 sao, 2 đánh giá 3 sao, 1 đánh giá 5 sao, ... \n\n"
                "- **Format**: result[s][mth]: tổng reivew s star trong tháng m"
            ))
def get_reviews_count_by_rating(
    destination_id: int,
    year: int = datetime.now().year,
    db: Session = Depends(get_db)
):
    result = dashboard.get_reviews_count_by_rating(db=db,  year=year, destination_id=destination_id)
    return result

