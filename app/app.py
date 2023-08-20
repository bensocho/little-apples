from flask import Flask, render_template
from pymongo import MongoClient
import os
import time

# sets the mongo URI from the envronment variable
mongo_uri = os.environ.get("MONGO_URI")

app = Flask(__name__, template_folder='/app/templates')

client = MongoClient(mongo_uri)
def connect_to_mongo():
    while client == None:
        try:
            client = MongoClient(mongo_uri)
            return client
        except Exception as e:
            print(f"Error connecting to MongoDB: {e}")
            # Retry after a delay
            time.sleep(5)

db = client.my_flask_db
fruits_collection = db.fruits



@app.route('/')
def apples():
    apples_data = fruits_collection.find_one({"name": "apples"})
    if apples_data:
        apples_qty = apples_data.get("qty")
    else:
        apples_qty = "N/A"
    
    return render_template('index.html', apples_qty=apples_qty)

# running the app    
app.run(host="0.0.0.0")

