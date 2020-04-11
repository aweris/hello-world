FROM golang:1.14.2-alpine as builder

ENV GO111MODULE=on

RUN apk add --no-cache git=~2.24.1-r0 \
                       make=4.2.1-r2

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN make hello-world

FROM alpine:3.11

COPY --from=builder /app/build/hello-world /hello-world

ENTRYPOINT [ "/hello-world"]