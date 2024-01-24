from sqlalchemy.orm import Session
from core.schemas.blog import CreateBlog
from core.models.blog import Blog

def create_new_blog(blog: CreateBlog, db: Session, author_id: int):
    new_blog = Blog(title=blog.title,
                     author_id=author_id,
                     content=blog.content,
                     author_id=author_id)
    db.add(new_blog)
    db.commit()
    db.refresh(new_blog)
    return new_blog