# 🌐 Guide ngrok - Exposition publique de l'application

## 📋 Étapes pour exposer votre application via ngrok

### 1. Installation de ngrok

```bash
# Méthode 1 : Via snap (recommandé)
sudo snap install ngrok

# Méthode 2 : Via téléchargement direct
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update && sudo apt install ngrok
```

### 2. Création d'un compte ngrok

1. Aller sur https://ngrok.com
2. Créer un compte gratuit
3. Récupérer votre **authtoken** depuis le dashboard

### 3. Configuration de l'authtoken

```bash
# Configurer l'authtoken (remplacer par votre token)
ngrok config add-authtoken VOTRE_TOKEN_ICI
```

### 4. Démarrage des tunnels

#### Option A : Tunnels séparés (simple)
```bash
# Terminal 1 - Frontend
ngrok http 3000

# Terminal 2 - Backend  
ngrok http 5000
```

#### Option B : Configuration multi-tunnel (recommandé)
Le script `expose-ngrok.sh` est déjà créé pour cela !

### 5. Configuration automatique

Après avoir configuré votre authtoken, lancez :
```bash
./expose-ngrok.sh
```

## 🔧 URLs obtenues

Ngrok vous donnera des URLs comme :
- **Frontend** : `https://abc123.ngrok.io` → votre port 3000
- **Backend** : `https://def456.ngrok.io` → votre port 5000

## 📱 Partage avec le professeur

```
Application de Gestion de Bibliothèque
URL : https://abc123.ngrok.io

Compte administrateur :
Email : admin@biblio.com
Mot de passe : admin123

Note : URLs ngrok valides tant que le tunnel est actif
```

## ⚠️ Limitations du plan gratuit

- 1 processus ngrok actif
- URLs temporaires (changent à chaque redémarrage)
- Limite de bande passante

## 💡 Conseils

1. **Gardez les terminaux ouverts** : Les tunnels se ferment si vous fermez le terminal
2. **Notez les URLs** : Elles changent à chaque redémarrage
3. **Plan payant** : Pour des URLs permanentes et plus de fonctionnalités
