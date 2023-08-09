FROM python:slim

RUN python3 -m venv venv
RUN . /venv/bin/activate
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt

CMD [ "python3", "app.py" ]
