# ---- Builder Stage ----
FROM golang:1.24-alpine AS builder

# Install build dependencies (if any, but not required for pure Go)
RUN apk add --no-cache ca-certificates

WORKDIR /app

# Copy go module files first for better layer caching
COPY go.mod go.sum ./
RUN go mod download

# Copy the entire source
COPY . .

# Build a statically linked binary
ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64
RUN go build -ldflags="-s -w" -o result-app .

# ---- Final Stage ----
FROM scratch

# Import CA certificates from builder (for HTTPS calls if needed)
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Set working directory
WORKDIR /app

# Copy the binary and required assets
COPY --from=builder /app/result-app .
COPY --from=builder /app/static ./static
COPY --from=builder /app/templates ./templates

# Expose the application port
EXPOSE 5001

# Run the binary
CMD ["./result-app"]