from fastapi import FastAPI
from blog import models
from blog.database import engine #, create_sample_data, delete_all
from blog.routers import action, blog,tour, user, authentication, userInfo, city, review, destination,authenGoogle, destination, hotel, restaurant, address, dashboard, tag, image,trip
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.sessions import SessionMiddleware
import os
from dotenv import load_dotenv

from blog.repository import destination as destination_repository
from blog.database import SessionLocal, get_db
from blog.repository import dataImport, dataCrawler

load_dotenv()
        
app = FastAPI()
SESSION_SECRET_KEY = os.getenv("SESSION_SECRET_KEY")
# print(SESSION_SECRET_KEY)   
# Session middleware phải được thêm trước CORS middleware
app.add_middleware(
    SessionMiddleware, 
    secret_key=SESSION_SECRET_KEY,
    max_age=3600
)

# Thêm CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Địa chỉ của ứng dụng Vue
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(action.router)
app.include_router(authenGoogle.router)
app.include_router(authentication.router)
app.include_router(user.router)
app.include_router(userInfo.router)
app.include_router(address.router)
app.include_router(city.router)
app.include_router(destination.router)
app.include_router(hotel.router)
app.include_router(restaurant.router)
app.include_router(review.router)
app.include_router(tour.router)
app.include_router(dashboard.router)
app.include_router(tag.router)
app.include_router(image.router)
app.include_router(trip.router)


async def crawl_destination_data():
    db = next(get_db())
    await dataImport.main(db=db)
    
# @app.on_event("startup")
# async def startup_event():
    # delete_all(engine=engine)
    # models.Base.metadata.drop_all(bind=engine)
    # models.Base.metadata.create_all(engine)
    # await create_sample_data() 
    # await dataImport.delete_duplicate_dest(db=next(get_db()), start_id=1784, end_id=1785)
    # dataCrawler.crawl_data_by_city(out_file_path="classified_data.json", city_json_file_path="option.json")
    # dataImport.check_city_in_json()
    # await crawl_destination_data()
    # dataImport.process_hotel_rest(db=next(get_db()))
    # dataImport.delete_noUse_address(db=next(get_db()))
    # db = SessionLocal()
    # try:
    #     destination_repository.update_all_destination_ratings(db)
    # finally:
    #     db.close()

# if __name__ == "__main__":
#     import uvicorn
#     uvicorn.run(app, host="0.0.0.0", port=8000)


