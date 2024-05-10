FROM --platform=${BUILDPLATFORM} docker.io/library/golang:1.22 AS build

ARG VERSION

WORKDIR /work
RUN git clone --branch ${VERSION} --single-branch https://github.com/kubernetes/kubernetes.git
WORKDIR /work/kubernetes

ARG TARGETARCH

ENV GOOS=linux
ENV GOARCH=${TARGETARCH}
ENV CGO_ENABLED=0

ARG BIN

RUN go build \
    -o ./bin/${BIN} \
    -mod=readonly \
    -trimpath \
    -ldflags="-extldflags=-static -s -w" \
    ./cmd/${BIN}

ARG TARGETPLATFORM
FROM --platform=${TARGETPLATFORM} scratch
ARG BIN
ARG VERSION
ARG MAINTAINERS=''

LABEL org.opencontainers.image.title="${BIN}"
LABEL org.opencontainers.image.authors="${MAINTAINERS}"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.license="Apache-2.0"
LABEL org.opencontainers.image.documentation="https://kubernetes.io/docs/home"
LABEL org.opencontainers.image.base.name="scratch"

WORKDIR /usr/bin
COPY --from=build /work/kubernetes/bin/${BIN} /usr/bin/
