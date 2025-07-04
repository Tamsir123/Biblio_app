#!/bin/bash

# Script de configuration automatique pour déploiement avec IP publique
# Usage: ./configure-ip-deployment.sh [VOTRE_IP_PUBLIQUE]

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Configuration pour déploiement avec IP publique${NC}"
echo "=================================================="

# Vérifier si l'IP est fournie
if [ -z "$1" ]; then
    echo -e "${YELLOW}⚠️  Détection automatique de l'IP publique...${NC}"
    PUBLIC_IP=$(curl -s https://ipinfo.io/ip 2>/dev/null || curl -s https://api.ipify.org 2>/dev/null || echo "")
    
    if [ -z "$PUBLIC_IP" ]; then
        echo -e "${RED}❌ Impossible de détecter l'IP publique automatiquement${NC}"
        echo -e "${YELLOW}💡 Usage: $0 [VOTRE_IP_PUBLIQUE]${NC}"
        echo "Exemple: $0 203.0.113.1"
        exit 1
    fi
    
    echo -e "${GREEN}✅ IP publique détectée: $PUBLIC_IP${NC}"
    read -p "Utiliser cette IP ? (o/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Oo]$ ]]; then
        read -p "Entrez votre IP publique: " PUBLIC_IP
    fi
else
    PUBLIC_IP="$1"
    echo -e "${GREEN}✅ Utilisation de l'IP: $PUBLIC_IP${NC}"
fi

# Validation basique de l'IP
if [[ ! $PUBLIC_IP =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo -e "${RED}❌ Format d'IP invalide: $PUBLIC_IP${NC}"
    exit 1
fi

echo -e "${BLUE}📝 Configuration des fichiers...${NC}"

# 1. Mise à jour du fichier .env principal
echo -e "${YELLOW}🔧 Mise à jour de .env${NC}"
sed -i "s|FRONTEND_URL=.*|FRONTEND_URL=http://$PUBLIC_IP:3000|g" .env

# 2. Création/mise à jour du .env.local pour le frontend
echo -e "${YELLOW}🔧 Configuration du frontend${NC}"
cat > frontend-gestion-biblio/.env.local << EOF
# Configuration pour IP publique
VITE_API_URL=http://$PUBLIC_IP:5000
EOF

# 3. Mise à jour du docker-compose.yml pour exposition externe
echo -e "${YELLOW}🔧 Mise à jour de docker-compose.yml${NC}"
if [ -f docker-compose.yml ]; then
    # Backup du fichier original
    cp docker-compose.yml docker-compose.yml.backup
    
    # Mise à jour des variables d'environnement
    sed -i "s|FRONTEND_URL=.*|FRONTEND_URL=http://$PUBLIC_IP:3000|g" docker-compose.yml
    
    # S'assurer que les ports sont exposés sur toutes les interfaces
    sed -i 's|127.0.0.1:5000:5000|5000:5000|g' docker-compose.yml
    sed -i 's|127.0.0.1:3000:80|3000:80|g' docker-compose.yml
fi

# 4. Création d'un script de démarrage spécifique
echo -e "${YELLOW}🔧 Création du script de démarrage${NC}"
cat > start-public-deployment.sh << EOF
#!/bin/bash

# Script de démarrage pour déploiement avec IP publique
echo "🚀 Démarrage de l'application Biblio avec IP publique: $PUBLIC_IP"

# Vérifier que MySQL est démarré
echo "📊 Vérification de MySQL..."
if ! docker ps | grep -q mysql_projet_dev; then
    echo "⚠️  Démarrage de MySQL..."
    docker run --name mysql_projet_dev -d \\
        -p 4002:3306 \\
        -e MYSQL_ROOT_PASSWORD=Tam@1# \\
        -e MYSQL_DATABASE=bibliotheque_web \\
        mysql:8.0
    
    echo "⏳ Attente du démarrage de MySQL (30 secondes)..."
    sleep 30
fi

# Démarrer l'application
echo "🚀 Démarrage de l'application..."
docker-compose up -d

echo "✅ Application démarrée !"
echo ""
echo "🌐 URLs d'accès :"
echo "   Frontend : http://$PUBLIC_IP:3000"
echo "   Backend  : http://$PUBLIC_IP:5000"
echo "   API      : http://$PUBLIC_IP:5000/api"
echo ""
echo "👥 Partage externe :"
echo "   L'application est maintenant accessible depuis l'extérieur"
echo "   Partagez l'URL : http://$PUBLIC_IP:3000"
echo ""
echo "📋 Logs en temps réel :"
echo "   docker-compose logs -f"
EOF

chmod +x start-public-deployment.sh

# 5. Création d'un script de vérification
cat > check-external-access.sh << EOF
#!/bin/bash

echo "🔍 Vérification de l'accès externe..."
echo "IP publique configurée: $PUBLIC_IP"
echo ""

echo "📋 Test des services :"

# Test du frontend
echo -n "Frontend (port 3000): "
if curl -s -o /dev/null -w "%{http_code}" http://$PUBLIC_IP:3000 | grep -q "200\|301\|302"; then
    echo -e "✅ Accessible"
else
    echo -e "❌ Non accessible"
fi

# Test du backend
echo -n "Backend (port 5000): "
if curl -s -o /dev/null -w "%{http_code}" http://$PUBLIC_IP:5000 | grep -q "200\|301\|302"; then
    echo -e "✅ Accessible"
else
    echo -e "❌ Non accessible"
fi

# Test de l'API
echo -n "API (/api/books): "
if curl -s -o /dev/null -w "%{http_code}" http://$PUBLIC_IP:5000/api/books | grep -q "200"; then
    echo -e "✅ Accessible"
else
    echo -e "❌ Non accessible"
fi

echo ""
echo "🌐 URLs de test depuis l'extérieur :"
echo "   curl http://$PUBLIC_IP:3000"
echo "   curl http://$PUBLIC_IP:5000/api/books"
EOF

chmod +x check-external-access.sh

# 6. Mise à jour du README avec les nouvelles informations
echo -e "${YELLOW}🔧 Mise à jour du README${NC}"
cat >> README.md << EOF

## 🌐 Déploiement avec IP Publique

L'application est configurée pour être accessible via l'IP publique : **$PUBLIC_IP**

### URLs d'accès
- **Frontend** : http://$PUBLIC_IP:3000
- **Backend API** : http://$PUBLIC_IP:5000/api
- **Images** : http://$PUBLIC_IP:5000/uploads

### Démarrage
\`\`\`bash
# Démarrer l'application
./start-public-deployment.sh

# Vérifier l'accès externe
./check-external-access.sh
\`\`\`

### Accès externe
L'application est maintenant accessible depuis n'importe où sur Internet.
Partagez l'URL avec votre professeur : **http://$PUBLIC_IP:3000**

Pour plus de détails, consultez : [DEPLOIEMENT-IP-PUBLIQUE.md](./DEPLOIEMENT-IP-PUBLIQUE.md)
EOF

echo -e "${GREEN}✅ Configuration terminée !${NC}"
echo ""
echo -e "${BLUE}📋 Résumé de la configuration :${NC}"
echo "  IP publique : $PUBLIC_IP"
echo "  Frontend    : http://$PUBLIC_IP:3000"
echo "  Backend     : http://$PUBLIC_IP:5000"
echo "  API         : http://$PUBLIC_IP:5000/api"
echo ""
echo -e "${GREEN}🚀 Prochaines étapes :${NC}"
echo "  1. Démarrer l'application : ./start-public-deployment.sh"
echo "  2. Vérifier l'accès : ./check-external-access.sh"
echo "  3. Partager l'URL : http://$PUBLIC_IP:3000"
echo ""
echo -e "${YELLOW}⚠️  Important :${NC}"
echo "  - Assurez-vous que les ports 3000 et 5000 sont ouverts dans votre firewall"
echo "  - Si vous utilisez un cloud provider, configurez les security groups"
echo "  - Pour la production, envisagez d'utiliser HTTPS avec un certificat SSL"
