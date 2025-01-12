# Use the official Node.js image
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package.json package-lock.json ./

RUN apk add --no-cache curl

# Install dependencies
RUN npm install

# Copy the entire application code into the container
COPY . .

# Expose the port that the application listens on
EXPOSE 3000

# Start the application
CMD ["npm", "start"]

