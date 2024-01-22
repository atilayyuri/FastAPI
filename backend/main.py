from fastapi import FastAPI
from core.settings import settings

app = FastAPI(title=settings.PROJECT_TITLE, version=settings.PROJECT_VERSION)


# gives a route for a get request
@app.get("/")
async def root():
    
    return {"msg": "Hello FastAPI"}
