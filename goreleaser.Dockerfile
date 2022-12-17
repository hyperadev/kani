# syntax=docker/dockerfile:1

## Build stage
FROM golang:1.19.4-alpine as build

RUN adduser --disabled-password --gecos "" \
    --home "/kani" --no-create-home \
    --shell="/sbin/nologin" --uid 65532 \
    kani

## Run stage
FROM scratch

COPY --from=build /etc/group /etc/group
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY kani /bin/kani

USER kani:kani
EXPOSE 80/tcp
ENTRYPOINT ["/bin/kani"]
