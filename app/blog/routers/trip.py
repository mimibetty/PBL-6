from typing import List, Dict
from fastapi import APIRouter, File, HTTPException, Query, UploadFile
from .. import database, schemas, models
from sqlalchemy.orm import Session
from ..repository import tour, image_handler, trip, destination, map, destination
from fastapi import APIRouter, Depends, status
from pydantic import BaseModel

router = APIRouter(
    prefix="/trip",
    tags=['Trip']
)

get_db = database.get_db


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




