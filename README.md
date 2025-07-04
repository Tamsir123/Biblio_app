# 📚 Application de Gestion de Bibliothèque

## 🎓 Projet Étudiant - Tamsir

Application complète de gestion de bibliothèque développée avec **React.js**, **Node.js**, **Express** et **MySQL**.

## 🚀 Technologies utilisées

- **Frontend**: React.js, Vite, Tailwind CSS, TypeScript
- **Backend**: Node.js, Express.js, JWT Authentication
- **Base de données**: MySQL
- **Upload**: Multer pour la gestion des images
- **Email**: Nodemailer (Gmail)
- **Déploiement**: Docker, Railway
- **Sécurité**: CORS, Helmet, Rate Limiting

## ✨ Fonctionnalités complètes

### 🔐 Authentification et Autorisation
- Inscription/Connexion sécurisée avec JWT
- Gestion des rôles (Admin/Utilisateur)
- Protection des routes et APIs

### 📚 Gestion des livres
- CRUD complet pour les livres
- Upload d'images de couverture
- Recherche et filtrage avancés
- Catégorisation par genres

### 👥 Gestion des utilisateurs
- Profils utilisateurs personnalisables
- Upload de photos de profil
- Historique d'activités
- Statistiques personnelles

### 📄 Système d'emprunts
- Emprunt et retour de livres
- Gestion des dates d'échéance
- Renouvellement automatique
- Calcul de pénalités

### ⭐ Avis et commentaires
- Système de notation (1-5 étoiles)
- Commentaires détaillés
- Modération des avis

### 📧 Notifications intelligentes
- Rappels d'échéance par email
- Notifications de nouveaux livres
- Alertes administratives

### 📊 Dashboard administrateur
- Analytics en temps réel
- Statistiques d'utilisation
- Gestion des utilisateurs
- Rapports détaillés

### 🖼️ Gestion des médias
- Upload sécurisé d'images
- Compression automatique
- Stockage persistant avec volumes Docker

## 🔑 Comptes de démonstration

### Administrateur
- **Email**: admin@biblio.com
- **Mot de passe**: admin123

### Utilisateur standard
- **Email**: user@biblio.com  
- **Mot de passe**: user123

## 🐳 Déploiement avec Docker

### Prérequis
- Docker et Docker Compose installés
- MySQL en cours d'exécution (container mysql_projet_dev)

### Démarrage local
```bash
# Cloner le projet
git clone [URL_DU_REPO]
cd Biblio_app

# Démarrer avec Docker Compose
./deploy-with-existing-mysql.sh

# Ou manuellement
docker compose up -d
```

### Accès local
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5000
- **Base de données**: localhost:4002

## 🚀 Déploiement sur Railway

### Étapes rapides
1. Fork ce repository sur GitHub
2. Connecter Railway à votre compte GitHub
3. Importer le projet depuis GitHub
4. Ajouter une base de données MySQL
5. Configurer les variables d'environnement (voir `.env.railway`)
6. Déployer automatiquement !

### Variables d'environnement Railway
Voir le fichier `.env.railway` pour la configuration complète.

## 📱 Structure du projet

```
Biblio_app/
├── backend-gestion-biblio/          # API Node.js/Express
│   ├── controllers/                 # Logique métier
│   ├── models/                      # Modèles de données
│   ├── routes/                      # Routes API
│   ├── middleware/                  # Middlewares (auth, upload, etc.)
│   ├── services/                    # Services (email, notifications)
│   ├── uploads/                     # Fichiers uploadés
│   ├── config/                      # Configuration DB
│   ├── Dockerfile                   # Container backend
│   └── server.js                    # Point d'entrée
├── frontend-gestion-biblio/         # Interface React.js
│   ├── src/
│   │   ├── components/              # Composants réutilisables
│   │   ├── pages/                   # Pages de l'application
│   │   ├── contexts/                # Contextes React
│   │   ├── hooks/                   # Hooks personnalisés
│   │   └── services/                # Services API
│   ├── Dockerfile                   # Container frontend
│   └── nginx.conf                   # Configuration Nginx
├── docker-compose.yml               # Orchestration Docker
├── railway.json                     # Configuration Railway
└── README.md                        # Documentation

```

## 🔧 APIs disponibles

### Authentification
- `POST /api/auth/register` - Inscription
- `POST /api/auth/login` - Connexion
- `POST /api/auth/refresh` - Renouvellement token

### Livres
- `GET /api/books` - Liste des livres
- `POST /api/books` - Créer un livre (Admin)
- `PUT /api/books/:id` - Modifier un livre (Admin)
- `DELETE /api/books/:id` - Supprimer un livre (Admin)

### Emprunts
- `GET /api/borrowings` - Historique des emprunts
- `POST /api/borrowings` - Emprunter un livre
- `PUT /api/borrowings/:id/return` - Retourner un livre

### Utilisateurs
- `GET /api/users/profile` - Profil utilisateur
- `PUT /api/users/profile` - Modifier le profil
- `POST /api/users/profile/image` - Upload photo de profil

## 📊 Fonctionnalités avancées

### Sécurité
- Protection CSRF
- Validation des données d'entrée
- Hashage des mots de passe (bcrypt)
- Rate limiting
- Headers de sécurité

### Performance
- Compression des réponses
- Cache des ressources statiques
- Optimisation des requêtes SQL
- Images optimisées

### Monitoring
- Health checks Docker
- Logs structurés
- Métriques d'utilisation
- Alertes automatiques

## 📧 Contact et Support

**Développeur**: Tamsir  
**Email**: tamsirjuuf@gmail.com  
**Projet**: Application de Gestion de Bibliothèque  
**Framework**: MERN Stack + MySQL

---

## 🎯 Objectifs pédagogiques atteints

✅ **Développement Full-Stack** avec MERN + MySQL  
✅ **Authentification et autorisation** complètes  
✅ **Containerisation Docker** avec multi-services  
✅ **API RESTful** bien structurée  
✅ **Interface utilisateur moderne** et responsive  
✅ **Gestion de fichiers** et upload sécurisé  
✅ **Base de données relationnelle** optimisée  
✅ **Déploiement cloud** avec Railway  
✅ **Bonnes pratiques** de développement

---

*Projet réalisé dans le cadre de la formation en développement web*
