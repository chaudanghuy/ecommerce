# Use the official Node.js image.
FROM node:18.17.0

# Set the working directory.
WORKDIR /app/frontend

# Install dependencies.
COPY package.json yarn.lock ./
RUN yarn install

# Copy the project files.
COPY . .

# Expose the port the app runs on.
EXPOSE 3000

# Command to run the app.
CMD ["yarn", "dev"]