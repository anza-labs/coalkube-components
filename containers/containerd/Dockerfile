FROM --platform=${BUILDPLATFORM} docker.io/library/alpine:3.20 AS alpine

ARG VERSION
ARG TARGETARCH

WORKDIR /work

RUN wget https://github.com/containerd/containerd/releases/download/v${VERSION}/containerd-static-${VERSION}-linux-${TARGETARCH}.tar.gz && \
    tar -xf containerd-static-${VERSION}-linux-${TARGETARCH}.tar.gz

ARG TARGETPLATFORM
FROM --platform=${TARGETPLATFORM} scratch
ARG VERSION
ARG MAINTAINERS=''

LABEL org.opencontainers.image.title="containerd"
LABEL org.opencontainers.image.authors="${MAINTAINERS}"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.license="Apache-2.0"
LABEL org.opencontainers.image.documentation="https://containerd.io"
LABEL org.opencontainers.image.base.name="scratch"
LABEL dev.anza-labs.image.executable="/usr/bin/containerd"

WORKDIR /usr/bin
COPY --from=alpine /work/bin/containerd /usr/bin/
