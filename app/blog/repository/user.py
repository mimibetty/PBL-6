
from sqlalchemy.orm import Session
from blog import models, schemas
from fastapi import HTTPException, status
from blog.hashing import Hash


def create(request: schemas.User, db: Session):
    new_user = models.User(
        username=request.username, email=request.email, password=Hash.hash_password(request.password), role = request.role)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user


def show(id: int, db: Session):
    user = db.query(models.User).filter(models.User.id == id).first()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail=f"User with the id {id} is not available")
    return user

def get_all(db: Session):
    users = db.query(models.User).all()
    return users
