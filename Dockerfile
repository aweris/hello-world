FROM golang:1.15.3-alpine as builder

ENV GO111MODULE=on

RUN apk add --no-cache git=~2.26.2-r0 \
                       make=4.3-r0

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN make build

FROM alpine:3.12

COPY --from=builder /app/build/hello-world /hello-world

ENTRYPOINT [ "/hello-world"]