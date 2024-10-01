
# Install the required dependencies
pip install -r requirements.txt

# Configure the Database in /config/database.py
uri = "mongodb://localhost:27017/{{db_name}}" example

# Run the app
```sh
uvicorn main:app --reload
```

# Access API Document
http://127.0.0.1:8000/docs

# Test authentication simple
```sh
uvicorn testAuthen:app --reload
```