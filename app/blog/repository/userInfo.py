from sqlalchemy.ext.asyncio import AsyncSession
from blog import models, schemas
from fastapi import HTTPException, status
from sqlalchemy import select

async def create_user_info(request: schemas.UserInfoBase, user_id: int, db: AsyncSession):
    try:
        new_user_info = models.UserInfo(
            business_description=request.business_description,
            phone_number=request.phone_number,
            user_id=user_id
        )
        db.add(new_user_info)
        await db.commit()  # Chờ hoàn tất việc commit
        await db.refresh(new_user_info)  # Chờ làm mới đối tượng mới
        return new_user_info
    except Exception as e:
        await db.rollback()
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Failed to create user info")

async def get_user_info(id: int, db: AsyncSession):
    try:
        result = await db.execute(select(models.UserInfo).filter(models.UserInfo.id == id))  # Chờ truy vấn
        user_info = result.scalars().first()
        if not user_info:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                detail=f"UserInfo with the id {id} is not available")
        return user_info
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Failed to retrieve user info")

async def update_user_info(id: int, request: schemas.UserInfoBase, db: AsyncSession):
    try:
        result = await db.execute(select(models.UserInfo).filter(models.UserInfo.id == id))  # Chờ truy vấn
        user_info = result.scalars().first()
        if not user_info:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                detail=f"UserInfo with the id {id} is not available")
        
        user_info.business_description = request.business_description
        user_info.phone_number = request.phone_number
        await db.commit()  # Chờ hoàn tất việc commit
        await db.refresh(user_info)  # Chờ làm mới đối tượng mới
        return user_info
    except Exception as e:
        await db.rollback()
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Failed to update user info")

async def delete_user_info(id: int, db: AsyncSession):
    try:
        result = await db.execute(select(models.UserInfo).filter(models.UserInfo.id == id))  # Chờ truy vấn
        user_info = result.scalars().first()
        if not user_info:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                detail=f"UserInfo with the id {id} is not available")
        
        await db.delete(user_info)  # Chờ xóa đối tượng
        await db.commit()  # Chờ hoàn tất việc commit
        return {"message": "UserInfo deleted successfully"}
    except Exception as e:
        await db.rollback()
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Failed to delete user info")
