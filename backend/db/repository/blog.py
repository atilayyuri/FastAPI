from sqlalchemy.orm import Session
from core.schemas.blog import CreateBlog
from core.models.blog import Blog

def create_new_blog(blog: CreateBlog, db: Session, author_id: int):
    new_blog = Blog(title=blog.title,
                     slug=blog.slug,
                     content=blog.content,
                     author_id=author_id)
    db.add(new_blog)
    db.commit()
    db.refresh(new_blog)
    return new_blog


def retreive_blog(id: int, db: Session):
    blog = db.query(Blog).filter(Blog.id == id).first()
    return blog


def list_blogs(db: Session):
    blogs = db.query(Blog).filter(Blog.published == True).all()
    return blogs