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
        # for dest_id in all_destination_ids:
        #     coords, address = map.get_destination_coordinates(destination_id, db)
        #     if coords is not none and address is not none:
        #         lat, long = coords
        #         destination_names.append(address)
        #         destination_map[address] = dest_id
            
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
        
        # 1                
        # trip_plan = trip.run_travel_planner(destination_names, trip_day, db)
        trip_plan = trip.run_travel_planner(all_destination_ids, trip_day, db=db)

        daily_schedule = {}
        daily_distances = {}

        for line in trip_plan.split('\n'):
            if line.startswith("Nhóm"):
                current_day = int(line.split()[1])
                daily_schedule[f"day_{current_day}"] = []
            elif line.startswith("Lộ trình:"):
                route = line.split(": ")[1].split(" -> ")
                daily_schedule[f"day_{current_day}"] = [int(location_id) for location_id in route]
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




class CreateTripInput(BaseModel):
    trip_name: str
    month_time: str
    user_id: int
    isAI: bool
    trip_day: int
    list_day: Dict[str, List[int]]  # Format: {"day_1": [id1, id2, ...], "day_2": [id3, id4, ...]}
    list_hotel: List[int]

@router.post("/create-complete-trip", response_model=int)
async def create_complete_trip(
    trip_input: CreateTripInput,
    db: Session = Depends(get_db)
):
    try:
        # 1. Tạo trip mới
        new_trip = trip.create_trip(
            schemas.Trip(
                name=trip_input.trip_name,
                month_time=trip_input.month_time,
                duration=trip_input.trip_day,
                user_id=trip_input.user_id,
                isAI=trip_input.isAI
            ),
            db
        )
        
        # 2. Thêm hotels (day = 0)
        for idx, hotel_id in enumerate(trip_input.list_hotel):
            trip.add_destination_to_trip(
                schemas.AddDestToTrip(
                    destination_id=hotel_id,
                    trip_id=new_trip.id,
                    day=0,
                    order=idx
                ),
                db
            )
        
        # 3. Thêm các destination theo từng ngày
        for day_key, destinations in trip_input.list_day.items():
            # Chuyển day_1 thành số 1
            day_num = int(day_key.split('_')[1])
            
            # Thêm từng destination theo thứ tự
            for order, dest_id in enumerate(destinations):
                trip.add_destination_to_trip(
                    schemas.AddDestToTrip(
                        destination_id=dest_id,
                        trip_id=new_trip.id,
                        day=day_num,
                        order=order
                    ),
                    db
                )
        
        return new_trip.id

    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to create complete trip: {str(e)}"
        )
    



@router.delete("/{trip_id}", response_model=int)
def delete_trip_by_id(
    trip_id: int,
    db: Session = Depends(get_db)
):
    """
    Xóa trip và tất cả các trip_destination liên quan.
    
    Parameters:
    - trip_id: ID của trip cần xóa
    
    Returns:
    - 1 nếu xóa thành công
    - 0 nếu không tìm thấy trip hoặc xóa thất bại
    """
    try:
        result = trip.delete_trip(trip_id, db)
        return 1 if result else 0
        
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Error deleting trip: {str(e)}"
        )