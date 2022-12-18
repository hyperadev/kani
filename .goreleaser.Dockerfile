# syntax=docker/dockerfile:1

## Setup stage
FROM alpine:3.17.0 as builder

RUN apk --update add ca-certificates tzdata
RUN adduser  --disabled-password --gecos "" \
    --home "/kani" --no-create-home \
    --shell="/sbin/nologin" --uid 65532 \
    kani

## Run stage
FROM scratch

COPY --from=builder /etc/group /etc/group
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY kani /bin/kani

USER kani:kani
EXPOSE 80/tcp
ENTRYPOINT ["/bin/kani"]
