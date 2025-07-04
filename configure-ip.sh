#!/bin/bash

# Script de configuration automatique pour IP publique
# Application de Gestion de Bibliothèque

echo "🌐 Configuration automatique pour IP publique"
echo "============================================="

# Fonction pour détecter l'IP publique
get_public_ip() {
    echo "🔍 Détection de votre IP publique..."
    
    # Essayer plusieurs services pour obtenir l'IP publique
    IP=""
    
    # Service 1: ifconfig.me
    if [ -z "$IP" ]; then
        IP=$(curl -s --connect-timeout 5 ifconfig.me 2>/dev/null)
    fi
    
    # Service 2: ipinfo.io
    if [ -z "$IP" ]; then
        IP=$(curl -s --connect-timeout 5 ipinfo.io/ip 2>/dev/null)
    fi
    
    # Service 3: api.ipify.org
    if [ -z "$IP" ]; then
        IP=$(curl -s --connect-timeout 5 https://api.ipify.org 2>/dev/null)
    fi
    
    # Service 4: checkip.amazonaws.com
    if [ -z "$IP" ]; then
        IP=$(curl -s --connect-timeout 5 checkip.amazonaws.com 2>/dev/null)
    fi
    
    if [ -n "$IP" ]; then
        echo "✅ IP publique détectée : $IP"
    else
        echo "❌ Impossible de détecter automatiquement l'IP publique"
        echo "ℹ️  Vous pouvez la trouver manuellement avec : curl ifconfig.me"
        read -p "📝 Veuillez saisir votre IP publique : " IP
    fi
    
    echo "$IP"
}

# Fonction pour valider une IP
validate_ip() {
    local ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Obtenir l'IP publique
PUBLIC_IP=$(get_public_ip)

# Valider l'IP
if ! validate_ip "$PUBLIC_IP"; then
    echo "❌ IP invalide : $PUBLIC_IP"
    read -p "📝 Veuillez saisir une IP valide : " PUBLIC_IP
    
    if ! validate_ip "$PUBLIC_IP"; then
        echo "❌ IP toujours invalide. Arrêt du script."
        exit 1
    fi
fi

echo ""
echo "🔧 Configuration en cours avec l'IP : $PUBLIC_IP"
echo ""

# Sauvegarder les fichiers originaux
echo "💾 Sauvegarde des configurations existantes..."
cp .env .env.backup 2>/dev/null || echo "⚠️  Pas de fichier .env existant"
cp frontend-gestion-biblio/.env.local frontend-gestion-biblio/.env.local.backup 2>/dev/null || echo "ℹ️  Pas de fichier .env.local existant"

# Configurer le fichier .env principal
echo "📝 Configuration du fichier .env..."
sed -i "s|FRONTEND_URL=.*|FRONTEND_URL=http://$PUBLIC_IP:3000|" .env

# Créer/configurer le fichier .env.local pour le frontend
echo "📝 Configuration du frontend..."
mkdir -p frontend-gestion-biblio
cat > frontend-gestion-biblio/.env.local << EOF
# Configuration automatique pour IP publique
VITE_API_URL=http://$PUBLIC_IP:5000
EOF

# Configurer docker-compose.yml pour l'exposition externe
echo "🐳 Configuration de Docker Compose..."
if [ -f docker-compose.yml ]; then
    # Créer une sauvegarde
    cp docker-compose.yml docker-compose.yml.backup
    
    # Modifier les variables d'environnement dans docker-compose.yml
    sed -i "s|FRONTEND_URL=.*|FRONTEND_URL=http://$PUBLIC_IP:3000|" docker-compose.yml
    sed -i "s|VITE_API_URL=.*|VITE_API_URL=http://$PUBLIC_IP:5000|" docker-compose.yml
fi

echo ""
echo "✅ Configuration terminée !"
echo "=========================="
echo ""
echo "🌐 Votre application sera accessible via :"
echo "   Frontend : http://$PUBLIC_IP:3000"
echo "   Backend  : http://$PUBLIC_IP:5000"
echo ""
echo "📋 Prochaines étapes :"
echo "1. Vérifiez que les ports 3000 et 5000 sont ouverts sur votre firewall"
echo "2. Démarrez l'application avec : ./deploy-with-existing-mysql.sh"
echo "3. Testez l'accès depuis l'extérieur"
echo ""
echo "🔥 Commandes de firewall (si nécessaire) :"
echo "   sudo ufw allow 3000/tcp"
echo "   sudo ufw allow 5000/tcp"
echo ""
echo "🔍 Pour tester l'accès :"
echo "   curl http://$PUBLIC_IP:3000"
echo "   curl http://$PUBLIC_IP:5000/api/books"
echo ""
echo "📱 Partage avec le professeur :"
echo "   URL : http://$PUBLIC_IP:3000"
echo ""

# Optionnel : proposer de configurer le firewall
read -p "🔥 Voulez-vous configurer automatiquement le firewall (ufw) ? (y/N) : " configure_firewall

if [[ $configure_firewall =~ ^[Yy]$ ]]; then
    echo "🔥 Configuration du firewall..."
    
    # Vérifier si ufw est installé
    if command -v ufw >/dev/null 2>&1; then
        sudo ufw allow 3000/tcp
        sudo ufw allow 5000/tcp
        echo "✅ Ports 3000 et 5000 autorisés dans le firewall"
    else
        echo "⚠️  ufw n'est pas installé. Configurez manuellement votre firewall."
    fi
fi

echo ""
echo "🎉 Configuration terminée avec succès !"
echo "   Vous pouvez maintenant démarrer l'application avec :"
echo "   ./deploy-with-existing-mysql.sh"
