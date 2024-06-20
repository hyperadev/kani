# syntax=docker/dockerfile:1@sha256:e87caa74dcb7d46cd820352bfea12591f3dba3ddc4285e19c7dcd13359f7cefd

## Setup stage
FROM alpine:3.20.0@sha256:77726ef6b57ddf65bb551896826ec38bc3e53f75cdde31354fbffb4f25238ebd as builder

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
