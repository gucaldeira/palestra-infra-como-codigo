FROM golang:1.8 AS builder

WORKDIR /go/src/fib
COPY fib.go .
RUN go build /go/src/fib/fib.go

FROM debian:buster-slim
EXPOSE 9090

#Copy app jar file
COPY --from=0 /go/src/fib/fib /usr/bin

ENTRYPOINT ["fib"]