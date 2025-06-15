# Étape 1 : build
FROM node:22.16.0-alpine AS builder

WORKDIR /app

COPY . .

RUN corepack enable && \
    corepack prepare pnpm@8.15.5 --activate && \
    pnpm install && \
    pnpm run build

# Étape 2 : nginx avec les bons fichiers
FROM nginx:alpine

# Copie les fichiers du bon sous-dossier (remplace "dashboard" si nécessaire)
COPY --from=builder /app/dist/dashboard/browser /usr/share/nginx/html

# Copie ta conf nginx personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
