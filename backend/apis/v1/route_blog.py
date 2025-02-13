from fastapi import APIRouter, status,Depends, HTTPException
from sqlalchemy.orm import Session  
from db.session import get_db
from core.schemas.blog import CreateBlog, ShowBlog
from db.repository.blog import create_new_blog, retreive_blog, list_blogs

router = APIRouter()

@router.post("/", response_model=ShowBlog, status_code=status.HTTP_201_CREATED)
def create_blog(blog: CreateBlog, db: Session = Depends(get_db)):
    return create_new_blog(blog=blog, db=db, author_id=1)


@router.get("/{id}", response_model=ShowBlog)
def get_blog(id:int, db: Session = Depends(get_db)):
    blog = retreive_blog(id=id, db=db)

    if not blog:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Blog with id {id} does not exist")
    return blog

@router.get("/", response_model=list[ShowBlog])
def get_all_blogs(db: Session = Depends(get_db)):
    blogs = list_blogs(db=db)
    return blogs