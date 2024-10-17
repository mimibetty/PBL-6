from sqlalchemy.orm import Session
from blog import models, schemas
from fastapi import HTTPException, status
from blog.hashing import Hash

def create_by_cityID(city_id: int, request: schemas.Destination, db: Session):
    try:
        new_destination = models.Destination(
            name = request.name,
            address = request.address,
            price_bottom = request.price_bottom,
            price_top = request.price_top,
            date_create = request.date_create,
            age = request.age,
            opentime = request.opentime,
            duration = request.duration,
            city_id = city_id
        )
        db.add(new_destination)
        db.commit()  # Chờ hoàn tất việc commit
        db.refresh(new_destination)  # Chờ làm mới đối tượng mới
        return new_destination
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error creating destination: {str(e)}")

def get_by_id(id: int, db: Session):
    try:
        destination = db.query(models.Destination).filter(models.Destination.id == id).first()  # Chờ truy vấn
        
        if not destination:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                detail=f"destination with the id {id} is not available")
        return destination
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error retrieving destination: {str(e)}")
def get_by_city_id(city_id: int, db: Session):
    try:
        destinations = db.query(models.Destination).filter(models.Destination.city_id == city_id).all()  # Chờ truy vấn
        if not destinations:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                detail=f"destinations with the city_id {city_id} is not available")
        return destinations
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error retrieving destinations: {str(e)}")

def get_all(db: Session):
    try:
        destinations = db.query(models.Destination).all()  # Chờ truy vấn
        return destinations
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error retrieving destinations: {str(e)}")
def sorting_by_ratings_and_quantity_of_reviews(db: Session):
    try:
        # Lấy tất cả các điểm đến và đánh giá tương ứng
        destinations = db.query(models.Destination).all()
        
        # Tạo danh sách để lưu trữ thông tin điểm đến cùng với điểm số và số lượng đánh giá
        destination_scores = []

        for destination in destinations:
            # Lấy tất cả các đánh giá cho destination
            reviews = db.query(models.Review).filter(models.Review.destination_id == destination.id).all()
            if reviews:
                # Tính tổng số điểm và số lượng đánh giá
                total_ratings = sum(review.rating for review in reviews)
                quantity_of_reviews = len(reviews)
                average_rating = total_ratings / quantity_of_reviews

                # Tính điểm theo công thức
                point = quantity_of_reviews + (average_rating * 10)

                destination_scores.append({
                    "destination": destination,
                    "total_point": point
                })
            else:
                destination_scores.append({
                    "destination": destination,
                    "total_point": 0
                })

        # Sắp xếp danh sách theo total_point từ cao xuống thấp
        destination_scores.sort(key=lambda x: x['total_point'], reverse=True)

         # Trả về danh sách các đối tượng Destination đã sắp xếp
        sorted_destinations = [item["destination"] for item in destination_scores]
        return sorted_destinations

    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error retrieving destinations: {str(e)}")
    
def update_by_id(id: int, request: schemas.Destination, db: Session):
    try:
        destination = db.query(models.Destination).filter(models.Destination.id == id).first()  # Chờ truy vấn
        if not destination:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                detail=f"destination with the id {id} is not available")

        destination.name = request.name
        destination.email = request.email
        db.commit()  # Chờ hoàn tất việc commit
        db.refresh(destination)  # Chờ làm mới đối tượng mới
        return destination
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error updating destination: {str(e)}")

def delete_by_id(id: int, db: Session):
    try:
        destination = db.query(models.Destination).filter(models.Destination.id == id).first()  # Chờ truy vấn
        if not destination:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                detail=f"destination with the id {id} is not available")

        db.delete(destination)  # Chờ xóa đối tượng
        db.commit()  # Chờ hoàn tất việc commit
        return {"detail": "destination deleted successfully"}
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error deleting destination: {str(e)}")

def create_restaurant_info_by_destinationID(destination_id: int, request:schemas.Restaurant, db: Session):
    try:
        destination = db.query(models.Destination).filter(models.Destination.id == destination_id).first()  # Chờ truy vấn
        new_restaurant = models.Restaurant(
            cuisine = request.cuisine,
            special_diet = request.special_diet
        )
        db.add(new_restaurant)
        db.commit()  # Chờ hoàn tất việc commit
        db.refresh(new_restaurant)  # Chờ làm mới đối tượng mới
        
        destination.restaurant_id = new_restaurant.id
        db.commit()
        db.refresh(destination)
        return new_restaurant
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error deleting destination: {str(e)}")

def update_restaurant_info_by_id(id:int, request: schemas.Restaurant, db: Session):
    try:
        print(request)
        restaurant = db.query(models.Restaurant).filter(models.Restaurant.id == id).first()  # Chờ truy vấn
        if not restaurant:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                detail=f"restaurant with the id {id} is not available")

        restaurant.cuisine = request.cuisine
        restaurant.special_diet = request.special_diet
        db.commit()  # Chờ hoàn tất việc commit
        db.refresh(restaurant)  # Chờ làm mới đối tượng mới
        return restaurant
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error updating destination: {str(e)}")