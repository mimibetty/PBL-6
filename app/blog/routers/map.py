from typing import List,Optional
from fastapi import APIRouter
from .. import database, schemas, models
from sqlalchemy.orm import Session
from ..repository import destination, mapService,map
from pydantic import BaseModel
from fastapi import APIRouter, Body, File, HTTPException, Path, Query, UploadFile, Depends, status

router = APIRouter(
    prefix="/map",
    tags=['Map']
)

get_db = database.get_db



class CoordinateResponse(BaseModel):
    latitude: float
    longitude: float
    location_name: str

@router.get("/get-coordinates//{destination_id}", response_model=CoordinateResponse)
def get_destination_coordinates(
    destination_id: int,
    db: Session = Depends(get_db)
):
    """
    Lấy tọa độ (latitude, longitude) của một địa điểm dựa trên destination_id.

    Parameters:
    - destination_id (int): ID của địa điểm cần lấy tọa độ

    Returns:
    - CoordinateResponse: Tọa độ và tên của địa điểm
    """
    try:
        # Lấy tên địa điểm từ ID
        dest = destination.getName_by_id(destination_id, db)

        # Lấy tọa độ dựa trên tên địa điểm
        lat, long = map.get_destination_coordinates(destination_id,db)
        
        return CoordinateResponse(
            latitude=lat, 
            longitude=long,
            location_name=dest.name
        )

    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )
