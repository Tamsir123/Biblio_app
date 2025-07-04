#!/bin/bash

echo "🧪 Test des Dockerfiles pour Render"
echo "==================================="

# Tester le build du frontend
echo "🎨 Test du build frontend..."
cd /home/tamsir/Desktop/Biblio_app

if docker build -f frontend-gestion-biblio/Dockerfile -t test-frontend . ; then
    echo "✅ Frontend Dockerfile OK"
else
    echo "❌ Erreur dans le Dockerfile frontend"
    exit 1
fi

# Tester le build du backend
echo "🔧 Test du build backend..."
if docker build -f backend-gestion-biblio/Dockerfile -t test-backend . ; then
    echo "✅ Backend Dockerfile OK"
else
    echo "❌ Erreur dans le Dockerfile backend"
    exit 1
fi

# Nettoyer les images de test
echo "🧹 Nettoyage des images de test..."
docker rmi test-frontend test-backend 2>/dev/null

echo ""
echo "🎉 Tous les Dockerfiles sont prêts pour Render !"
echo "📤 Vous pouvez maintenant pousser sur GitHub :"
echo "   git add ."
echo "   git commit -m 'Fix Dockerfiles pour Render'"
echo "   git push origin main"
