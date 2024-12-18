from typing import List
from sqlalchemy import func
from sqlalchemy.orm import Session
from blog import models, schemas
from fastapi import HTTPException, status


def get_distinct_cities(db:Session):
    return db.query(models.City.id, models.City.name ).distinct().all()

def get_distinct_districts(db:Session, city_id: int):
    return db.query(models.Address.district).filter(models.Address.city_id == city_id).distinct().all()

def get_distinct_wards(db:Session, district: str):
    return db.query(models.Address.ward).filter(models.Address.district == district).distinct().all()


def delete_by_id(db: Session, id: int):
    try:
        address = db.query(models.Address).filter(models.Address.id == id).first()
        db.delete(address)  # Chờ xóa đối tượng
        db.commit()  # Chờ hoàn tất việc commit
        return {"detail": "destination deleted successfully"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error deleting address: {str(e)}")