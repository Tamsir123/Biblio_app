# Stage 1: Build de l'application
FROM node:18-alpine as build

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers package.json du frontend
COPY frontend-gestion-biblio/package*.json ./

# Installer toutes les dépendances (y compris dev)
RUN npm ci

# Copier le reste du code frontend
COPY frontend-gestion-biblio/ .

# Build de l'application
RUN npm run build

# Stage 2: Production avec Nginx
FROM nginx:alpine

# Copier les fichiers de build vers nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Copier la configuration nginx personnalisée
COPY frontend-gestion-biblio/nginx.conf /etc/nginx/conf.d/default.conf

# Exposer le port
EXPOSE 80

# Nginx se lance automatiquement
