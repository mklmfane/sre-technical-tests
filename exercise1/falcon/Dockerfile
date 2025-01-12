# Use the official Golang image
FROM golang:1.20-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy go.mod and go.sum to the working directory
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download


# Copy the entire source code to the working directory
COPY . .

# Build the Go application
RUN go build -o main .

RUN apk add --no-cache redis
# Expose the port the application will run on
EXPOSE 8000

# Run the application
CMD ["./main"]

