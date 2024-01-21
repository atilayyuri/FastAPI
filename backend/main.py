from fastapi import FastAPI

app = FastAPI(title="Blog", version="0.1.0")


# gives a route for a get request
@app.get("/")
async def root():
    
    return {"msg": "Hello FastAPI"}
