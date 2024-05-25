# /backend/Dockerfile

# Use a lightweight Python image
FROM python:3.9

# Set environment variables to ensure Python outputs are directed to the console and no bytecode files are generated
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Set the working directory for the container
WORKDIR /app/backend

# Copy the Python dependency file into the container
COPY requirements.txt .

# Install system dependencies required for GeoDjango, including compilation dependencies and geospatial libraries
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project into the container
COPY . .

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "backend.wsgi:application"]