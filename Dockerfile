# syntax=docker/dockerfile:1@sha256:db1ff77fb637a5955317c7a3a62540196396d565f3dd5742e76dddbb6d75c4c5

## Build stage
FROM golang:1.22.6-alpine@sha256:1a478681b671001b7f029f94b5016aed984a23ad99c707f6a0ab6563860ae2f3 as build

RUN apk --no-cache add ca-certificates tzdata
RUN addgroup --gid 65532 kani && \
    adduser  --disabled-password --gecos "" \
    --home "/etc/kani" --no-create-home \
    -G kani --uid 65532 \
    --shell="/sbin/nologin" \
    kani

RUN mkdir -p /etc/kani/ && chown -R kani:kani /etc/kani/

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
COPY --from=build /etc/kani /etc/kani
COPY --from=build /build/kani/dist/kani /bin/kani

USER kani:kani
WORKDIR /etc/kani/
ENTRYPOINT ["/bin/kani"]
