# 🚀 Guide Rapide - Déploiement IP Publique

## ⚡ Démarrage rapide

### 1. Configuration automatique
```bash
# Détection automatique de l'IP
./configure-ip-deployment.sh

# Ou spécifier manuellement l'IP
./configure-ip-deployment.sh 203.0.113.1
```

### 2. Démarrage de l'application
```bash
# Démarrer MySQL + Application
./start-public-deployment.sh
```

### 3. Vérification
```bash
# Tester l'accès externe
./check-external-access.sh
```

## 🌐 URLs d'accès

Une fois configuré, l'application sera accessible via :

- **Frontend** : `http://VOTRE_IP:3000`
- **Backend API** : `http://VOTRE_IP:5000/api`
- **Documentation** : `http://VOTRE_IP:5000`

## 👨‍🏫 Partage avec le professeur

```
Application de Gestion de Bibliothèque
URL : http://VOTRE_IP_PUBLIQUE:3000

Comptes de test :
- Administrateur : admin@biblio.com / admin123
- Utilisateur : user@biblio.com / user123
```

## 🔧 Dépannage

### Problème d'accès externe
```bash
# Vérifier les ports ouverts
sudo ufw status

# Ouvrir les ports si nécessaire
sudo ufw allow 3000/tcp
sudo ufw allow 5000/tcp
```

### Redémarrage complet
```bash
# Arrêter tout
docker-compose down
docker stop mysql_projet_dev

# Redémarrer
./start-public-deployment.sh
```

### Logs en temps réel
```bash
# Voir tous les logs
docker-compose logs -f

# Logs spécifiques
docker-compose logs -f backend
docker-compose logs -f frontend
```

## 📋 Checklist de déploiement

- [ ] Script de configuration exécuté
- [ ] Ports 3000 et 5000 ouverts dans le firewall
- [ ] MySQL démarré et accessible
- [ ] Application démarrée avec docker-compose
- [ ] Test d'accès externe réussi
- [ ] URL partagée avec le professeur

## 🔒 Sécurité (Optionnel)

### Ajouter HTTPS avec Let's Encrypt
```bash
# Installer certbot
sudo apt install certbot

# Si vous avez un nom de domaine
sudo certbot certonly --standalone -d votre-domaine.com
```

### Restriction d'accès par IP
Modifier le docker-compose.yml pour limiter l'accès :
```yaml
# Exemple : accès uniquement depuis des IPs spécifiques
ports:
  - "IP_AUTORISEE:3000:80"
```
