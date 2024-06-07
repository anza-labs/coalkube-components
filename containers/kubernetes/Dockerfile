FROM --platform=${BUILDPLATFORM} docker.io/tonistiigi/xx:1.4.0 AS xx
FROM --platform=${BUILDPLATFORM} docker.io/library/golang:1.22 AS build
COPY --from=xx / /

ARG TARGETPLATFORM
ARG VERSION

WORKDIR /work
COPY ./src/ /work/kubernetes
COPY ./hack/ /work/hack
WORKDIR /work/kubernetes

ENV CGO_ENABLED=0

ARG BIN

RUN xx-go build \
        -o ./bin/${BIN} \
        -mod=readonly \
        -trimpath \
        -ldflags="$(/work/hack/ldflags.sh ${VERSION})" \
        ./cmd/${BIN} && \
    xx-verify ./bin/${BIN}

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
