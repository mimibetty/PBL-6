from fastapi import FastAPI
from pydantic import BaseModel
import httpx
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Thêm middleware CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Hoặc danh sách các nguồn mà bạn muốn cho phép
    allow_credentials=True,
    allow_methods=["*"],  # Hoặc danh sách các phương thức mà bạn muốn cho phép
    allow_headers=["*"],  # Hoặc danh sách các header mà bạn muốn cho phép
)

GOONG_API_URL = "https://rsapi.goong.io"
API_KEY = "ArPlUISaEBAdJFTABi9dcNGcue8WQ4cOAuGcNoBE"

class AutoCompleteRequest(BaseModel):
    input: str

@app.post("/autocomplete")
async def autocomplete(request: AutoCompleteRequest):
    async with httpx.AsyncClient() as client:
        response = await client.get(f"{GOONG_API_URL}/Place/AutoComplete", params={
            "api_key": API_KEY,
            "input": request.input
        })
        return response.json()

class PlaceDetailRequest(BaseModel):
    place_id: str

@app.post("/place-detail")
async def place_detail(request: PlaceDetailRequest):
    async with httpx.AsyncClient() as client:
        response = await client.get(f"{GOONG_API_URL}/Place/Detail", params={
            "api_key": API_KEY,
            "place_id": request.place_id,
        })
        return response.json()