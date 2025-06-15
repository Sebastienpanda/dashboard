# Étape 1 : build Angular avec PNPM et Node.js 22.16
FROM node:22.16.0-alpine AS builder

WORKDIR /app

COPY . .

RUN corepack enable && \
    corepack prepare pnpm@8.15.5 --activate && \
    pnpm install && \
    pnpm run build

# Étape 2 : serveur Nginx avec les fichiers Angular
FROM nginx:alpine

# Copie les fichiers compilés Angular
COPY --from=builder /app/dist /usr/share/nginx/html

# Copie la configuration nginx personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
