from sqlalchemy.orm import Session
from core.schemas.user import UserCreate
from core.models.user import User
from core.hashing import Hasher

def create_new_user(user: UserCreate, db: Session):
    new_user = User(
                email=user.email, 
                password=Hasher.get_password_hash(user.password),
                is_active=True,
                )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return user