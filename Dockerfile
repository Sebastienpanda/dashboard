# Étape de build
FROM node:22.16.0-alpine AS build

WORKDIR /app

COPY . .

RUN corepack enable && \
    corepack prepare pnpm@8.15.5 --activate && \
    pnpm install && \
    pnpm run build

# Étape finale (fichiers statiques)
FROM alpine:latest

# Installe un serveur HTTP minimal si Coolify en a besoin
RUN apk add --no-cache nginx

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
