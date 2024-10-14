from fastapi import APIRouter
from .. import database, schemas, models
from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends, status
from ..repository import review
from typing import List


router = APIRouter(
    prefix="/review",
    tags=['Review']
)

get_db = database.get_db


@router.post("/", response_model=schemas.ShowReview)
def create_by_userId_destinationId(request: schemas.Review, user_id: int, destination_id: int, db: Session = Depends(get_db)):
    return review.create_by_cityID(user_id, destination_id, request, db)

@router.get("/{id}", response_model=schemas.ShowReview)
def get_review_by_id(id: int, db: Session = Depends(get_db)):
    return review.get_by_id(id, db)

@router.get("/reviews_of_destination/", response_model=List[schemas.ShowReview])
def get_reviews_of_destination_by_destinationId(destination_id: int, db: Session = Depends(get_db)):
    return review.get_reviews_of_destination_by_destinationId(destination_id, db)

@router.get("/reviews_of_user_in_destination/", response_model=List[schemas.ShowReview])
def get_reviews_of_user_in_1_destination_by_userId_and_destinationID(destination_id: int, user_id:int,  db: Session = Depends(get_db)):
    return review.get_reviews_of_user_in_1_destination_by_userId_and_destinationID(destination_id, user_id, db)


@router.put("/{id}", response_model=schemas.ShowReview)
def update_review_by_id(id: int, request: schemas.Review, db: Session = Depends(get_db)):
    return review.update_by_id(id, request, db)

@router.delete("/{id}")
def delete_review_by_id(id: int, db: Session = Depends(get_db)):
    return review.delete_by_id(id, db)
