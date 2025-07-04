# Application de Gestion de Bibliothèque - Déploiement Docker

Cette application est composée de :
- **Frontend** : Application React/Vite avec TypeScript
- **Backend** : API Node.js/Express
- **Base de données** : MySQL (utilise le container existant `mysql_projet_dev`)

## Prérequis

- Docker et Docker Compose installés
- Container MySQL existant (`mysql_projet_dev`) en cours d'exécution sur le port 4002
- Node.js (pour le développement local)

## Structure du projet

```
biblio-app/
├── frontend-gestion-biblio/
│   ├── Dockerfile
│   ├── nginx.conf
│   └── ...
├── backend-gestion-biblio/
│   ├── Dockerfile
│   └── ...
├── docker-compose.yml
├── .env
├── deploy-with-existing-mysql.sh
└── README.md
```

## Configuration

### Fichier .env

Le fichier `.env` contient toutes les variables d'environnement nécessaires :

```bash
# Configuration JWT
JWT_SECRET=MaCleJWTUltraSecrete

# Configuration de la base de données (utilise le container existant)
DB_HOST=host.docker.internal
DB_USER=root
DB_PASSWORD=Tam@1#
DB_NAME=bibliotheque_web
DB_PORT=4002

# Configuration du serveur
PORT=5000
NODE_ENV=production

# Configuration Email
EMAIL_USER=tamsirjuuf@gmail.com
EMAIL_PASS=xsqb ocbs vmyn yqiy
EMAIL_SERVICE=gmail

# URL du frontend
FRONTEND_URL=http://localhost:3000

# Ports pour docker-compose
BACKEND_PORT=5000
FRONTEND_PORT=3000
```

## Déploiement

### Méthode 1 : Script automatique (recommandé)

```bash
chmod +x deploy-with-existing-mysql.sh
./deploy-with-existing-mysql.sh
```

### Méthode 2 : Commandes manuelles

```bash
# Vérifier que MySQL fonctionne
docker ps | grep mysql_projet_dev

# Construire et démarrer les services
docker-compose build --no-cache
docker-compose up -d

# Vérifier le statut
docker-compose ps
```

## Accès à l'application

Une fois déployée, l'application sera accessible sur :

- **Frontend** : http://localhost:3000
- **Backend API** : http://localhost:5000
- **Base de données** : localhost:4002 (container existant)

## Commandes utiles

```bash
# Voir les logs
docker-compose logs -f

# Voir les logs d'un service spécifique
docker-compose logs -f backend
docker-compose logs -f frontend

# Redémarrer un service
docker-compose restart backend

# Arrêter tous les services
docker-compose down

# Reconstruire un service
docker-compose build backend --no-cache
docker-compose up -d backend
```

## Résolution de problèmes

### Le backend ne peut pas se connecter à MySQL

Vérifiez que :
1. Le container MySQL `mysql_projet_dev` est en cours d'exécution
2. La base de données `bibliotheque_web` existe
3. Les credentials dans le fichier `.env` sont corrects

### Erreur de port déjà utilisé

Si vous avez une erreur de port déjà utilisé, modifiez les ports dans le fichier `.env` :

```bash
BACKEND_PORT=5001
FRONTEND_PORT=3001
```

### Problème de permissions avec les uploads

Si le backend a des problèmes avec le dossier uploads :

```bash
# Créer le volume et ajuster les permissions
docker-compose exec backend mkdir -p uploads/covers uploads/profiles
docker-compose exec backend chown -R node:node uploads
```

## Base de données

La base de données utilise le container MySQL existant. Assurez-vous que :

1. Le container `mysql_projet_dev` est démarré
2. La base de données `bibliotheque_web` existe
3. Le schéma est importé

Pour importer le schéma manuellement :

```bash
mysql -h 127.0.0.1 -P 4002 -u root -p'Tam@1#' bibliotheque_web < backend-gestion-biblio/database/schema_complet.sql
```

## Déploiement avec IP Publique 🌐

Pour rendre l'application accessible depuis l'extérieur via votre adresse IP publique :

### Configuration rapide
```bash
# 1. Configurer l'IP publique
./setup-ip.sh

# 2. Démarrer l'application
./start-app.sh
```

### Accès externe
Une fois configuré, l'application sera accessible via :
- **Frontend** : `http://VOTRE_IP:3000`
- **Backend API** : `http://VOTRE_IP:5000/api`

### Guides détaillés
- [Guide complet IP publique](./DEPLOIEMENT-IP-PUBLIQUE.md)
- [Guide rapide](./GUIDE-RAPIDE-IP.md)

### Prérequis
- Ports 3000 et 5000 ouverts dans le firewall
- Docker et Docker Compose installés
- Adresse IP publique accessible

## Développement

Pour le développement local, vous pouvez utiliser :

```bash
# Backend
cd backend-gestion-biblio
npm install
npm run dev

# Frontend
cd frontend-gestion-biblio
npm install
npm run dev
```
