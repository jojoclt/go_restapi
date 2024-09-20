FROM golang:1.22 as build

# Set destination for COPY
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./

# Build the Go application with static linking
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /main

# Debugging step: List files after build
RUN ls -la /main

FROM scratch
COPY --from=build /main /main
ENTRYPOINT ["/main"]
EXPOSE 8000