#!/bin/bash

# Script de déploiemecho "📁 Nettoyageecho "🚀 Démarrage des servicesecho "📋 Commandes utiles :"
echo "   Voir les logs: docker compose logs -f"
echo "   Arrêter: docker compose down"
echo "   Redémarrer: docker compose restart"
echo "   Logs backend: docker compose logs -f backend"
echo "   Logs frontend: docker compose logs -f frontend"
echo "   Tester les images: curl http://localhost:5000/uploads/covers/"ocker compose up -d

echo "⏳ Attente du démarrage des services..."
sleep 30

# Vérifier que les services sont en cours d'exécution
echo "🔍 Vérification de l'état des services..."
docker compose ps

# Vérifier que les images sont bien accessibles dans le conteneur backend
echo "🖼️  Vérification des images dans le conteneur backend..."
docker compose exec backend ls -la /app/uploads/covers/ | head -5

echo "🎉 Déploiement terminé !"s conteneurs..."
docker compose down --remove-orphans

# Vérifier que les images existantes sont bien présentes
echo "🔍 Vérification des images existantes..."
if [ -d "./backend-gestion-biblio/uploads/covers" ]; then
    echo "✅ Dossier uploads/covers trouvé avec $(find ./backend-gestion-biblio/uploads/covers -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" | wc -l) images"
else
    echo "⚠️  Dossier uploads/covers non trouvé"
fi

echo "🔨 Construction des images Docker..."
docker compose build --no-cacheour l'application Biblio (avec MySQL existant)

echo "🚀 Déploiement de l'application Bibliothèque..."

# Vérifier que Docker et Docker Compose sont installés
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Vérifier que Docker Compose est disponible (v2)
if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose n'est pas disponible. Veuillez l'installer d'abord."
    exit 1
fi

# Vérifier que le fichier .env existe
if [ ! -f .env ]; then
    echo "❌ Le fichier .env n'existe pas. Veuillez le créer avec les variables nécessaires."
    exit 1
fi

# Vérifier que le container MySQL existe et fonctionne
if ! docker ps | grep -q "mysql_projet_dev"; then
    echo "❌ Le container MySQL 'mysql_projet_dev' n'est pas en cours d'exécution."
    echo "   Veuillez démarrer votre container MySQL avant de continuer."
    exit 1
fi

echo "✅ Container MySQL détecté et en cours d'exécution"

echo "📁 Nettoyage des anciens conteneurs..."
docker compose down --remove-orphans

echo "🔨 Construction des images Docker..."
docker compose build --no-cache

echo "🚀 Démarrage des services..."
docker compose up -d

echo "⏳ Attente du démarrage des services..."
sleep 30

# Vérifier que les services sont en cours d'exécution
echo "🔍 Vérification de l'état des services..."
docker compose ps

echo "🎉 Déploiement terminé !"
echo ""
echo "📱 Accès à l'application :"
echo "   Frontend: http://localhost:3000"
echo "   Backend API: http://localhost:5000"
echo "   Base de données MySQL: localhost:4002 (container existant)"
echo ""
echo "📋 Commandes utiles :"
echo "   Voir les logs: docker compose logs -f"
echo "   Arrêter: docker compose down"
echo "   Redémarrer: docker compose restart"
echo "   Logs backend: docker compose logs -f backend"
echo "   Logs frontend: docker compose logs -f frontend"
