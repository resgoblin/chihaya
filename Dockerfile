
FROM golang:1.26-alpine AS build-env

LABEL maintainer="Jimmy Zelinskie <jimmyzelinskie+git@gmail.com>"

RUN apk add --no-cache curl git

WORKDIR /go/src/github.com/chihaya/chihaya

COPY go.mod go.sum ./

# Resolve dependencies, including your patched jose fork.
RUN go mod download

# Copy the remaining source code.
COPY . .

# Compile Chihaya.
RUN CGO_ENABLED=0 go install ./cmd/chihaya

FROM alpine:latest

RUN apk add --no-cache ca-certificates

COPY --from=build-env /go/bin/chihaya /chihaya

RUN adduser -D chihaya

EXPOSE 6880 6969

USER chihaya

ENTRYPOINT ["/chihaya"]
