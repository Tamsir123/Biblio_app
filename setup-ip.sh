#!/bin/bash

# Script de configuration simple pour IP publique
echo "🚀 Configuration pour déploiement avec IP publique"
echo "=================================================="

# Demander l'IP à l'utilisateur
read -p "Entrez votre adresse IP publique : " PUBLIC_IP

# Validation basique
if [[ ! $PUBLIC_IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo "❌ Format d'IP invalide. Exemple : 192.168.1.100"
    exit 1
fi

echo "✅ Configuration pour l'IP : $PUBLIC_IP"

# Mise à jour du .env
echo "🔧 Mise à jour de .env..."
sed -i.bak "s|FRONTEND_URL=.*|FRONTEND_URL=http://$PUBLIC_IP:3000|g" .env

# Configuration du frontend
echo "🔧 Configuration du frontend..."
cat > frontend-gestion-biblio/.env.local << EOF
VITE_API_URL=http://$PUBLIC_IP:5000
EOF

# Création du script de démarrage
echo "🔧 Création du script de démarrage..."
cat > start-app.sh << 'EOF'
#!/bin/bash
echo "🚀 Démarrage de l'application..."

# Démarrer MySQL si nécessaire
if ! docker ps | grep -q mysql_projet_dev; then
    echo "📊 Démarrage de MySQL..."
    docker run --name mysql_projet_dev -d \
        -p 4002:3306 \
        -e MYSQL_ROOT_PASSWORD=Tam@1# \
        -e MYSQL_DATABASE=bibliotheque_web \
        mysql:8.0
    sleep 15
fi

# Démarrer l'application
./deploy-with-existing-mysql.sh
EOF

chmod +x start-app.sh

echo ""
echo "✅ Configuration terminée !"
echo ""
echo "📋 URLs d'accès :"
echo "   Frontend : http://$PUBLIC_IP:3000"
echo "   Backend  : http://$PUBLIC_IP:5000"
echo "   API      : http://$PUBLIC_IP:5000/api"
echo ""
echo "🚀 Pour démarrer l'application :"
echo "   ./start-app.sh"
echo ""
echo "⚠️  N'oubliez pas d'ouvrir les ports 3000 et 5000 dans votre firewall !"
