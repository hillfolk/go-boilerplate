ARG GO_VERSION=1.23

# Build stage
FROM golang:${GO_VERSION} AS builder

ARG GIT_COMMIT
ARG VERSION

ENV GO111MODULE=auto
ENV CGO_ENABLED=0

WORKDIR $GOPATH/src/github.com/hillfolk/go-boilerplate
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN make go/build
RUN echo "nonroot:x:65534:65534:Non root:/:" > /etc_passwd


# Final stage
FROM scratch

LABEL maintainer="Hillfolk <pjy1418@gmail.com>"

COPY --from=builder /go/bin/go-boilerplate /bin/go-boilerplate
COPY --from=builder /etc_passwd /etc/passwd

USER nonroot

ENTRYPOINT [ "go-boilerplate" ]
CMD [ "version" ]