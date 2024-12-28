from datetime import datetime

from fastapi import APIRouter
from fastapi.requests import Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates


router = APIRouter(
    prefix="",
    tags=["Pages"],
    default_response_class=HTMLResponse
)

templates = Jinja2Templates(directory="blog/templates")

@router.get("/")
def main(req: Request):
    now = datetime.now()
    return templates.TemplateResponse("main.jinja", {"request": req, "date": now.replace(microsecond=0)})