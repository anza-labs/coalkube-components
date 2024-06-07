FROM --platform=${BUILDPLATFORM} docker.io/tonistiigi/xx:1.4.0 AS xx
FROM --platform=${BUILDPLATFORM} docker.io/library/golang:1.22-alpine AS build
COPY --from=xx / /

ARG TARGETPLATFORM
ARG VERSION

RUN apk add --no-cache \
    clang git lld && \
    xx-apk add \
    gcc musl-dev && \
    rm -rf /var/cache/apk/*

WORKDIR /work
COPY ./src /work/kine
COPY ./hack/ /work/hack
WORKDIR /work/kine

ENV CGO_ENABLED=1

RUN xx-go build \
        -o ./bin/kine \
        -mod=readonly \
        -trimpath \
        -ldflags="$(/work/hack/ldflags.sh ${VERSION})" \
        . && \
    xx-verify ./bin/kine

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
