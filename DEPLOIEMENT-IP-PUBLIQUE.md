# 🌐 Déploiement via Adresse IP Publique

## 📋 Prérequis

1. **Machine avec IP publique** (serveur VPS, machine locale avec IP publique)
2. **Ports ouverts** : 80 (HTTP) et/ou 443 (HTTPS)
3. **Docker et Docker Compose** installés
4. **Nom de domaine** (optionnel, mais recommandé)

## 🚀 Configuration pour IP publique

### 1. Configuration réseau

#### Option A : Accès direct via IP
```bash
# Votre application sera accessible via :
# http://VOTRE_IP_PUBLIQUE:3000 (frontend)
# http://VOTRE_IP_PUBLIQUE:5000 (backend)
```

#### Option B : Reverse proxy avec Nginx (recommandé)
```bash
# Application accessible via :
# http://VOTRE_IP_PUBLIQUE (frontend)
# http://VOTRE_IP_PUBLIQUE/api (backend)
```

### 2. Modifier la configuration

#### Mise à jour du fichier `.env`
```properties
# Configuration pour IP publique
DB_HOST=host.docker.internal
DB_USER=root
DB_PASSWORD=Tam@1#
DB_NAME=bibliotheque_web
DB_PORT=4002

# Configuration serveur
PORT=5000
NODE_ENV=production

# Configuration Email
EMAIL_USER=tamsirjuuf@gmail.com
EMAIL_PASS=xsqb ocbs vmyn yqiy
EMAIL_SERVICE=gmail

# URL du frontend - REMPLACER PAR VOTRE IP PUBLIQUE
FRONTEND_URL=http://VOTRE_IP_PUBLIQUE:3000

# Ports externes
BACKEND_PORT=5000
FRONTEND_PORT=3000
```

#### Mise à jour du frontend
Créer un fichier `.env.local` dans `frontend-gestion-biblio/` :
```properties
# REMPLACER PAR VOTRE IP PUBLIQUE
VITE_API_URL=http://VOTRE_IP_PUBLIQUE:5000
```

### 3. Configuration Docker Compose pour IP publique

Modifier `docker-compose.yml` :
```yaml
version: '3.8'
services:
  backend:
    build: ./backend-gestion-biblio
    ports:
      - "5000:5000"  # Expose sur toutes les interfaces
    environment:
      - FRONTEND_URL=http://VOTRE_IP_PUBLIQUE:3000
    # ...autres configurations...

  frontend:
    build: ./frontend-gestion-biblio  
    ports:
      - "3000:80"    # Expose sur toutes les interfaces
    environment:
      - VITE_API_URL=http://VOTRE_IP_PUBLIQUE:5000
    # ...autres configurations...
```

## 🔧 Option avec Reverse Proxy (Production)

### Configuration Nginx
Créer `nginx/nginx.conf` :
```nginx
server {
    listen 80;
    server_name VOTRE_IP_PUBLIQUE;

    # Frontend React
    location / {
        proxy_pass http://frontend:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # Backend API
    location /api/ {
        proxy_pass http://backend:5000/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # Images uploadées
    location /uploads/ {
        proxy_pass http://backend:5000/uploads/;
    }
}
```

### Docker Compose avec Nginx
```yaml
version: '3.8'
services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - frontend
      - backend

  backend:
    build: ./backend-gestion-biblio
    expose:
      - "5000"
    environment:
      - FRONTEND_URL=http://VOTRE_IP_PUBLIQUE
    # ...

  frontend:
    build: ./frontend-gestion-biblio
    expose:
      - "80"
    environment:
      - VITE_API_URL=http://VOTRE_IP_PUBLIQUE/api
    # ...
```

## 🔐 Sécurité

### 1. Firewall
```bash
# Ubuntu/Debian
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# CentOS/RHEL
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload
```

### 2. HTTPS avec Let's Encrypt (recommandé)
```bash
# Installer Certbot
sudo apt install certbot python3-certbot-nginx

# Obtenir un certificat SSL
sudo certbot --nginx -d votre-domaine.com
```

## 📝 Étapes de déploiement

### 1. Préparer la machine
```bash
# Installer Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Installer Docker Compose
sudo apt install docker-compose
```

### 2. Cloner et configurer
```bash
# Cloner le projet
git clone https://github.com/Tamsir123/Biblio_app.git
cd Biblio_app

# Modifier la configuration avec votre IP
# Éditer .env et frontend-gestion-biblio/.env.local
```

### 3. Démarrer l'application
```bash
# Démarrer la base de données MySQL
docker run --name mysql_projet_dev -d \
  -p 4002:3306 \
  -e MYSQL_ROOT_PASSWORD=Tam@1# \
  -e MYSQL_DATABASE=bibliotheque_web \
  mysql:8.0

# Démarrer l'application
./deploy-with-existing-mysql.sh
```

### 4. Vérifier l'accès
```bash
# Tester l'accès depuis l'extérieur
curl http://VOTRE_IP_PUBLIQUE:3000  # Frontend
curl http://VOTRE_IP_PUBLIQUE:5000/api/books  # Backend
```

## 🌍 Accès externe

### URLs d'accès
- **Frontend** : `http://VOTRE_IP_PUBLIQUE:3000`
- **Backend API** : `http://VOTRE_IP_PUBLIQUE:5000/api`
- **Images** : `http://VOTRE_IP_PUBLIQUE:5000/uploads`

### Partage avec le professeur
```
Application de Gestion de Bibliothèque
URL : http://VOTRE_IP_PUBLIQUE:3000
API : http://VOTRE_IP_PUBLIQUE:5000/api

Compte administrateur :
Email : admin@biblio.com
Mot de passe : admin123
```

## 🔍 Dépannage

### Problèmes courants
1. **Port non accessible** : Vérifier le firewall et les règles du fournisseur cloud
2. **CORS Error** : Vérifier que FRONTEND_URL est correct dans le backend
3. **Images non affichées** : Vérifier l'accès au dossier uploads

### Logs
```bash
# Voir les logs
docker-compose logs backend
docker-compose logs frontend
```

## 💡 Avantages de cette approche

- ✅ **Simple** : Pas de configuration cloud complexe
- ✅ **Rapide** : Déploiement immédiat
- ✅ **Contrôle total** : Accès complet à la machine
- ✅ **Économique** : Pas de frais d'hébergement supplémentaires
- ✅ **Flexible** : Modifications faciles
