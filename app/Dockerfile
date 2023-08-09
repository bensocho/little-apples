FROM python:slim

RUN python3 -m venv venv
RUN . /venv/bin/activate
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENV MONGO_URI=mongodb://root:password@my-mongo:27017/my_flask_db
CMD [ "python3", "app.py" ]
