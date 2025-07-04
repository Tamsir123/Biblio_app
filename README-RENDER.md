# 🚀 Déploiement sur Render

## Configuration automatisée

Ce projet est configuré pour un déploiement automatique sur Render.

### Étapes de déploiement :

1. **Push sur GitHub**
   ```bash
   git add .
   git commit -m "Configuration Render ready"
   git push origin main
   ```

2. **Créer un compte sur [render.com](https://render.com)**

3. **Connecter votre dépôt GitHub**

4. **Utiliser le fichier render.yaml pour le déploiement automatique**

### URLs de l'application :
- **Frontend :** https://biblio-frontend.onrender.com
- **Backend API :** https://biblio-backend.onrender.com
- **Base de données :** Automatiquement configurée

### Fonctionnalités déployées :
- ✅ Interface React.js responsive
- ✅ API REST Node.js/Express 
- ✅ Base de données MySQL
- ✅ Authentification JWT
- ✅ Upload et gestion d'images
- ✅ Système d'emprunts complet
- ✅ Dashboard administrateur
- ✅ Notifications par email

### Variables d'environnement :
Toutes les variables sont configurées automatiquement via render.yaml

### Monitoring :
- Health checks automatiques
- Logs en temps réel
- Redémarrage automatique en cas d'erreur

Date de configuration : $(date)
