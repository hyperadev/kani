# syntax=docker/dockerfile:1

# Build stage
FROM golang:1.19.1-alpine as build

WORKDIR /build/kani
COPY . .

RUN GOOS=$(go env GOOS) GOARCH=$(go env GOARCH) go build ./cmd/kani

# Run stage
FROM golang:1.19.1-alpine

RUN adduser -D kani
USER kani

WORKDIR /home/kani
COPY --from=build --chown=kani:kani /build/kani/kani ./

CMD ["./kani"]