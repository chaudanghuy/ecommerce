#!/bin/bash

# Define the directory to watch
WATCH_DIR=/app/backend

# Run Gunicorn
gunicorn backend.wsgi:application --bind 0.0.0.0:8000 &
GUNICORN_PID=$!

# Watch for changes in the directory
watchmedo auto-restart --directory=$WATCH_DIR --pattern="*.py" --recursive --kill-after 2 -- gunicorn backend.wsgi:application --bind 0.0.0.0:8000
