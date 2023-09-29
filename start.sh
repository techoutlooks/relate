#!/bin/bash

npm install && npm run build
python manage.py migrate 
python -m manage collectstatic 

python manage.py runserver 0.0.0.0:8000
# gunicorn relate.wsgi:application --bind 0.0.0.0:8000 --workers 4