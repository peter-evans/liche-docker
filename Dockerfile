FROM golang:1.13.3-alpine3.10 as builder

ENV LICHE_VERSION 3b20c094c539eb403d232c48ae0d9c6210db5a61

RUN apk add --no-cache git \
 && git clone https://github.com/raviqqe/liche.git /go/src/github.com/raviqqe/liche \
 && cd /go/src/github.com/raviqqe/liche \
 && git reset --hard $LICHE_VERSION \
 && CGO_ENABLED=0 GOOS=linux go get /go/src/github.com/raviqqe/liche


FROM alpine:3.10.3

LABEL \
  maintainer="Peter Evans <mail@peterevans.dev>" \
  org.opencontainers.image.title="liche" \
  org.opencontainers.image.description="A Docker image for Liche, a fast link checker for Markdown and HTML" \
  org.opencontainers.image.authors="Peter Evans <mail@peterevans.dev>" \
  org.opencontainers.image.url="https://github.com/peter-evans/liche-docker" \
  org.opencontainers.image.vendor="https://peterevans.dev" \
  org.opencontainers.image.licenses="MIT"

COPY LICENSE README.md /

RUN apk add --no-cache ca-certificates

COPY --from=builder /go/bin/liche /usr/bin/liche

ENTRYPOINT ["liche"]
