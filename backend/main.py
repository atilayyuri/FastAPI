from fastapi import FastAPI
from core.config import settings
from apis.base import api_router

from db.session import engine
from db.base_class import Base

def include_router(app):
    app.include_router(api_router)

def create_tables():
    Base.metadata.create_all(bind=engine)

def start_application():
    app = FastAPI(title=settings.PROJECT_TITLE, version=settings.PROJECT_VERSION)
    include_router(app)
    create_tables()
    return app

app = start_application()

# gives a route for a get request
@app.get("/")
async def root():
    
    return {"msg": "Hello FastAPI"}



# SYNCHRONOUS

# You are in a queue to get a movie ticket. You cannot get one until everybody in front of you gets one, and the same applies to the people queued behind you.

# ASYNCHRONOUS

# You are in a restaurant with many other people. You order your food. Other people can also order their food, they don't have to wait for your food to be cooked and served to you before they can order. In the kitchen restaurant workers are continuously cooking, serving, and taking orders. People will get their food served as soon as it is cooked.