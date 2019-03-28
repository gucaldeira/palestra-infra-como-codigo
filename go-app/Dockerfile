FROM golang:1.12 AS builder

WORKDIR /go/src/fib
COPY fib.go .
RUN go build /go/src/fib/fib.go

FROM gcr.io/distroless/base

EXPOSE 9090
COPY --from=builder /go/src/fib/fib /
CMD ["/fib"]