# Étape 1 : Construction de l'app Angular
FROM node:22.16.0-alpine AS build

# Crée un dossier de travail
WORKDIR /app

# Copie les fichiers nécessaires
COPY . .

# Active corepack pour utiliser PNPM
RUN corepack enable && \
    corepack prepare pnpm@8.15.5 --activate

# Installation des dépendances
RUN pnpm install

# Build Angular
RUN pnpm run build

# Étape 2 : Serveur Nginx pour servir l'app
FROM nginx:alpine

# Copie le build Angular depuis l'étape précédente
COPY --from=build /app/dist/* /usr/share/nginx/html/

# Copie une config nginx personnalisée si nécessaire
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose le port 80
EXPOSE 80

# Lance nginx en mode foreground
CMD ["nginx", "-g", "daemon off;"]
