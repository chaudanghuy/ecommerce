# Fullstack E-commerce Project React + Django

This repository contains an eCommerce web application built with a Django backend and a Next.js frontend. The project uses PostgreSQL as the database and includes a setup for running the application using Docker and Docker Compose.

## Project Structure

```plaintext
ecommerce/
├── backend/
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── manage.py
│   ├── backend/
│   │   ├── __init__.py
│   │   ├── settings.py
│   │   ├── urls.py
│   │   ├── wsgi.py
│   ├── ... (other Django app files)
├── frontend/
│   ├── Dockerfile
│   ├── package.json
│   ├── yarn.lock
│   ├── next.config.js
│   ├── pages/
│   │   ├── index.js
│   │   ├── _app.js
│   ├── ... (other Next.js files)
├── docker-compose.yml
└── README.md
```

## Prerequisites

- Docker
- Docker Compose

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Clone the Repository

```bash
git clone https://github.com/chaudanghuy/ecommerce.git
cd ecommerce
```

### Backend Setup

1. **Navigate to the backend directory:**

    ```bash
    cd backend
    ```

2. **Add `watchdog.sh` script:**

    Create a file named `watchdog.sh` in the `backend` directory with the following content:

    ```bash
    #!/bin/bash

    # Define the directory to watch
    WATCH_DIR=/app/backend

    # Run Gunicorn
    gunicorn backend.wsgi:application --bind 0.0.0.0:8000 &
    GUNICORN_PID=$!

    # Watch for changes in the directory
    watchmedo auto-restart --directory=$WATCH_DIR --pattern="*.py" --recursive -- gunicorn backend.wsgi:application --bind 0.0.0.0:8000
    ```

3. **Ensure the `watchdog.sh` script is executable:**

    ```bash
    chmod +x backend/watchdog.sh
    ```

### Frontend Setup

1. **Navigate to the frontend directory:**

    ```bash
    cd frontend
    ```

2. **Ensure the `pages` directory has required files:**

    - `pages/_app.js`:

      ```javascript
      import React from 'react';

      const MyApp = ({ Component, pageProps }) => {
        return <Component {...pageProps} />;
      };

      export default MyApp;
      ```

    - `pages/index.js`:

      ```javascript
      import React from 'react';

      const Home = () => {
        return (
          <div>
            <h1>Welcome to the Next.js Frontend</h1>
          </div>
        );
      };

      export default Home;
      ```

3. **Add `next.config.js` for hot reloading:**

    ```javascript
    module.exports = {
      webpackDevMiddleware: (config) => {
        config.watchOptions = {
          poll: 1000,
          aggregateTimeout: 300,
        };
        return config;
      },
    };
    ```

### Docker Setup

1. **Navigate to the root directory of the project:**

    ```bash
    cd ..
    ```

2. **Ensure `docker-compose.yml` is properly configured:**

    ```yaml
    version: '3.8'

    services:
      backend:
        build:
          context: ./backend
        container_name: backend
        command: /bin/bash -c "./watchdog.sh"
        volumes:
          - ./backend:/app/backend
        ports:
          - "8000:8000"
        depends_on:
          - db
        environment:
          - CLOUDINARY_URL=cloudinary://your_api_key:your_api_secret@your_cloud_name

      frontend:
        build:
          context: ./frontend
        container_name: frontend
        volumes:
          - ./frontend:/app/frontend
        ports:
          - "3000:3000"
        depends_on:
          - backend

      db:
        image: postgres:13
        container_name: db
        environment:
          POSTGRES_DB: postgres
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
        volumes:
          - postgres_data:/var/lib/postgresql/data
        ports:
          - "5432:5432"

      pgadmin:
        image: dpage/pgadmin4
        container_name: pgadmin
        environment:
          PGADMIN_DEFAULT_EMAIL: admin@example.com
          PGADMIN_DEFAULT_PASSWORD: admin
        ports:
          - "8080:80"
        depends_on:
          - db

    volumes:
      postgres_data:
    ```

### Running the Application

1. **Build and start the Docker containers:**

    ```bash
    docker-compose up --build
    ```
2. **Run Django migrations and create superuser**

    ```bash
    docker-compose run backend python manage.py migrate

    docker-compose run backend python manage.py createsuperuser
    ```
3. **Access the application:**

    - Django backend: [http://localhost:8000](http://localhost:8000)
    - Next.js frontend: [http://localhost:3000](http://localhost:3000)
    - pgAdmin: [http://localhost:8080](http://localhost:8080) (Use `admin@example.com` and `admin` as credentials)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
