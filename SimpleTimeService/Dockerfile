# Build stage
FROM golang:1.25-alpine AS builder
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -o app .

# Run stage
FROM alpine

RUN adduser -D -u 8877 aryan
USER aryan

WORKDIR /app

COPY --from=builder /app/app .

EXPOSE 8080
CMD ["./app"]