from fastapi import FastAPI

app = FastAPI()


# gives a route for a get request
@app.get("/")
async def root():
    await foo()
    return {"Hello": "World"}
