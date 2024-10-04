from fastapi import APIRouter, HTTPException, Depends, status
from blog import database, schemas, models, oauth2
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from blog.repository import user
from sqlalchemy import select

router = APIRouter(
    prefix="/user",
    tags=['Users']
)

@router.post('/', response_model=schemas.ShowUser)
async def create_user(request: schemas.User, db: AsyncSession = Depends(database.get_db)):
    return await user.create(request, db)

@router.get('/{id}', response_model=schemas.ShowUser)
async def get_user(id: int, db: AsyncSession = Depends(database.get_db)):
    # user_info = await user.get_by_id(id, db)  # Ensure this is awaited
    # if user_info is None:
    #     raise HTTPException(status_code=404, detail="User not found")
    # return user_info
    try:
        user = await db.execute(select(models.User).filter(models.User.id == id))  # Chờ truy vấn
        user = user.scalars().first()
        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                detail=f"User with the id {id} is not available")
        return schemas.ShowUser.from_orm(user)
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error retrieving user: {str(e)}")

@router.get('/', response_model=List[schemas.ShowUser])
async def admin_all(db: AsyncSession = Depends(database.get_db), current_user: schemas.User = Depends(oauth2.get_current_user)):
    try:
        if current_user.role == "admin":
            print("yess")
            return await user.get_all(db)
        else:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You do not have permission to access this resource.")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error retrieving user by email: {str(e)}")

        
