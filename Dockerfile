# syntax=docker/dockerfile:1

## Build stage
FROM golang:1.20.1-alpine as build

RUN apk --no-cache add ca-certificates tzdata
RUN adduser --disabled-password --gecos "" \
    --home "/kani" --no-create-home \
    --shell="/sbin/nologin" --uid 65532 \
    kani

WORKDIR /build/kani
COPY . .

RUN go mod download
RUN go mod verify

RUN GOOS=$(go env GOOS) GOARCH=$(go env GOARCH) CGO_ENABLED=0 GOGC=off \
    go build -trimpath -ldflags "-s -w" -o /build/kani/dist/kani ./cmd/kani

## Run stage
FROM scratch

COPY --from=build /etc/group /etc/group
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=build /build/kani/dist/kani /bin/kani

USER kani:kani
EXPOSE 80/tcp
ENTRYPOINT ["/bin/kani"]
