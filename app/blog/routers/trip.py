from typing import List, Dict
from fastapi import APIRouter, File, HTTPException, Query, UploadFile
from .. import database, schemas, models
from sqlalchemy.orm import Session
from ..repository import tour, image_handler, trip, destination, map, destination, trip
from fastapi import APIRouter, Depends, status
from pydantic import BaseModel

router = APIRouter(
    prefix="/trip",
    tags=['Trip']
)

get_db = database.get_db


@router.get("/", response_model=List[schemas.ShowTrip])
def get_all(
    user_id: int = None,
    db: Session = Depends(get_db)  # Lấy phiên làm việc,
):
    results = []
    if user_id:
        results = trip.get_by_user_id(user_id=user_id, db=db)
        
    else:
        results = trip.get_all(db=db)
    return results

@router.post("/add_destination")
def add_dest_to_trip(
    request: schemas.AddDestToTrip,
    db: Session = Depends(get_db)  # Lấy phiên làm việc,
):
    return trip.add_destination_to_trip(request=request, db=db)

@router.post("/delete_destination")
def delete_dest_from_trip(
    trip_id: int,
    destination_id: int,
    db: Session = Depends(get_db)  # Lấy phiên làm việc,
):
    return trip.delete_destination_from_trip(trip_id=trip_id, destination_id=destination_id, db=db)
    
@router.post("/")
def create_trip(
    request: schemas.Trip,
    db: Session = Depends(get_db)  # Lấy phiên làm việc,
):
    return trip.create_trip(request=request, db=db)

@router.put("/{id}")
def update_trip(
    id: int,
    request: schemas.Trip,
    db: Session = Depends(get_db)  # Lấy phiên làm việc,
):
    return trip.update_by_id(id=id, request=request, db=db)
    
@router.get("/{id}", response_model=schemas.ShowTrip)
def get_by_id(
    id: int,
    db: Session = Depends(get_db)  # Lấy phiên làm việc,
):
    return trip.get_by_id(id=id, db=db)
    




class TripResponse(BaseModel):
    daily_schedule: dict[str, List[int]]
    hotels: List[int]
    daily_distances: dict[str, float]  # Thêm trường này để lưu khoảng cách của từng ngày

@router.post("/build", response_model=TripResponse)
async def build_trip(
    trip_day: int,
    hotel_ids: List[int],
    thingtodo_ids: List[int],
    restaurant_ids: List[int],
    db: Session = Depends(get_db)
):
    try:
        sorted_restaurant_ids = destination.sort_destinations_by_popularity(restaurant_ids, db)
        all_destination_ids = sorted_restaurant_ids + thingtodo_ids
        
        destination_map: Dict[str, int] = {}
        destination_names = []
        
        for dest_id in all_destination_ids:
            name_result = destination.getName_by_id(dest_id, db)
            if name_result:
                destination_names.append(name_result.name)
                destination_map[name_result.name] = dest_id

        # for dest_id in all_destination_ids:
        #     coords_result = map.get_destination_coordinates(dest_id, db)
        #     if coords_result:  # Kiểm tra coords không None
        #         coords, address = coords_result
        #         destination_names.append(address)  # Sử dụng địa chỉ đã dùng để tìm được tọa độ
        #         destination_map[address] = dest_id
                
        trip_plan = trip.run_travel_planner(destination_names, trip_day)

        daily_schedule = {}
        daily_distances = {}
        current_day = None
        
        for line in trip_plan.split('\n'):
            if line.startswith("Nhóm"):
                current_day = int(line.split()[1])
                daily_schedule[f"day_{current_day}"] = []
            elif line.startswith("Lộ trình:"):
                route = line.split(": ")[1].split(" -> ")
                daily_schedule[f"day_{current_day}"] = [destination_map[location] for location in route]
            elif line.startswith("Tổng khoảng cách:"):
                distance = float(line.split(": ")[1].split()[0])  # Lấy số km
                daily_distances[f"day_{current_day}"] = distance

        response = TripResponse(
            daily_schedule=daily_schedule,
            hotels=hotel_ids,
            daily_distances=daily_distances
        )
        
        print("All destination IDs:", all_destination_ids)
        print("Destination names:", destination_names)
        print("Daily schedule:", daily_schedule)
        print("Daily distances:", daily_distances)
        return response

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))




