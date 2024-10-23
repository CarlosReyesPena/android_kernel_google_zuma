# Utiliser une image Debian stable comme base
FROM debian:stable

# Mettre à jour les sources et installer les dépendances
RUN apt-get update && apt-get install -y \
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
    wget \
    cpio \
    unzip \
    zip \
    openssh-client \
    ca-certificates \
    python3

# Installer les compilateurs croisés pour aarch64
RUN apt-get install -y gcc-aarch64-linux-gnu

# Définir les variables d'environnement nécessaires
ENV ARCH=arm64
ENV SUBARCH=arm64
ENV CROSS_COMPILE=aarch64-linux-gnu-
ENV CC=clang
ENV LD=ld.lld

# Définir le répertoire de travail
WORKDIR /kernel

# Copier le code source du noyau dans le conteneur
COPY . /kernel

# Exposer le point d'entrée
ENTRYPOINT ["/bin/bash"]
