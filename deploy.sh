#!/bin/bash

# Script de déploiement pour l'application Biblio

echo "🚀 Déploiement de l'application Bibliothèque..."

# Vérifier que Docker et Docker Compose sont installés
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Vérifier que le fichier .env existe
if [ ! -f .env ]; then
    echo "❌ Le fichier .env n'existe pas. Veuillez le créer avec les variables nécessaires."
    exit 1
fi

echo "📁 Nettoyage des anciens conteneurs..."
docker-compose down --remove-orphans

echo "🔨 Construction des images Docker..."
docker-compose build --no-cache

echo "🚀 Démarrage des services..."
docker-compose up -d

echo "⏳ Attente du démarrage des services..."
sleep 30

# Vérifier que les services sont en cours d'exécution
echo "🔍 Vérification de l'état des services..."
docker-compose ps

echo "🎉 Déploiement terminé !"
echo ""
echo "� Logs des services (dernières 20 lignes):"
echo "--- MYSQL ---"
docker-compose logs --tail=20 mysql
echo "--- BACKEND ---"
docker-compose logs --tail=20 backend
echo "--- FRONTEND ---"
docker-compose logs --tail=20 frontend
echo ""
echo "�📱 Accès à l'application :"
echo "   Frontend: http://localhost:3000"
echo "   Backend API: http://localhost:5000"
echo "   Base de données: localhost:3306"
echo ""
echo "📋 Commandes utiles :"
echo "   Voir les logs: docker-compose logs -f [service]"
echo "   Arrêter: docker-compose down"
echo "   Redémarrer: docker-compose restart [service]"
echo "   Reconstruire: docker-compose up --build"
