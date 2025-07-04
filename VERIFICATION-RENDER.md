# Guide de vérification du déploiement Render

## Status du déploiement ✅

Les Dockerfile ont été testés et validés localement :
- ✅ Backend Dockerfile build réussi (depuis racine)
- ✅ Frontend Dockerfile build réussi (depuis racine)
- ✅ Dockerfile déplacés à la racine pour compatibilité Render
- ✅ render.yaml mis à jour avec nouveaux chemins
- ✅ Code poussé sur GitHub (commit: 6ff6755)

## URLs de l'application

### Backend API
- **URL**: https://biblio-backend.onrender.com
- **Health Check**: https://biblio-backend.onrender.com/api/health
- **Test API**: https://biblio-backend.onrender.com/api/books

### Frontend React
- **URL**: https://biblio-frontend.onrender.com

### Base de données
- **Service**: biblio-mysql (MySQL Render)
- **Status**: Doit être créé automatiquement

## Étapes de vérification

### 1. Vérifier le build des services
1. Aller sur https://dashboard.render.com
2. Vérifier que les 3 services apparaissent :
   - `biblio-backend` (Web Service)
   - `biblio-frontend` (Web Service) 
   - `biblio-mysql` (Database)

### 2. Vérifier les logs de build
- Chaque service doit avoir un build qui réussit
- Vérifier les logs pour détecter d'éventuelles erreurs

### 3. Tests fonctionnels

#### Backend
```bash
# Test de santé
curl https://biblio-backend.onrender.com/api/health

# Test des livres (devrait retourner une liste vide ou les livres)
curl https://biblio-backend.onrender.com/api/books
```

#### Frontend
- Ouvrir https://biblio-frontend.onrender.com
- Vérifier que la page se charge
- Tester la navigation
- Vérifier que les appels API fonctionnent

### 4. Test de l'upload d'images
1. Se connecter à l'application
2. Ajouter un livre avec une couverture
3. Vérifier que l'image s'affiche correctement

## Dépannage potentiel

### Si le backend ne démarre pas
- Vérifier les variables d'environnement dans Render
- Vérifier que la base de données MySQL est bien créée
- Consulter les logs du service

### Si le frontend ne se charge pas
- Vérifier que `VITE_API_URL` pointe vers le bon backend
- Vérifier les logs de build Nginx

### Si les images ne s'affichent pas
- Vérifier que le volume `uploads` est bien monté
- Tester l'URL directe d'une image uploadée

## Commandes utiles

### Rebuild forcé
Si nécessaire, depuis le dashboard Render :
1. Aller dans Settings du service
2. Cliquer sur "Manual Deploy" → "Deploy latest commit"

### Logs en temps réel
Depuis le dashboard Render, aller dans "Logs" pour chaque service.

## Configuration finale

### Variables d'environnement vérifiées ✅
- Backend : JWT_SECRET, DB_*, EMAIL_*, FRONTEND_URL
- Frontend : VITE_API_URL

### Réseau et CORS ✅
- Backend configuré pour accepter les requêtes du frontend Render
- Routes statiques pour les images configurées

### Persistance des données ✅
- Base MySQL Render pour les données
- Volume uploads intégré dans le container backend
