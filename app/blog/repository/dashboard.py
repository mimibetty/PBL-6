from collections import defaultdict
from typing import List
from sqlalchemy import func
from sqlalchemy.orm import Session
from blog import models, schemas

from sqlalchemy.orm import Session
from fastapi import HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import func
from datetime import datetime
from sqlalchemy import and_

def get_account_counts_by_month(db: Session, year: int, is_business: bool):
    if is_business == True:
        # Truy vấn số lượng doanh nghiệp theo tháng
        results = (
            db.query(
                func.month(models.User.created_at).label('month'),
                func.count(models.User.id).label('user_count')
            )
            .filter(models.User.role == 'business', func.year(models.User.created_at) == year)
            .group_by('month')
            .order_by('month')  # Sắp xếp theo tháng
            .all()
        )
        return [schemas.UserCountByMonth(month=row.month, user_count=row.user_count) for row in results]
    else:
        results = (
            db.query(
                func.month(models.User.created_at).label('month'),
                func.count(models.User.id).label('user_count')
            )
            .filter(models.User.role == 'guest', func.year(models.User.created_at) == year)
            .group_by('month')
            .order_by('month')  # Sắp xếp theo tháng
            .all()
        )
        return [schemas.UserCountByMonth(month=row.month, user_count=row.user_count) for row in results]
def get_account_counts_by_day(db: Session, year: int, month: int, is_business):
    if is_business == True:
        results = (
        db.query(
            func.day(models.User.created_at).label('day'),
            func.count(models.User.id).label('user_count')
        )
        .filter(models.User.role == 'business', func.year(models.User.created_at) == year, func.month(models.User.created_at) == month)
        .group_by('day')
        .order_by('day')  # Sắp xếp theo ngày
        .all()
    )
        return [schemas.UserCountDetail(day=row.day, user_count=row.user_count) for row in results]
    
    else:
        results = (
            db.query(
                func.day(models.User.created_at).label('day'),
                func.count(models.User.id).label('user_count')
            )
            .filter(models.User.role == 'guest',func.year(models.User.created_at) == year, func.month(models.User.created_at) == month)
            .group_by('day')
            .order_by('day')  # Sắp xếp theo ngày
            .all()
        )
        return [schemas.UserCountDetail(day=row.day, user_count=row.user_count) for row in results]
    

def get_review_of_dest_by_time(db: Session, 
                               destination_id: int, 
                               rating: int,
                               month: int = None,
                               year = datetime.now().year):
    start_date = f"{year}-{month:02d}-01"  # Ngày 1 của tháng
    if month == 12:
        end_date = f"{year + 1}-01-01"  # Ngày 1 của tháng 1 năm sau
    else:
        end_date = f"{year}-{month + 1:02d}-01"  # Ngày 1 của tháng tiếp theo

    # Truy vấn để lấy các đánh giá
    reviews_query = db.query(models.Review).filter(
            models.Review.destination_id == destination_id,
            models.Review.rating >= rating,
            models.Review.date_create >= start_date,
            models.Review.date_create < end_date
    )

    # Lấy danh sách các đánh giá
    total_review = reviews_query.all()

    return total_review

def get_reviews_count_by_rating(db: Session, destination_id: int, year = datetime.now().year):
    # Khởi tạo một dictionary để lưu trữ số lượng đánh giá theo rating
    reviews_count = defaultdict(lambda: [0] * 12)

    # Truy vấn để lấy số lượng đánh giá theo rating cho từng tháng
    results = db.query(
        func.extract('month', models.Review.date_create).label('month'),
        models.Review.rating,
        func.count(models.Review.id).label('count')
    ).filter(
        models.Review.destination_id == destination_id,
        func.extract('year', models.Review.date_create) == year
    ).group_by(
        'month', models.Review.rating
    ).all()

    for res in results:
        print(res)
    
    # Phân loại kết quả vào dictionary
    for month, rating, count in results:
        rating = int(rating)  # Chuyển đổi rating thành int
        reviews_count[rating][month - 1] = count  # month - 1 để có chỉ số từ 0 đến 11

    # Định dạng kết quả
    formatted_result = {
        star: reviews_count[star] for star in range(1, 6)  # Giả sử bạn có 5 loại rating từ 1 đến 5
    }

    return formatted_result