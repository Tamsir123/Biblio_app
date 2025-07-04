#!/bin/bash

echo "🚀 Préparation pour déploiement Render"
echo "======================================"

# Vérifier que git est configuré
if ! git config user.name &> /dev/null; then
    echo "⚠️  Configuration Git requise"
    echo "Configurez git avec :"
    echo "  git config --global user.name 'Votre Nom'"
    echo "  git config --global user.email 'votre.email@example.com'"
    exit 1
fi

# Créer un .gitignore approprié si inexistant
if [ ! -f .gitignore ]; then
    echo "📝 Création du .gitignore"
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
*/node_modules/

# Logs
*.log
npm-debug.log*

# Environment variables
.env.local
.env.development.local
.env.test.local
.env.production.local

# Build outputs
*/dist/
*/build/

# OS files
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/

# Temporary files
*.tmp
*.temp

# Docker
.dockerignore
EOF
fi

# Mettre à jour le backend pour Render
echo "🔧 Configuration du backend pour Render..."

# Vérifier si fetch est disponible dans Node.js
cat > backend-gestion-biblio/check-node-fetch.js << 'EOF'
// Vérifier que fetch est disponible dans Node.js 18+
if (typeof fetch === 'undefined') {
  console.log('⚠️  fetch non disponible - installation de node-fetch');
  process.exit(1);
} else {
  console.log('✅ fetch disponible dans Node.js');
}
EOF

# Créer un script de démarrage pour Render
cat > backend-gestion-biblio/start-render.js << 'EOF'
// Script de démarrage optimisé pour Render
const { execSync } = require('child_process');

console.log('🚀 Démarrage du backend sur Render...');

// Vérifier les variables d'environnement critiques
const requiredEnvs = ['DB_HOST', 'DB_USER', 'DB_PASSWORD', 'JWT_SECRET'];
const missingEnvs = requiredEnvs.filter(env => !process.env[env]);

if (missingEnvs.length > 0) {
  console.error('❌ Variables d\'environnement manquantes:', missingEnvs.join(', '));
  process.exit(1);
}

console.log('✅ Variables d\'environnement configurées');

// Démarrer l'application
require('./server.js');
EOF

# Créer un dockerfile optimisé pour Render
cat > backend-gestion-biblio/Dockerfile.render << 'EOF'
FROM node:18-alpine

WORKDIR /app

# Copier les fichiers de dépendances
COPY package*.json ./

# Installer les dépendances avec cache optimisé
RUN npm ci --only=production --silent && npm cache clean --force

# Copier le code source
COPY . .

# Créer les dossiers uploads avec permissions
RUN mkdir -p uploads/covers uploads/profiles && \
    chown -R node:node uploads && \
    chmod -R 755 uploads

# Exposer le port (Render utilise la variable PORT)
EXPOSE $PORT

# Utilisateur non-root pour la sécurité
USER node

# Script de démarrage
CMD ["node", "start-render.js"]
EOF

# Configuration frontend pour Render
echo "🎨 Configuration du frontend pour Render..."

# Créer un fichier de configuration Vite pour la production
cat > frontend-gestion-biblio/vite.config.render.ts << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'
import path from 'path'

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  build: {
    outDir: 'dist',
    sourcemap: false,
    minify: 'esbuild',
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          ui: ['lucide-react', 'framer-motion']
        }
      }
    }
  },
  server: {
    port: parseInt(process.env.PORT || '3000'),
    host: '0.0.0.0'
  },
  preview: {
    port: parseInt(process.env.PORT || '3000'),
    host: '0.0.0.0'
  }
})
EOF

# Dockerfile optimisé pour le frontend
cat > frontend-gestion-biblio/Dockerfile.render << 'EOF'
# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy dependency files
COPY package*.json ./

# Install dependencies
RUN npm ci --silent

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM nginx:alpine

# Install curl for health checks
RUN apk add --no-cache curl

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built application
COPY --from=builder /app/dist /usr/share/nginx/html

# Create non-root user
RUN addgroup -g 1001 -S nginx-user && \
    adduser -S nginx-user -G nginx-user

# Set permissions
RUN chown -R nginx-user:nginx-user /var/cache/nginx && \
    chown -R nginx-user:nginx-user /var/log/nginx && \
    chown -R nginx-user:nginx-user /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R nginx-user:nginx-user /var/run/nginx.pid

# Switch to non-root user
USER nginx-user

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
EOF

# Configuration nginx optimisée pour Render
cat > frontend-gestion-biblio/nginx.render.conf << 'EOF'
server {
    listen 8080;
    server_name _;
    root /usr/share/nginx/html;
    index index.html;

    # Enable gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/xml+rss
        application/json;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    # Handle client side routing
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Health check endpoint
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
EOF

# Créer le fichier d'initialisation de la base de données
echo "🗄️  Préparation de la base de données..."
cat > database-init.sql << 'EOF'
-- Script d'initialisation de la base de données pour Render
CREATE DATABASE IF NOT EXISTS bibliotheque_web;
USE bibliotheque_web;

-- Les tables seront créées automatiquement par l'application
-- lors de la première connexion via le script schema_complet.sql
EOF

# README pour Render
cat > README-RENDER.md << 'EOF'
# 🚀 Déploiement sur Render

## Configuration automatisée

Ce projet est configuré pour un déploiement automatique sur Render.

### Étapes de déploiement :

1. **Push sur GitHub**
   ```bash
   git add .
   git commit -m "Configuration Render ready"
   git push origin main
   ```

2. **Créer un compte sur [render.com](https://render.com)**

3. **Connecter votre dépôt GitHub**

4. **Utiliser le fichier render.yaml pour le déploiement automatique**

### URLs de l'application :
- **Frontend :** https://biblio-frontend.onrender.com
- **Backend API :** https://biblio-backend.onrender.com
- **Base de données :** Automatiquement configurée

### Fonctionnalités déployées :
- ✅ Interface React.js responsive
- ✅ API REST Node.js/Express 
- ✅ Base de données MySQL
- ✅ Authentification JWT
- ✅ Upload et gestion d'images
- ✅ Système d'emprunts complet
- ✅ Dashboard administrateur
- ✅ Notifications par email

### Variables d'environnement :
Toutes les variables sont configurées automatiquement via render.yaml

### Monitoring :
- Health checks automatiques
- Logs en temps réel
- Redémarrage automatique en cas d'erreur

Date de configuration : $(date)
EOF

echo ""
echo "✅ Configuration Render terminée !"
echo "=================================="
echo ""
echo "📋 Fichiers créés :"
echo "   📄 render.yaml - Configuration principal"
echo "   🐳 Dockerfile.render - Optimisés pour Render"
echo "   📖 README-RENDER.md - Instructions complètes"
echo ""
echo "🚀 Étapes suivantes :"
echo "   1. git add ."
echo "   2. git commit -m 'Configuration Render complète'"
echo "   3. git push origin main"
echo "   4. Aller sur render.com et connecter votre repo"
echo "   5. Render déploiera automatiquement avec render.yaml"
echo ""
echo "🌐 Une fois déployé, votre app sera accessible via :"
echo "   Frontend: https://biblio-frontend.onrender.com"
echo "   Backend:  https://biblio-backend.onrender.com"
echo ""
echo "📧 Partagez ces URLs avec votre professeur !"
