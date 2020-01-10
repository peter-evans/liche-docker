FROM golang:1.13.6-alpine3.10 as builder

ENV LICHE_VERSION e144e0808a750764fae36a79bad12e146effdd36

ENV CGO_ENABLED=0 GO111MODULE=on GOOS=linux

RUN apk add --no-cache git \
 && git clone https://github.com/raviqqe/liche.git \
 && cd liche \
 && git reset --hard $LICHE_VERSION \
 && go build -o liche


FROM alpine:3.11.2

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

COPY --from=builder /go/liche/liche /usr/bin/liche

ENTRYPOINT ["liche"]
