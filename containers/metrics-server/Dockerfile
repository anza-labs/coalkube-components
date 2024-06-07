FROM --platform=${BUILDPLATFORM} docker.io/tonistiigi/xx:1.4.0 AS xx
FROM --platform=${BUILDPLATFORM} docker.io/library/golang:1.22 AS build
COPY --from=xx / /

ARG TARGETPLATFORM
ARG VERSION

WORKDIR /work
COPY ./src/ /work/metrics-server
COPY ./hack/ /work/hack
WORKDIR /work/metrics-server

ENV CGO_ENABLED=0

RUN xx-go build \
        -o ./bin/metrics-server \
        -mod=readonly \
        -trimpath \
        -ldflags="$(/work/hack/ldflags.sh ${VERSION})" \
        ./cmd/metrics-server && \
    xx-verify ./bin/metrics-server

ARG TARGETPLATFORM
FROM --platform=${TARGETPLATFORM} scratch
ARG VERSION
ARG MAINTAINERS=''

LABEL org.opencontainers.image.title="metrics-server"
LABEL org.opencontainers.image.authors="${MAINTAINERS}"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.license="Apache-2.0"
LABEL org.opencontainers.image.documentation="https://github.com/kubernetes-sigs/metrics-server"
LABEL org.opencontainers.image.base.name="scratch"

WORKDIR /usr/bin
COPY --from=build /work/metrics-server/bin/metrics-server /usr/bin/
