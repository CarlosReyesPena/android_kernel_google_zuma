# Utiliser Ubuntu 22.04 comme base
FROM ubuntu:22.04

# Mettre à jour et installer les dépendances
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        bc \
        flex \
        bison \
        libssl-dev \
        libncurses5-dev \
        git \
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

# Définir les variables d'environnement
ENV ARCH=arm64
ENV CROSS_COMPILE=aarch64-linux-gnu-
ENV PATH="/usr/bin:$PATH"

# Définir le répertoire de travail
WORKDIR /kernel

# Définir le point d'entrée
CMD ["bash"]
