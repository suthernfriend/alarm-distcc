FROM archlinux/base

ARG TOOLCHAIN_ARCH=7h
ARG TOOLCHAIN_URL=https://archlinuxarm.org/builder/xtools/x-tools$TOOLCHAIN_ARCH.tar.xz

LABEL maintainer="Jan Peter Koenig <public@janpeterkoenig.com>"

RUN pacman -Syu --noconfirm

RUN useradd -d /home/build -m build && \
    pacman -S --noconfirm base-devel wget distcc

WORKDIR /home/build

USER build

RUN wget -q $TOOLCHAIN_URL && \
    tar -xJf x-tools$TOOLCHAIN_ARCH.tar.xz

ENV ALLOWED_HOSTS=192.168.0.0/16 \
    PATH=/home/build/x-tools$TOOLCHAIN_ARCH/arm-unknown-linux-gnueabihf/bin:/usr/bin \
    JOBS=8

EXPOSE 3932/tcp
EXPOSE 3933/tcp

ENTRYPOINT ["/bin/sh","-c","/usr/bin/distccd --verbose --no-detach --daemon --make-me-a-botnet --allow $ALLOWED_HOSTS --jobs $JOBS --log-stderr --port 3932 --stats-port 3933"]

