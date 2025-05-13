FROM python:3.9-slim

WORKDIR /app

ADD ./build/interview/requirements.txt /tmp/pre/requirements.txt

WORKDIR /tmp/pre/

# Install system dependencies needed for Whisper
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

RUN cat requirements.txt
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app