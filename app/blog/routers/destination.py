from datetime import date, time
from typing import List, Optional
from fastapi import APIRouter, Body, File, HTTPException, Path, Query, UploadFile
from .. import database, schemas, models
from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends, status
from ..repository import destination, user,image, city
from ..oauth2 import authorize_action
from sqlalchemy import desc
from typing import List


router = APIRouter(
    prefix="/destination",
    tags=['Destination']
)

get_db = database.get_db

@router.get("/by_tags", response_model=List[schemas.ShowDestinationList])
def get_by_tag_lists(
    tag_ids: list[int] = Query([], description="List of tag IDs"),
    city_id: int =None,
    limit: int = None,
    db: Session = Depends(get_db)
):
    dests = destination.get_by_tags(db=db, tag_ids = tag_ids, city_id=city_id, limit=limit)
    return dests    


@router.post("/",
             )
async def create_destination(
    images: Optional[List[UploadFile]] = [],
    
    user_id: int = None,
    name: str = None,
    price_bottom: int = None,
    price_top: int = None,
    age: int = None,
    opentime: time = None,
    duration: int = None,
    description: Optional[str] = None,
    date_create: date = date.today(),
    
    #address
    district: str = None,
    street: str = None,
    ward: str = None,
    city_id: int = None,
    db: Session = Depends(get_db),    
    
):
    address = schemas.Address(
        district=district,
        street=street,
        ward=ward,
        city_id=city_id,
    )
    
    sh_destination = schemas.Destination(
        user_id=user_id,
        name=name,
        price_bottom=price_bottom,
        price_top=price_top,
        date_create=date_create,
        age=age,
        opentime=opentime,
        duration=duration,
        description=description
    )
    
    new_dest = destination.create(sh_destination, db)
    new_dest = destination.create_address_of_destination(db=db, destination=new_dest, address=address)
    print(new_dest.user_id)
    for img in images:
        sc_image = schemas.Image(
            destination_id = new_dest.id
        )
        await image.create_image(db, request=sc_image, image=img)
    
    
    return schemas.ShowDestination.from_orm(new_dest)

@router.put("/{id}", response_model=schemas.ShowDestination)
async def update_destination_by_id(
    id: int,
    new_images: Optional[List[UploadFile]] = [],  # Ảnh mới
    image_ids_to_remove: Optional[List[int]] = Body([]),  # Danh sách ID ảnh cần xóa
    
    user_id: int = None,
    name: str = None,
    price_bottom: int = None,
    price_top: int = None,
    age: int = None,
    opentime: time = None,
    duration: int = None,
    description: Optional[str] = None,
    date_create: date = date.today(),
    
    #address
    district: str = None,
    street: str = None,
    ward: str = None,
    city_id: int = None,
    db: Session = Depends(get_db),
    
):
    address = schemas.Address(
        district=district,
        street=street,
        ward=ward,
        city_id=city_id,
    )
    
    sh_destination = schemas.Destination(
        user_id=user_id,
        name=name,
        price_bottom=price_bottom,
        price_top=price_top,
        date_create=date_create,
        age=age,
        opentime=opentime,
        duration=duration,
        description=description
    )

    new_dest = destination.update_by_id(id, sh_destination, db)
    new_dest = destination.create_address_of_destination(db=db, destination=new_dest, address=address)
    
    #delete images_to_remove
    for img_id in image_ids_to_remove:
        await image.delete_image(db=db,id=img_id )
        
    #add new images
    for img in new_images:
        sc_image = schemas.Image(
            destination_id = new_dest.id
        )
        await image.create_image(db, request=sc_image, image=img)
    
    
    return schemas.ShowDestination.from_orm(new_dest)

@router.get("/top", response_model=List[schemas.Destination])
def get_top_destinations(
    limit: int = 10, 
    min_reviews: int = 3,
    db: Session = Depends(get_db)
):
    """Get top destinations sorted by popularity score"""
    return destination.get_top_destinations(db, limit, min_reviews)

@router.get("/{id}", response_model=schemas.ShowDestinationList)
def get_destination_by_id(
    id: int = None,    
    db: Session = Depends(get_db)
):
    dest = destination.get_by_id(id, db)
    if not dest:
        return {"error": "Destination not found"}
    
    
    # result = schemas.ShowDestination.from_orm(dest).dict()
    # rating_info = destination.get_ratings_and_reviews_number_of_destinationID(dest.id, db)
    # result.update({
    #     "rating": rating_info["ratings"],
    #     "numOfReviews": rating_info["numberOfReviews"]
    # })
    return dest

def paginate_results(results: List, page: int, page_size: int):
    if page < 1:
        page = 1  # Đảm bảo trang không nhỏ hơn 1
    start = (page - 1) * page_size
    end = start + page_size
    return results[start:end]  # Trả về danh sách đã phân trang


@router.get("/",response_model=List[schemas.ShowDestinationList], 
    description=(
        "## This endpoint allows you to retrieve destinations based on the following criteria:\n\n"
        "- **Fill `user_id`**: Get all destinations of 1 user;\n"
        "- **Fill `city_id`**: Get all destinations in 1 city;\n"
        "- **Fill both `user_id` and `city_id`**: Get all destinations of 1 user in 1 city;\n\n"
        "- **`limit`**: get l destination to filter city_id and user_id. \n\n "
        "- **`page`**:(>=1) if page == null -> return all else return `page_size` destination. \n\n "
        "+ **`page_size`**: number of dest return if `page` != null. \n\n "
        "## Example for limit and page:\n\n"
        "- **Input**: limit = 15, page_size = 7 \n\n "
        "- `page` : 1 =>7 first destination will be return \n\n"
        "- `page` : 2 =>1 first destination will be return \n\n "
        "- `page` : 3 =>=> return [] \n\n "
        
        
        
    ))

def get_destination(
    city_id: int = None,
    user_id: int = None,
    limit: int = None,
    page: int = None,
    page_size: int = 10,  # Thêm tham số page_size
    db: Session = Depends(get_db),
    # _ = Depends(authorize_action(action_name='SHOW_DESTINATION')),
):
    try:
        results = []
        if city_id:
            dests = destination.get_by_city_id(city_id=city_id, limit=limit, db=db)
            
            if user_id:
                for dest in dests:
                    if dest.user_id == user_id:
                        results.append(dest)
            else:
                results = dests
        else:
            if user_id:
                results = destination.get_by_userID(user_id=user_id, db=db, limit=limit)
            else:
                dests = destination.get_all(db=db, limit=limit)
                results = dests
        # Phân trang kết quả
        if page is not None:
            results = paginate_results(results, page, page_size)
            
        return results
    # Lọc kết quả dựa trên user_id và city_id
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                    detail=f"Error retrieving destination: {str(e)}")    





@router.get('/{destination_id}/like_count', response_model=int)
def get_destination_like_count(destination_id: int, db: Session = Depends(get_db)):
    return destination.get_like_count(destination_id, db)


@router.get("/{id}/get_tags_byid")
def get_destination_by_id(
    id: int = None,    
    db: Session = Depends(get_db)
):
    dest = destination.get_tags_by_id(id, db)
    if not dest:
        return {"error": "Destination not found"}
    return dest




@router.get("/by-rating", response_model=List[schemas.Destination])
def get_destinations_by_rating(
    min_rating: float = 0,
    max_rating: float = 5,
    min_reviews: int = 2,
    db: Session = Depends(get_db)
):
    """Get destinations filtered by rating range"""
    return destination.get_destinations_by_rating_range(
        db, 
        min_rating, 
        max_rating, 
        min_reviews
    )

@router.get("/{destination_id}/stats", response_model=schemas.DestinationStats)
def get_destination_statistics(
    destination_id: int,
    db: Session = Depends(get_db)
):
    """Get detailed statistics for a specific destination"""
    return destination.get_destination_stats(db, destination_id)


@router.post("/top-destinations-by-tag-and-city")  
def get_top_destinations_by_tagandcity(
    tag_id: Optional[int] = Query(None, description="ID của tag cần lọc (không bắt buộc)"),
    city_id: Optional[int] = Query(None, description="ID của thành phố cần lọc (không bắt buộc)"),
    limit: int = Query(default=5, ge=1, le=100, description="Số lượng kết quả trả về (từ 1-100, mặc định là 5)"),
    db: Session = Depends(get_db)
):
    """
    Lấy danh sách các điểm đến (destinations) được sắp xếp theo popularity_score.

    Parameters:
    - tag_id (Optional[int]): ID của tag để lọc các điểm đến
    - city_id (Optional[int]): ID của thành phố để lọc các điểm đến
    - limit (int): Số lượng kết quả tối đa trả về (mặc định: 5, tối đa: 100)

    Returns:
    - List[Destination]: Danh sách các điểm đến, mỗi điểm đến bao gồm đầy đủ thông tin

    Example:
    ```
    POST /destination/top-destinations-by-tag-and-city?tag_id=1&city_id=3&limit=5
    ```
    """
    return destination.get_top_destinations_bytag(db, tag_id, city_id, limit)

@router.post("/top-destinations-IDS-by-tag-and-city")  
def get_top_destination_ids(
    tag_id: Optional[int] = Query(None, description="ID của tag cần lọc (không bắt buộc)"),
    city_id: Optional[int] = Query(None, description="ID của thành phố cần lọc (không bắt buộc)"),
    limit: int = Query(default=5, ge=1, le=100, description="Số lượng kết quả trả về (từ 1-100, mặc định là 5)"),
    db: Session = Depends(get_db)
):
    """
    Lấy danh sách ID của các điểm đến (destinations) được sắp xếp theo popularity_score.

    Parameters:
    - tag_id (Optional[int]): ID của tag để lọc các điểm đến
    - city_id (Optional[int]): ID của thành phố để lọc các điểm đến
    - limit (int): Số lượng kết quả tối đa trả về (mặc định: 5, tối đa: 100)

    Returns:
    - List[int]: Danh sách các ID của điểm đến

    Example:
    ```
    POST /destination/top-destinations-IDS-by-tag-and-city?tag_id=1&city_id=3&limit=5
    ```
    """
    return destination.get_top_destination_ids_bytag(db, tag_id, city_id, limit)



@router.get('/recommendations_bylikes/{user_id}')
def get_recommendations(
    user_id: int, 
    city_id: Optional[int] = None,
    limit: int = 20,
    db: Session = Depends(get_db)
):
    return destination.get_recommended_destinations(user_id, db, city_id, limit)

@router.delete("/{id}")
async def delete_destination_by_id(id: int, db: Session = Depends(get_db),
    # _ = Depends(authorize_action(action_name='DELETE_DESTINATION')),
    ):
    return await destination.delete_by_id(id, db)

# @router.post("/uploadfiles/")
# async def upload_files(files: List[UploadFile] = None):
#     if not files:
#         return {"message": "No files uploaded."}
    
#     file_names = [file.filename for file in files]
#     return {"file_names": file_names}

@router.get('/rating-distribution/{destination_id}')
def get_destination_rating_distribution(
    destination_id: int,
    db: Session = Depends(get_db)
):
    """
    Get the distribution of ratings for a specific destination
    Returns a dictionary with rating counts for each star rating (1-5)
    """
    return destination.get_rating_distribution(destination_id, db)


@router.get("/destinations/by-city/{city_name}")
def demo_get_top_destinations(city_name: str, limit: int = 5, db: Session = Depends(get_db)):
    try:
        # Find city
        mycity = city.search_by_name_one(db, city_name)
        if not mycity:
            raise HTTPException(status_code=404, detail=f"City '{city_name}' not found")
        print(mycity.id, mycity.name)
        # Get destinations in that city
        destinations = (db.query(models.Destination)
            .join(models.Address)
            .filter(models.Address.city_id == mycity.id)
            .order_by(desc(models.Destination.popularity_score))
            .limit(limit)
            .all())

        # Check if any destinations found
        if not destinations:
            raise HTTPException(
                status_code=404, 
                detail=f"No destinations found in {city_name}"
            )
            
        return [{
            "name": dest.name,
            "description": dest.description,
            "rating": dest.average_rating,
            "review_count": dest.review_count,
            "popularity": dest.popularity_score,
            "address": f"{dest.address.street or ''}, {dest.address.ward or ''}, {dest.address.district or ''}"
        } for dest in destinations]
        
    except HTTPException as he:
        raise he
    except Exception as e:
        raise HTTPException(
            status_code=500, 
            detail=f"Internal server error: {str(e)}"
        )