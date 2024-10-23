# Utiliser Ubuntu 22.04 comme base
FROM ubuntu:22.04 AS builder

# Mettre à jour et installer les dépendances
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        wget \
        git \
        bc \
        flex \
        bison \
        libssl-dev \
        libncurses5-dev \
        clang \
        lld \
        gcc \
        gcc-aarch64-linux-gnu \
        cpio \
        unzip \
        zip \
        python3 \
        libelf-dev \
        libunwind-dev && \
    rm -rf /var/lib/apt/lists/*

# Définir le répertoire de travail
WORKDIR /kernel

# Copier le code source du noyau
COPY . /kernel

# Définir les variables d'environnement
ENV ARCH=arm64
ENV CROSS_COMPILE=aarch64-linux-gnu-
ENV PATH="/usr/bin:$PATH"

# Vérifier que le compilateur croisé est accessible
RUN which ${CROSS_COMPILE}gcc

# Compiler le noyau
RUN make O=out zuma_defconfig && \
    make O=out -j$(nproc)

# Préparer les artéfacts
RUN mkdir /artifacts && \
    cp out/arch/arm64/boot/Image.gz-dtb /artifacts/

# Définir le point d'entrée
CMD ["bash"]
