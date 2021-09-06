# build stage
FROM golang:alpine AS builder
RUN apk add --no-cache build-base
WORKDIR /src
COPY shiori/. .
RUN GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"'

# server image
FROM debian:buster-slim
LABEL org.opencontainers.image.authors="tekmanic"
COPY --from=builder /src/shiori /usr/local/bin/
ENV SHIORI_DIR /srv/shiori/
EXPOSE 8080
CMD ["/usr/local/bin/shiori", "serve"]