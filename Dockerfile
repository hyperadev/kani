# syntax=docker/dockerfile:1

## Build stage
FROM golang:1.19.3-alpine as build

WORKDIR /build/kani
COPY . .

RUN GOOS=$(go env GOOS) GOARCH=$(go env GOARCH) CGO_ENABLED=0 GOGC=off \
    go build -ldflags "-s -w" -o dist/kani ./cmd/kani

## Run stage
FROM scratch

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /build/kani/dist/kani /bin/kani

ENTRYPOINT ["/bin/kani"]
