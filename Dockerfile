# Utiliser l'image Docker officielle pour la compilation du noyau Android
FROM gcr.io/android-kernel-ci/abk-ubuntu:latest

# Définir le répertoire de travail
WORKDIR /kernel

# Copier le code source du noyau dans le conteneur
COPY . /kernel

# Exécuter le script de build
CMD ["build/build.sh"]
