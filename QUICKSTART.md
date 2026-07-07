# ⚡ QUICKSTART - DÉMARRAGE RAPIDE

## 🎯 Objectif

Mettre en place le backend complet en **15 minutes** !

---

## ✅ Prérequis

- [ ] Compte Supabase créé : https://supabase.com
- [ ] Projet Supabase `tszsvbzfufglvdcsjzpo` accessible
- [ ] Node.js 20+ installé
- [ ] Git installé

---

## 🚀 ÉTAPES (15 minutes)

### 1️⃣ Configuration initiale (2 min)

```bash
# Vérifier que les dépendances sont installées
npm install

# Copier le fichier d'environnement
cp .env.example .env.local
```

### 2️⃣ Récupérer les clés Supabase (3 min)

1. Allez sur https://supabase.com/dashboard/project/tszsvbzfufglvdcsjzpo
2. Menu **Settings** > **API**
3. Copier les valeurs dans `.env.local` :

```env
VITE_SUPABASE_URL=https://tszsvbzfufglvdcsjzpo.supabase.co
VITE_SUPABASE_ANON_KEY=[Copier depuis Project API keys > anon public]
SUPABASE_SERVICE_ROLE_KEY=[Copier depuis Project API keys > service_role]
SUPABASE_DB_PASSWORD=Proud@#2026-
```

### 3️⃣ Exécuter les migrations (5 min)

**Option A : Via Dashboard (Recommandé)**

1. Menu **SQL Editor** dans Supabase Dashboard
2. Copier-coller le contenu de chaque fichier **dans l'ordre** :

```
supabase/migrations/20260706000001_create_profiles.sql         ✅
supabase/migrations/20260706000002_create_services.sql         ✅
supabase/migrations/20260706000003_create_blog.sql             ✅
supabase/migrations/20260706000004_create_documentation.sql    ✅
supabase/migrations/20260706000005_create_appointments.sql     ✅
supabase/migrations/20260706000006_create_coworking.sql        ✅
supabase/migrations/20260706000007_create_surveys.sql          ✅
supabase/migrations/20260706000008_create_contact_solutions.sql ✅
supabase/migrations/20260706000009_create_audit_logs.sql       ✅
supabase/migrations/20260706000010_create_storage_buckets.sql  ✅
```

3. Cliquer "RUN" pour chaque fichier

**Option B : Via psql (Si vous préférez CLI)**

```bash
cd supabase/migrations
PGPASSWORD="Proud@#2026-" psql -h db.tszsvbzfufglvdcsjzpo.supabase.co -U postgres -d postgres -p 5432 < 20260706000001_create_profiles.sql
# Répéter pour chaque fichier...
```

### 4️⃣ Créer le compte admin (2 min)

1. Menu **Authentication** > **Users**
2. Cliquer **"Add user"** > **"Create new user"**
3. Remplir :
   - **Email** : `contact@andoh-dohgad.com`
   - **Password** : `[CHOISIR UN MOT DE PASSE FORT]`
   - **Auto Confirm User** : ✅ Coché
4. Cliquer **"Create user"**

Le profil sera créé automatiquement avec `role='admin'` par le trigger PostgreSQL.

### 5️⃣ Seed les services (1 min)

Dans **SQL Editor**, copier-coller et exécuter :

```sql
-- Contenu de supabase/seed/seed_services.sql
```

### 6️⃣ Lancer l'application (1 min)

```bash
npm run dev
```

Ouvrir http://localhost:5173

### 7️⃣ Tester la connexion (1 min)

1. Aller sur `/auth/connexion`
2. Se connecter avec :
   - Email : `contact@andoh-dohgad.com`
   - Password : [votre mot de passe]
3. Si succès → Vous êtes redirigé vers `/mon-compte` ✅

---

## ✅ VÉRIFICATION

### Test 1 : Base de données

Ouvrir la console navigateur (F12) et taper :

```javascript
import { supabase } from './src/lib/supabase/client';
const { data } = await supabase.from('services').select('*');
console.log('Services:', data);
```

**Résultat attendu** : 6 services affichés ✅

### Test 2 : Authentification

```javascript
import { useAuth } from './src/contexts/AuthContext';
const { user, profile } = useAuth();
console.log('User:', user);
console.log('Role:', profile?.role);
```

**Résultat attendu** : `role: "admin"` ✅

### Test 3 : Storage

1. Menu **Storage** dans Supabase Dashboard
2. Vous devriez voir 5 buckets :
   - documentation (🔒 privé)
   - blog-images (🌐 public)
   - service-images (🌐 public)
   - avatars (🌐 public)
   - coworking-images (🌐 public)

---

## 🎉 SUCCÈS !

Si tous les tests passent, votre backend est **opérationnel** !

**Vous pouvez maintenant** :

✅ Créer des comptes utilisateurs  
✅ Gérer les services via l'API  
✅ Créer des rendez-vous  
✅ Soumettre des sondages  
✅ Envoyer des messages de contact  

---

## 🔧 Configuration optionnelle (Paiements)

### Stripe (Paiements par carte)

1. Créer compte : https://dashboard.stripe.com/register
2. Activer **Test mode**
3. **Developers** > **API keys** :
   - Copier **Publishable key** → `VITE_STRIPE_PUBLIC_KEY`
   - Copier **Secret key** → `STRIPE_SECRET_KEY`

### Orange Money (CI)

1. S'inscrire : https://developer.orange.com/
2. Souscrire à "Orange Money WebPay"
3. Récupérer clés API → `.env.local`

### MTN Mobile Money (CI)

1. S'inscrire : https://momodeveloper.mtn.com/
2. Souscrire à "Collection API"
3. Récupérer clés API → `.env.local`

---

## 📚 PROCHAINES ÉTAPES

Maintenant que le backend fonctionne, vous pouvez :

1. **Compléter les composants frontend** :
   - Dashboard admin (gestion services, blog, docs)
   - Dashboard utilisateur (achats, RDV)
   - Composant paiement unifié

2. **Migrer les données statiques** :
   - Services de `/src/data/services.ts` → Supabase
   - Blog de `/src/data/blog.ts` → Supabase
   - Docs de `/src/data/documentation.ts` → Supabase

3. **Créer les Edge Functions** (optionnel) :
   - Webhooks paiement
   - Génération liens signés
   - Envoi emails automatiques

4. **Déployer en production** :
   - Vercel / Netlify
   - Configurer domaine
   - Activer SSL

---

## 🆘 PROBLÈMES COURANTS

### ❌ "Cannot find module '@supabase/supabase-js'"

```bash
npm install
```

### ❌ "Missing Supabase environment variables"

Vérifier que `.env.local` contient bien :
```
VITE_SUPABASE_URL=...
VITE_SUPABASE_ANON_KEY=...
```

Puis redémarrer :
```bash
npm run dev
```

### ❌ "permission denied for table services"

Vérifier que les migrations RLS ont été exécutées :

```sql
-- Dans SQL Editor
SELECT * FROM pg_policies WHERE tablename = 'services';
```

Devrait retourner au moins 2 policies.

### ❌ "relation 'profiles' does not exist"

Les migrations n'ont pas été exécutées. Reprendre l'étape 3️⃣.

---

## 📞 BESOIN D'AIDE ?

- 📖 **Documentation complète** : Voir `BACKEND_README.md`
- 🚀 **Guide de déploiement** : Voir `supabase/DEPLOY.md`
- 🏗️ **Architecture** : Voir `ARCHITECTURE.md`
- 📊 **Résumé backend** : Voir `BACKEND_SUMMARY.md`

---

**Temps total** : ~15 minutes ⏱️  
**Difficulté** : ⭐⭐☆☆☆ (Facile)  
**Support** : guehipoegnansergej@gmail.com
