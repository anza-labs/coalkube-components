FROM --platform=${BUILDPLATFORM} docker.io/library/golang:1.22 AS build

ARG VERSION

WORKDIR /work
RUN git clone --branch ${VERSION} --single-branch https://github.com/k3s-io/kine.git
WORKDIR /work/kine

ARG TARGETARCH

ENV GOOS=linux
ENV GOARCH=${TARGETARCH}
ENV CGO_ENABLED=0

RUN go build \
    -o ./bin/kine \
    -mod=readonly \
    -trimpath \
    -ldflags="-extldflags=-static -s -w" \
    .

ARG TARGETPLATFORM
FROM --platform=${TARGETPLATFORM} scratch
ARG VERSION
ARG MAINTAINERS=''

LABEL org.opencontainers.image.title="kine"
LABEL org.opencontainers.image.authors="${MAINTAINERS}"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.license="Apache-2.0"
LABEL org.opencontainers.image.documentation="https://github.com/k3s-io/kine"
LABEL org.opencontainers.image.base.name="scratch"

WORKDIR /usr/bin
COPY --from=build /work/kine/bin/kine /usr/bin/
