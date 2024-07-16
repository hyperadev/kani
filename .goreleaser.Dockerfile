# syntax=docker/dockerfile:1@sha256:fe40cf4e92cd0c467be2cfc30657a680ae2398318afd50b0c80585784c604f28

## Setup stage
FROM alpine:3.20.1@sha256:b89d9c93e9ed3597455c90a0b88a8bbb5cb7188438f70953fede212a0c4394e0 as builder

RUN apk --no-cache add ca-certificates tzdata
RUN addgroup --gid 65532 kani && \
    adduser  --disabled-password --gecos "" \
    --home "/etc/kani" --no-create-home \
    -G kani --uid 65532 \
    --shell="/sbin/nologin" \
    kani

RUN mkdir -p /etc/kani/ && chown -R kani:kani /etc/kani/

## Run stage
FROM scratch

COPY --from=builder /etc/group /etc/group
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/kani /etc/kani
COPY kani /bin/kani

USER kani:kani
WORKDIR /etc/kani/
ENTRYPOINT ["/bin/kani"]
