from sqlalchemy.ext.asyncio import AsyncSession
from blog import models, schemas
from fastapi import HTTPException, status
from blog.hashing import Hash
from sqlalchemy import select


async def create(request: schemas.User, db: AsyncSession):
    try:
        new_user = models.User(
            username=request.username,
            email=request.email,
            password=Hash.hash_password(request.password)
        )
        db.add(new_user)
        await db.commit()  # Chờ hoàn tất việc commit
        await db.refresh(new_user)  # Chờ làm mới đối tượng mới
        return new_user
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error creating user: {str(e)}")

async def create_business_admin(request: schemas.User, db: AsyncSession):
    try:
        new_user = models.User(
            username=request.username,
            email=request.email,
            password=Hash.hash_password(request.password),
            role=request.role
        )
        db.add(new_user)
        await db.commit()  # Chờ hoàn tất việc commit
        await db.refresh(new_user)  # Chờ làm mới đối tượng mới
        return new_user
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error creating business admin: {str(e)}")

async def get_by_id(id: int, db: AsyncSession):
    try:
        user = await db.execute(select(models.User).filter(models.User.id == id))  # Chờ truy vấn
        user = user.scalars().first()
        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                detail=f"User with the id {id} is not available")
        return user
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error retrieving user: {str(e)}")

async def get_all(db: AsyncSession):
    try:
        print("fuck")
        result = await db.execute(select(models.User))  # Chờ truy vấn
        print("hell na")
        return result.scalars().all()
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error retrieving users: {str(e)}")

async def get_by_email(email: str, db: AsyncSession):
    try:
        user = await db.execute(select(models.User).filter(models.User.email == email))  # Chờ truy vấn
        user = user.scalars().first()
        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                detail=f"User with the email {email} is not available")
        return user
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error retrieving user by email: {str(e)}")

async def update(id: int, request: schemas.User, db: AsyncSession):
    try:
        user = await db.execute(select(models.User).filter(models.User.id == id))  # Chờ truy vấn
        user = user.scalars().first()
        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                detail=f"User with the id {id} is not available")

        user.username = request.username
        user.email = request.email
        if request.password:  # Chỉ cập nhật password nếu có
            user.password = Hash.hash_password(request.password)

        await db.commit()  # Chờ hoàn tất việc commit
        await db.refresh(user)  # Chờ làm mới đối tượng mới
        return user
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error updating user: {str(e)}")

async def delete(id: int, db: AsyncSession):
    try:
        user = await db.execute(select(models.User).filter(models.User.id == id))  # Chờ truy vấn
        user = user.scalars().first()
        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                detail=f"User with the id {id} is not available")

        await db.delete(user)  # Chờ xóa đối tượng
        await db.commit()  # Chờ hoàn tất việc commit
        return {"detail": "User deleted successfully"}
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error deleting user: {str(e)}")
