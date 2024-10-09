#!/bin/bash
cd /home/site/wwwroot/app
export PYTHONPATH=/home/site/wwwroot/app
gunicorn main:app --workers 4 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000 --timeout 600

