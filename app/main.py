from fastapi import FastAPI

app = FastAPI()


# gives a route for a get request
@app.get("/")
def root():
    return {"Hello": "World"}
