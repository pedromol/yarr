FROM golang:alpine AS build
RUN apk add build-base git
WORKDIR /src
COPY . .
RUN CGO_ENABLED=1 go build -ldflags '-w -s' -tags "sqlite_foreign_keys timetzdata release" -o yarr src/main.go

FROM alpine:latest
RUN apk add --no-cache ca-certificates && \
    update-ca-certificates && \
    mkdir /data
COPY --from=build /src/yarr /usr/local/bin/yarr
EXPOSE 7070
CMD ["/usr/local/bin/yarr", "-addr", "0.0.0.0:7070", "-db", "/data/yarr.db"]
