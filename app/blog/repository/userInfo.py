
from sqlalchemy.orm import Session
from blog import models, schemas
from fastapi import HTTPException, status
from blog.hashing import Hash

def create_user_info_by_userid(request: schemas.UserInfoBase, user_id: int, db: Session):
    try:
        new_user_info = models.UserInfo(
            business_description=request.business_description,
            phone_number=request.phone_number,
            user_id=user_id
        )
        db.add(new_user_info)
        db.commit()
        db.refresh(new_user_info)
        return new_user_info
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Failed to create user info")


def get_user_info_by_userid(user_id: int, db: Session):
    try:
        user_info = db.query(models.UserInfo).filter(models.UserInfo.user_id == user_id).first()  # Chờ truy vấn
        if not user_info:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                detail=f"UserInfo with the user_id {user_id} is not available")
        return user_info
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Failed to retrieve user info")


def update_user_info_by_userid(user_id: int, request: schemas.UserInfoBase, db: Session):
    try:
        user_info = db.query(models.UserInfo).filter(models.UserInfo.user_id == user_id).first()  # Chờ truy vấn
        if not user_info:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                detail=f"UserInfo with the user_id {user_id} is not available")
        user_info.business_description = request.business_description
        user_info.phone_number = request.phone_number
        db.commit()
        db.refresh(user_info)
        return user_info
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Failed to update user info")


def delete_user_info_by_userid(user_id: int, db: Session):
    try:
        user_info = db.query(models.UserInfo).filter(models.UserInfo.user_id == user_id).first()  # Chờ truy vấn
        if not user_info:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                detail=f"UserInfo with the user_id {user_id} is not available")
        db.delete(user_info)
        db.commit()
        return {"message": "UserInfo deleted successfully"}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Failed to delete user info")
