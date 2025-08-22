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

# EXPOSE 8001
# CMD ["gunicorn", "--bind", "0.0.0.0:8001", "--workers", "3", "fixieTasks.wsgi:application"]

FROM python:3.11-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# RUN apt-get update && apt-get install -y unixodbc
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg ca-certificates apt-transport-https \
    unixodbc unixodbc-dev build-essential \
  && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg; \
  . /etc/os-release; \
  echo "deb [arch=amd64,arm64 signed-by=/etc/apt/trusted.gpg.d/microsoft.gpg] https://packages.microsoft.com/${ID}/${VERSION_ID}/prod ${VERSION_CODENAME} main" \
    > /etc/apt/sources.list.d/mssql-release.list; \
  apt-get update; \
  ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql18 mssql-tools18; \
  rm -rf /var/lib/apt/lists/*; \
  echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' > /etc/profile.d/mssql-tools.sh

# RUN pip install --no-cache-dir pyodbc mssql-django

COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .
CMD ["gunicorn", "fixieTasks.wsgi:application", "--bind", "0.0.0.0:8001", "--log-level", "info", "--access-logfile", "-", "--error-logfile", "-", "--capture-output"]