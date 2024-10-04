from fastapi import FastAPI
from blog import models
from blog.database import engine, create_sample_data
from blog.routers import blog, user, authentication, userInfo
from fastapi.middleware.cors import CORSMiddleware

        
app = FastAPI()

# Thêm CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8080"],  # Địa chỉ của ứng dụng Vue
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

models.Base.metadata.drop_all(bind=engine)
models.Base.metadata.create_all(engine)
@app.on_event("startup")
async def startup_event():
    await create_sample_data() 

app.include_router(authentication.router)
app.include_router(user.router)
app.include_router(userInfo.router)


# if __name__ == "__main__":
#     import uvicorn
#     uvicorn.run(app, host="0.0.0.0", port=8000)