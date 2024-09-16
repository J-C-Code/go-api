FROM golang:1.23.1 AS builder

# Set environment variables for Go build
ENV GOOS=linux GOARCH=amd64

COPY . /build

WORKDIR /build

# Build the Go application
RUN go build -o jomma-go-hello-world-api .

# Ensure the binary is executable
RUN chmod +x jomma-go-hello-world-api

# Use a smaller base image for the final stage
FROM alpine:latest

# Copy the binary from the builder stage
COPY --from=builder /build/jomma-go-hello-world-api /gomma-go-hello-world-api

EXPOSE 8080

ENTRYPOINT ["/gomma-go-hello-world-api"]
