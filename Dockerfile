# Étape 1 : build
FROM node:22.16.0-alpine AS builder

WORKDIR /app

# Copier les fichiers de dépendances d'abord (pour le cache Docker)
COPY package.json pnpm-lock.yaml ./

RUN corepack enable && \
    corepack prepare pnpm@8.15.5 --activate && \
    pnpm install

# Copier le reste du code
COPY . .

# Build l'application
RUN pnpm run build

# Étape 2 : nginx avec les bons fichiers
FROM nginx:alpine

# Copier les fichiers buildés depuis le bon répertoire
COPY --from=builder /app/dist/dashboard/browser /usr/share/nginx/html

# Copier la configuration nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]