## Prepeare a building stage to build the Go app
FROM golang:1.9 as builder
## Add dependencies
RUN go get -d -v golang.org/x/net/html
RUN go get -d -v golang.org/x/log
RUN go get -u github.com/synoa/helloworld

WORKDIR /go/src/github.com/synoa/helloworld/.
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o app .

## Create the actual docker container
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
## Copy the build binary
COPY --from=builder /go/src/github.com/synoa/helloworld/app .
CMD ["./app"]