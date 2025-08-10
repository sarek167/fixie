FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONNUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y unixodbc

COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .
CMD ["gunicorn", "fixieAvatar.wsgi:application", "--bind", "0.0.0.0:8002"]