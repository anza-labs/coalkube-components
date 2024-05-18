FROM --platform=${BUILDPLATFORM} docker.io/library/ubuntu:24.04 AS build

ENV DEBIAN_FRONTEND='noninteractive'
RUN apt-get update && \
    apt-get install --yes \
        git bc bison flex libssl-dev make libc6-dev libncurses5-dev crossbuild-essential-arm64 kmod && \
    apt-get clean

WORKDIR /work
ARG BRANCH
COPY ./src/ /work/linux
WORKDIR /work/linux

ENV KERNEL=kernel8
ENV ARCH=arm64
ENV CROSS_COMPILE=aarch64-linux-gnu-
RUN make -j"$(nproc)" bcm2711_defconfig && \
    make -j"$(nproc)" Image modules dtbs

ENV INSTALL_MOD_PATH=/mnt/ext4
RUN mkdir -p /mnt/fat32/boot/overlays /mnt/ext4 && \
    make -j"$(nproc)" modules_install && \
    cp arch/arm64/boot/Image /mnt/fat32/boot/${KERNEL}.img && \
    cp arch/arm64/boot/dts/broadcom/*.dtb /mnt/fat32/boot/ && \
    cp arch/arm64/boot/dts/overlays/*.dtb* /mnt/fat32/boot/overlays/ && \
    cp arch/arm64/boot/dts/overlays/README /mnt/fat32/boot/overlays && \
    rm -rf \
        /mnt/fat32/boot/bcm2710* \
        /mnt/fat32/boot/bcm2712* \
        /mnt/fat32/boot/bcm2837* \
        /mnt/fat32/boot/*rpi-4*

FROM --platform=${TARGETPLATFORM} scratch
ARG BRANCH
ARG MAINTAINERS=''

LABEL org.opencontainers.image.title="linux"
LABEL org.opencontainers.image.authors="${MAINTAINERS}"
LABEL org.opencontainers.image.version="${BRANCH}"
LABEL org.opencontainers.image.license="GPL-2.0 WITH Linux-syscall-note"
LABEL org.opencontainers.image.documentation="https://github.com/raspberrypi/linux"
LABEL org.opencontainers.image.base.name="scratch"

LABEL dev.anza-labs.target.vendor="raspberrypi"
LABEL dev.anza-labs.target.version="cm4"
LABEL dev.anza-labs.target.partition.scheme="boot:fs=fat32:target=/boot;lib:fs=ext4:target=/lib"
LABEL dev.anza-labs.target.partition.boot="/boot"
LABEL dev.anza-labs.target.partition.lib="/lib"

WORKDIR /
COPY --from=build /mnt/fat32 /mnt/ext4 /
