# Étape 1 : Utiliser Debian comme base et ajouter les sources deb-src
FROM debian:stable AS deb-src

RUN echo "deb http://deb.debian.org/debian stable main" > /etc/apt/sources.list && \
    echo "deb-src http://deb.debian.org/debian stable main" >> /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian-security stable-security main" >> /etc/apt/sources.list && \
    echo "deb-src http://deb.debian.org/debian-security stable-security main" >> /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian stable-updates main" >> /etc/apt/sources.list && \
    echo "deb-src http://deb.debian.org/debian stable-updates main" >> /etc/apt/sources.list

# Étape 2 : Installer les dépendances de compilation
FROM deb-src AS install-dependency

RUN apt-get update && \
    apt-get install -y build-essential wget git bc flex bison libssl-dev libncurses5-dev \
                       clang lld gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi cpio unzip zip \
                       python3 libelf-dev libunwind-dev && \
    apt-get build-dep -y linux

# Étape 3 : Copier le code source du noyau dans le conteneur
FROM install-dependency AS builder

WORKDIR /kernel

COPY . /kernel

# Étape 4 : Compiler le noyau
RUN make O=out zuma_defconfig && \
    make O=out -j$(nproc)

# Étape 5 : Préparer les artéfacts
RUN mkdir /artifacts && \
    cp out/arch/arm64/boot/Image.gz-dtb /artifacts/

# Étape 6 : Définir le point d'entrée
CMD ["bash"]
