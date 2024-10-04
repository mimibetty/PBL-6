from typing import Annotated
from fastapi import APIRouter, Depends, status, HTTPException
from fastapi.security import OAuth2PasswordRequestForm
from blog import schemas, database, models, token, oauth2
from blog.hashing import Hash
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

router = APIRouter(tags=['Authentication'])

@router.post('/')
async def get_user(request: OAuth2PasswordRequestForm = Depends(), db: AsyncSession = Depends(database.get_db)):
    # user_info = await user.get_by_id(id, db)  # Ensure this is awaited
    # if user_info is None:
    #     raise HTTPException(status_code=404, detail="User not found")
    # return user_info
    try:
        result = await db.execute(select(models.User).filter(models.User.email == request.username))  # Chờ truy vấn
        user = result.scalars().first()  # Lấy người dùng
        if not user:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                                detail=f"User with the id {id} is not available")
        return user
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail=f"Error retrieving user: {str(e)}")
@router.post('/login')
async def login(request: OAuth2PasswordRequestForm = Depends(), db: AsyncSession = Depends(database.get_db)):
    result = await db.execute(select(models.User).filter(models.User.email == request.username))  # Chờ truy vấn
    user = result.scalars().first()  # Lấy người dùng

    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="Invalid Credentials")
    
    if not Hash.verify(user.password, request.password):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="Incorrect password")

    access_token = token.create_access_token(data={"email": user.email, "role": user.role})
    return {"access_token": access_token, "token_type": "bearer"}

@router.get('/current-user')
async def read_users_me(
    current_user: Annotated[schemas.User, Depends(oauth2.get_current_user)],
):
    return current_user
