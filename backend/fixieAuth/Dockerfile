# FROM python:3.11-slim AS builder
# ENV PYTHONDONTWRITEBYTECODE=1
# ENV PYTHONNUNBUFFERED=1

# RUN mkdir /app
# WORKDIR /app

# RUN pip install --upgrade pip

# RUN apt-get update && \
#     apt-get install -y gcc default-libmysqlclient-dev libmariadb-dev pkg-config && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# COPY requirements.txt /app/
# RUN pip install --no-cache-dir -r requirements.txt


# FROM python:3.11-slim

# RUN apt-get update && \
#     apt-get install -y gcc default-libmysqlclient-dev libmariadb-dev pkg-config && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# RUN useradd -m -r appuser && \
#     mkdir /app && \
#     chown -R appuser /app

# COPY --from=builder /usr/local/lib/python3.11/site-packages/ /usr/local/lib/python3.11/site-packages/
# COPY --from=builder /usr/local/bin/ /usr/local/bin/

# WORKDIR /app

# COPY --chown=appuser:appuser . .

# ENV PYTHONDONTWRITEBYTECODE=1
# ENV PYTHONNUNBUFFERED=1

# USER appuser

# EXPOSE 8000
# CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "fixieAuth.wsgi:application"]

FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONNUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y unixodbc

COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .
CMD ["gunicorn", "fixieAuth.wsgi:application", "--bind", "0.0.0.0:8000"]