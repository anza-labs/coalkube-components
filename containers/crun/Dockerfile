FROM --platform=${BUILDPLATFORM} docker.io/library/alpine:3.20 AS alpine

ARG VERSION
ARG TARGETARCH

WORKDIR /work

RUN wget -O crun https://github.com/containers/crun/releases/download/${VERSION}/crun-${VERSION}-linux-${TARGETARCH}-disable-systemd && \
    chmod 755 crun

ARG TARGETPLATFORM
FROM --platform=${TARGETPLATFORM} scratch
ARG VERSION
ARG MAINTAINERS=''

LABEL org.opencontainers.image.title="crun"
LABEL org.opencontainers.image.authors="${MAINTAINERS}"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.license="GPL-2.0, LGPL-2.1"
LABEL org.opencontainers.image.documentation="https://github.com/containers/crun"
LABEL org.opencontainers.image.base.name="scratch"
LABEL dev.anza-labs.image.executable="/usr/bin/crun"

WORKDIR /usr/bin
COPY --from=alpine /work/crun /usr/bin/
