FROM golang:alpine3.18 as builder

COPY . /app/
WORKDIR /app
RUN go build -o app

FROM alpine:3.18.2 AS base

COPY --from=builder /app/app /app/app
WORKDIR /app
EXPOSE 8080
ENTRYPOINT [ "/app/app" ]
