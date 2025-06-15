# Étape 1 : Builder l'app Angular
FROM node:22.16-alpine AS builder

WORKDIR /app

# Copie les fichiers nécessaires
COPY package.json pnpm-lock.yaml ./
COPY angular.json tsconfig.json ./
COPY src ./src

# Installe PNPM et dépendances
RUN corepack enable && corepack prepare pnpm@8.15.5 --activate && pnpm install

# Build Angular (output dans /app/dist)
RUN pnpm run build

# Étape 2 : Serveur nginx optimisé pour Angular
FROM nginx:alpine

# Copie le build Angular dans le dossier nginx
COPY --from=builder /app/dist/ /usr/share/nginx/html

# Remplace config nginx si besoin (SPA / 404 fallback)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
