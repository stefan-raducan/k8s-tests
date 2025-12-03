#!/bin/bash
set -e

docker build -t random-api .
docker tag random-api stefanraducan/random-api:latest
docker push stefanraducan/random-api:latest

# Run with volume mount for auto-reload
# -v "$(pwd):/app": Mounts current directory to /app in container
# --reload: Tells uvicorn to reload on file changes
echo "Starting random-api with auto-reload on port 8000..."
docker run --rm -it \
  -p 8000:8000 \
  -v "$(pwd):/app" \
  random-api \
  uvicorn main:app --host 0.0.0.0 --port 8000 --reload

# example request:
# curl "http://localhost:8000/random?min_nr=-5&max_nr=5"
