# Use the UBI Go Toolset image
FROM registry.access.redhat.com/ubi9/go-toolset:1.21.11-7

# Set the working directory
WORKDIR /app

# Copy the Go module files
COPY go.mod go.sum ./

# Download the dependencies
RUN go mod download

# Copy the Go source code
COPY . .

# Set environment variables to control go build output
ENV GOBIN=/tmp/bin

# Create the output directory with appropriate permissions
RUN mkdir -p /tmp/bin

# Build the Go application
RUN go build -o /tmp/bin/fill_bucket .

# Command to run the Go application
CMD ["/tmp/bin/fill_bucket"]