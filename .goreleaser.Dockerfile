# syntax=docker/dockerfile:1

## Setup stage
FROM alpine:3.22.1@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1 as builder

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
