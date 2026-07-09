# 🛠️ SOLUTION TECHNIQUE COMPLÈTE

**Projet** : Andoh & Dohgad Consulting  
**Problème** : Page blanche sur Vercel  
**Solution** : Configuration automatique via script

---

## ⚡ SOLUTION RAPIDE (Recommandée)

```bash
cd /home/serge/Téléchargements/dohgahnew/webandoh
./configure-vercel.sh
```

Puis configurer Supabase : https://supabase.com/dashboard/project/tszsvbzfufglvdcsjzpo/auth/url-configuration

---

## 🎯 SOLUTIONS ALTERNATIVES

### Étape 1 : Créer le fichier `vercel.json` ⭐ PRIORITÉ 1

**Problème** : Vercel ne sait pas que c'est une Single Page Application (SPA) React.

**Solution** : Créer un fichier `vercel.json` à la racine du dossier `webandoh/`

```bash
cd /home/serge/Téléchargements/dohgahnew/webandoh
touch vercel.json
```

**Contenu du fichier `vercel.json`** :

```json
{
  "version": 2,
  "buildCommand": "npm run build",
  "outputDirectory": "dist",
  "framework": "vite",
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        }
      ]
    },
    {
      "source": "/assets/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "public, max-age=31536000, immutable"
        }
      ]
    }
  ]
}
```

**Explication** :
- `rewrites` : Toutes les routes (`/services`, `/blog`, etc.) redirigent vers `index.html` (comportement SPA)
- `outputDirectory: "dist"` : Indique où se trouvent les fichiers buildés
- `headers` : Ajout de headers de sécurité
- `Cache-Control` pour les assets : 1 an de cache pour les fichiers statiques

---

### Étape 2 : Configurer les variables d'environnement sur Vercel ⭐ PRIORITÉ 1

**Problème** : Les variables `.env.local` ne sont PAS uploadées sur Vercel (par sécurité).

**Solution** : Configurer manuellement sur Vercel Dashboard

#### 🔹 Comment configurer les variables sur Vercel :

1. **Aller sur Vercel Dashboard** :
   - Ouvrir https://vercel.com/dashboard
   - Sélectionner votre projet

2. **Aller dans Settings > Environment Variables** :
   - Cliquer sur "Settings" (menu de gauche)
   - Cliquer sur "Environment Variables"

3. **Ajouter TOUTES ces variables** :

| Variable | Valeur | Environment |
|----------|--------|-------------|
| `VITE_SUPABASE_URL` | `https://tszsvbzfufglvdcsjzpo.supabase.co` | Production |
| `VITE_SUPABASE_ANON_KEY` | `sb_publishable_8JE4raZ0xYRgi4knQnFnbQ_YAbY9NEU` | Production |
| `VITE_STRIPE_PUBLIC_KEY` | `pk_test_...` (votre clé Stripe publique) | Production |
| `VITE_EMAILJS_SERVICE_ID` | Votre ID service EmailJS | Production |
| `VITE_EMAILJS_TEMPLATE_ID` | Votre ID template EmailJS | Production |
| `VITE_EMAILJS_PUBLIC_KEY` | Votre clé publique EmailJS | Production |
| `VITE_APP_URL` | `https://votre-domaine.vercel.app` | Production |

**⚠️ IMPORTANT** :
- Cocher "Production" pour chaque variable
- Ne PAS ajouter les clés secrètes côté serveur (STRIPE_SECRET_KEY, etc.) car c'est un frontend statique
- Les clés commençant par `VITE_` sont injectées dans le build et accessibles côté client

#### 🔹 Comment obtenir les clés manquantes :

**Supabase** (déjà OK) :
- URL : `https://tszsvbzfufglvdcsjzpo.supabase.co`
- Anon Key : Dans votre fichier `.env.local` (déjà fourni)

**Stripe** :
1. Aller sur https://dashboard.stripe.com/test/apikeys
2. Copier "Publishable key" (`pk_test_...`)
3. Coller dans `VITE_STRIPE_PUBLIC_KEY`

**EmailJS** :
1. Aller sur https://dashboard.emailjs.com/
2. Créer un service email (Gmail, Outlook, etc.)
3. Créer un template pour les emails de contact/rendez-vous
4. Copier :
   - Service ID
   - Template ID
   - Public Key (dans "Account")

---

### Étape 3 : Vérifier la configuration du build Vercel ⭐ PRIORITÉ 2

**Problème** : Vercel doit savoir où se trouve le projet React.

**Solution** : Configurer correctement le Root Directory sur Vercel

#### 🔹 Si vous déployez depuis le dossier racine `/dohgahnew` :

1. **Vercel Dashboard** > Votre projet > **Settings** > **General**
2. **Root Directory** : Définir sur `webandoh`
3. **Build Command** : `npm run build` (par défaut OK)
4. **Output Directory** : `dist` (par défaut OK)
5. **Install Command** : `npm install` (par défaut OK)

#### 🔹 Alternative : Déployer directement depuis `/webandoh`

**Méthode recommandée** : Connecter Git directement au dossier `webandoh/`

```bash
# Depuis votre machine locale
cd /home/serge/Téléchargements/dohgahnew/webandoh

# Initialiser un nouveau repo Git UNIQUEMENT pour le frontend
git init
git add .
git commit -m "Initial commit - Frontend"

# Créer un nouveau repo GitHub
# Puis push
git remote add origin https://github.com/votre-username/andoh-dohgad-frontend.git
git push -u origin main

# Connecter ce repo à Vercel (New Project)
```

**Avantage** : Vercel détecte automatiquement Vite et configure tout.

---

### Étape 4 : Ajuster la configuration Vite (optionnel) ⭐ PRIORITÉ 3

**Problème potentiel** : Le `base: './'` peut poser problème sur Vercel.

**Solution** : Modifier `vite.config.ts` pour utiliser un chemin absolu.

**Fichier** : `webandoh/vite.config.ts`

**Remplacer** :
```typescript
export default defineConfig({
  base: './',  // ❌ Relatif
  // ...
});
```

**Par** :
```typescript
export default defineConfig({
  base: '/',  // ✅ Absolu (standard pour Vercel)
  // ...
});
```

**Puis rebuilder** :
```bash
cd /home/serge/Téléchargements/dohgahnew/webandoh
npm run build
```

---

### Étape 5 : Redéployer sur Vercel 🚀

**Après avoir fait les étapes 1, 2, 3 et 4** :

#### Option A : Via Vercel CLI

```bash
# Installer Vercel CLI
npm i -g vercel

# Se connecter
vercel login

# Déployer depuis le dossier webandoh
cd /home/serge/Téléchargements/dohgahnew/webandoh
vercel --prod
```

#### Option B : Via Git Push (si connecté à GitHub)

```bash
cd /home/serge/Téléchargements/dohgahnew/webandoh
git add .
git commit -m "Fix: Add vercel.json and update config for Vercel deployment"
git push origin main
```

Vercel détectera le push et redéploiera automatiquement.

#### Option C : Via Vercel Dashboard (redéploiement manuel)

1. Aller sur https://vercel.com/dashboard
2. Sélectionner le projet
3. Onglet "Deployments"
4. Cliquer sur "Redeploy" sur le dernier déploiement
5. Cocher "Use existing Build Cache" = NON (forcer rebuild)
6. Cliquer "Redeploy"

---

### Étape 6 : Débugger les erreurs runtime 🔍

**Une fois déployé, si la page est toujours blanche** :

1. **Ouvrir le site déployé** sur Vercel (`https://votre-projet.vercel.app`)

2. **Ouvrir la Console DevTools** :
   - Appuyer sur `F12` (Chrome/Firefox)
   - Onglet "Console"

3. **Vérifier les erreurs** :

   **Erreur typique 1** : `Missing Supabase environment variables`
   - ❌ Cause : Variables env non configurées sur Vercel
   - ✅ Solution : Retour à l'Étape 2

   **Erreur typique 2** : `Failed to load resource: 404` sur `/assets/...`
   - ❌ Cause : Problème de `base` dans `vite.config.ts`
   - ✅ Solution : Étape 4 (mettre `base: '/'`)

   **Erreur typique 3** : `Cannot read properties of undefined (reading 'user')`
   - ❌ Cause : AuthContext pas initialisé correctement
   - ✅ Solution : Vérifier que Supabase URL/Key sont corrects

   **Erreur typique 4** : CORS bloqué par Supabase
   - ❌ Cause : Domaine Vercel non autorisé dans Supabase
   - ✅ Solution : Voir Étape 7

4. **Vérifier l'onglet "Network"** :
   - Voir quelles requêtes échouent (rouge)
   - Vérifier les codes HTTP (404, 500, etc.)

---

### Étape 7 : Configurer Supabase pour Vercel 🔐

**Problème** : Supabase peut bloquer les requêtes venant de Vercel (CORS).

**Solution** : Autoriser votre domaine Vercel dans Supabase.

1. **Aller sur Supabase Dashboard** :
   - https://supabase.com/dashboard/project/tszsvbzfufglvdcsjzpo

2. **Settings > API** :
   - Copier l'URL du projet : `https://tszsvbzfufglvdcsjzpo.supabase.co`
   - Copier l'anon key

3. **Authentication > URL Configuration** :
   - **Site URL** : `https://votre-projet.vercel.app`
   - **Redirect URLs** : Ajouter :
     - `https://votre-projet.vercel.app/**`
     - `https://votre-projet.vercel.app/auth/callback`

4. **Sauvegarder**

---

## 🧪 TESTS POST-DÉPLOIEMENT

### Checklist de vérification ✅

| Test | Comment tester | Résultat attendu |
|------|----------------|------------------|
| **Page d'accueil** | Ouvrir `/` | Héro + sections visibles |
| **Navigation** | Cliquer sur "Services" | Page `/services` s'affiche |
| **Rechargement direct** | Ouvrir `/services` en URL directe | Page s'affiche (pas 404) |
| **Changement de langue** | Cliquer FR → EN → ES | Texte change sans erreur |
| **Formulaire contact** | Remplir et envoyer | Message de succès (si EmailJS configuré) |
| **Connexion Supabase** | Aller sur `/connexion` | Formulaire s'affiche sans erreur console |
| **Console DevTools** | F12 > Console | Aucune erreur rouge |
| **Network tab** | F12 > Network | Aucune requête 404/500 sur Supabase |

---

## 🔧 SOLUTIONS ALTERNATIVES SI ÇA NE FONCTIONNE TOUJOURS PAS

### Option 1 : Déployer uniquement le frontend statique (sans backend)

**Si les paiements et Supabase ne sont pas critiques immédiatement** :

1. **Désactiver temporairement Supabase** :
   - Commenter l'import de `AuthProvider` dans `App.tsx`
   - Désactiver les routes protégées

2. **Modifier `src/lib/supabase/client.ts`** :
```typescript
// Version fallback sans erreur
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || 'https://placeholder.supabase.co';
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'placeholder';

// Ne plus throw l'erreur
// if (!supabaseUrl || !supabaseAnonKey) {
//   throw new Error('Missing Supabase environment variables');
// }
```

3. **Rebuild et redéployer**

**Avantage** : Le site vitrine fonctionne même sans backend.

---

### Option 2 : Utiliser Netlify au lieu de Vercel

**Si Vercel pose trop de problèmes** :

Netlify gère mieux les SPAs React par défaut.

1. **Créer un fichier `_redirects`** dans `webandoh/public/` :
```
/*    /index.html   200
```

2. **Déployer sur Netlify** :
```bash
npm i -g netlify-cli
cd /home/serge/Téléchargements/dohgahnew/webandoh
netlify deploy --prod
```

3. **Configurer les variables env** sur Netlify Dashboard

---

### Option 3 : Utiliser un serveur Node.js (Express) pour servir la SPA

**Si vous voulez avoir un vrai backend custom** :

1. **Créer un serveur Express** dans `webandoh/` :

```javascript
// server.js
const express = require('express');
const path = require('path');
const app = express();

app.use(express.static('dist'));

app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'dist', 'index.html'));
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
```

2. **Modifier `package.json`** :
```json
{
  "scripts": {
    "start": "node server.js",
    "build": "tsc -b && vite build"
  },
  "dependencies": {
    "express": "^4.18.0"
  }
}
```

3. **Vercel detectera automatiquement Node.js** et déploiera le serveur.

---

## 📦 FICHIERS À CRÉER/MODIFIER (RÉCAPITULATIF)

### 1. Créer `webandoh/vercel.json`

```json
{
  "version": 2,
  "buildCommand": "npm run build",
  "outputDirectory": "dist",
  "framework": "vite",
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        }
      ]
    },
    {
      "source": "/assets/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "public, max-age=31536000, immutable"
        }
      ]
    }
  ]
}
```

### 2. Modifier `webandoh/vite.config.ts`

**Ligne à changer** :
```typescript
base: '/',  // Au lieu de './'
```

### 3. Configurer variables Vercel Dashboard

**Via Settings > Environment Variables** :
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`
- `VITE_STRIPE_PUBLIC_KEY`
- `VITE_EMAILJS_SERVICE_ID`
- `VITE_EMAILJS_TEMPLATE_ID`
- `VITE_EMAILJS_PUBLIC_KEY`
- `VITE_APP_URL`

### 4. Configurer Supabase Dashboard

**Authentication > URL Configuration** :
- Site URL : `https://votre-projet.vercel.app`
- Redirect URLs : `https://votre-projet.vercel.app/**`

---

## 🚀 ORDRE D'EXÉCUTION OPTIMAL

### Phase 1 : Configuration locale (15 minutes)

```bash
# 1. Créer vercel.json
cd /home/serge/Téléchargements/dohgahnew/webandoh
cat > vercel.json << 'EOF'
{
  "version": 2,
  "buildCommand": "npm run build",
  "outputDirectory": "dist",
  "framework": "vite",
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
EOF

# 2. Modifier vite.config.ts (changer base: './' en base: '/')
# Utiliser un éditeur de texte

# 3. Rebuilder
npm run build

# 4. Vérifier que dist/ contient index.html + assets/
ls -la dist/
```

### Phase 2 : Configuration Vercel Dashboard (10 minutes)

1. Ouvrir https://vercel.com/dashboard
2. Sélectionner le projet
3. Settings > General > Root Directory : `webandoh`
4. Settings > Environment Variables : Ajouter toutes les variables `VITE_*`
5. Sauvegarder

### Phase 3 : Configuration Supabase (5 minutes)

1. Ouvrir https://supabase.com/dashboard/project/tszsvbzfufglvdcsjzpo
2. Authentication > URL Configuration
3. Ajouter le domaine Vercel
4. Sauvegarder

### Phase 4 : Déploiement (5 minutes)

```bash
# Option A : Via Vercel CLI
vercel --prod

# Option B : Via Git (si connecté)
git add .
git commit -m "Fix: Configure Vercel deployment"
git push origin main
```

### Phase 5 : Vérification (10 minutes)

1. Ouvrir `https://votre-projet.vercel.app`
2. F12 > Console : Vérifier aucune erreur
3. Tester navigation entre pages
4. Tester rechargement direct d'une page (ex: `/services`)
5. Tester changement de langue

**Temps total estimé** : 45 minutes

---

## 🎯 CRITÈRES DE SUCCÈS

Le déploiement est réussi si :

✅ La page d'accueil s'affiche complètement (pas blanche)  
✅ La navigation fonctionne (clic sur menu → nouvelle page)  
✅ Le rechargement direct d'une route fonctionne (pas 404)  
✅ Le changement de langue fonctionne  
✅ Aucune erreur dans Console DevTools  
✅ Les formulaires s'affichent correctement  
✅ Les images/assets se chargent  
✅ Le site est responsive (mobile + desktop)

---

## 📞 SUPPORT & RESSOURCES

**Documentation officielle** :
- Vercel SPA deployment : https://vercel.com/guides/deploying-react-with-vercel
- Vite deployment : https://vitejs.dev/guide/static-deploy.html#vercel
- Supabase CORS : https://supabase.com/docs/guides/api/cors

**Debugging Vercel** :
- Logs de build : Vercel Dashboard > Deployments > [Cliquer sur deployment] > "Build Logs"
- Logs runtime : Vercel Dashboard > Deployments > "Function Logs"
- Variables env : Vercel Dashboard > Settings > Environment Variables

**Si besoin d'aide** :
- Vérifier les logs Vercel en premier
- Vérifier Console browser en second
- Contacter support Vercel : https://vercel.com/support

---

**Document créé le** : 9 juillet 2026  
**Par** : Claude Code (Sonnet 4.5)  
**Statut** : ✅ Solution complète prête à appliquer
