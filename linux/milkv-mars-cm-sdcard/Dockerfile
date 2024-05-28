FROM --platform=${BUILDPLATFORM} docker.io/library/ubuntu:24.04 AS build

ENV DEBIAN_FRONTEND='noninteractive'
RUN apt-get update && \
    apt-get install --yes \
        build-essential automake libtool texinfo bison flex gawk g++ git xxd curl wget gdisk gperf cpio bc screen \
        texinfo unzip libgmp-dev libmpfr-dev libmpc-dev libssl-dev libncurses-dev libglib2.0-dev libpixman-1-dev \
        libyaml-dev patchutils python3-pip zlib1g-dev device-tree-compiler dosfstools mtools kpartx rsync && \
    apt-get clean

WORKDIR /work
ARG BRANCH
COPY ./src/ /work/mars-buildroot-sdk
WORKDIR /work/mars-buildroot-sdk

RUN make -j"$(nproc)" vmlinux

RUN mkdir -p /mnt/fat32/boot /mnt/ext4 && \
    cp -r work/module_install_path/lib /mnt/ext4 && \
    cp work/linux/arch/riscv/boot/Image /mnt/fat32/boot/kernel.img && \
    cp work/linux/arch/riscv/boot/dts/starfive/*.dtb /mnt/fat32/boot/ && \
    rm -rf \
        /mnt/fat32/boot/jh7110-visionfive* \
        /mnt/fat32/boot/jh7110-fpga* \
        /mnt/fat32/boot/jh7110-evb*

FROM --platform=${TARGETPLATFORM} scratch
ARG VERSION
ARG MAINTAINERS=''

LABEL org.opencontainers.image.title="linux"
LABEL org.opencontainers.image.authors="${MAINTAINERS}"
LABEL org.opencontainers.image.version="${BRANCH}"
LABEL org.opencontainers.image.license="GPL-2.0 WITH Linux-syscall-note"
LABEL org.opencontainers.image.documentation="https://github.com/milkv-mars/mars-buildroot-sdk"
LABEL org.opencontainers.image.base.name="scratch"

WORKDIR /
COPY --from=build /mnt/fat32 /mnt/ext4 /
