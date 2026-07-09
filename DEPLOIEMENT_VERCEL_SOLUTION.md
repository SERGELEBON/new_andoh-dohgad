# 🚀 SOLUTION DÉFINITIVE - DÉPLOIEMENT VERCEL

**Date** : 9 juillet 2026  
**Status** : ✅ TESTÉ ET VALIDÉ

---

## ⚠️ RÈGLE D'OR - À NE JAMAIS OUBLIER

**TOUJOURS déployer depuis le dossier PARENT `/home/serge/Téléchargements/dohgahnew`**

**JAMAIS depuis `/home/serge/Téléchargements/dohgahnew/webandoh`**

### Pourquoi ?

Le projet Vercel est configuré avec **Root Directory = `webandoh`**

- ✅ Si on déploie depuis `/dohgahnew` → Vercel cherche `dohgahnew/webandoh` → ✅ FONCTIONNE
- ❌ Si on déploie depuis `/dohgahnew/webandoh` → Vercel cherche `webandoh/webandoh` → ❌ ERREUR

---

## 📋 PROCÉDURE DE DÉPLOIEMENT

### Commande unique à exécuter :

```bash
cd /home/serge/Téléchargements/dohgahnew && vercel --prod --yes
```

**C'est tout !** Vercel va :
1. Aller dans le dossier `webandoh/` (Root Directory configuré)
2. Installer les dépendances (`npm install`)
3. Builder le projet (`npm run build`)
4. Déployer sur production

---

## 🔧 CONFIGURATION VERCEL (NE PAS MODIFIER)

### Settings actuels qui fonctionnent :

**URL** : https://vercel.com/guehipoegnansergejs-projects/new-andoh-dohgad/settings

| Paramètre | Valeur | ⚠️ Ne pas changer |
|-----------|--------|-------------------|
| **Root Directory** | `webandoh` | ✅ CRITIQUE |
| **Build Command** | `npm run build` | ✅ OK |
| **Output Directory** | `dist` | ✅ OK |
| **Install Command** | `npm install` | ✅ OK |
| **Framework Preset** | Vite | ✅ OK |

---

## 🎯 EN CAS D'ERREUR "webandoh/webandoh does not exist"

**Cause** : Vous avez déployé depuis le mauvais dossier

**Solution** :
```bash
# Retourner au dossier parent
cd /home/serge/Téléchargements/dohgahnew

# Redéployer
vercel --prod --yes
```

---

## 📝 WORKFLOW GIT + DÉPLOIEMENT

### Quand vous modifiez le code :

```bash
# 1. Aller dans webandoh pour coder
cd /home/serge/Téléchargements/dohgahnew/webandoh

# 2. Faire vos modifications...

# 3. Commiter dans webandoh
git add -A
git commit -m "Votre message"
git push origin main

# 4. REMONTER au parent pour déployer
cd ..

# 5. Mettre à jour le pointeur submodule (optionnel)
git add webandoh
git commit -m "Update webandoh"
git push origin main

# 6. DÉPLOYER depuis le parent
vercel --prod --yes
```

**RAPPEL** : Le déploiement se fait TOUJOURS depuis `/dohgahnew`, jamais depuis `/dohgahnew/webandoh`

---

## 🌐 URLS DE PRODUCTION

- **Site principal** : https://new-andoh-dohgad.vercel.app
- **Admin** : https://new-andoh-dohgad.vercel.app/admin
- **Documentation admin** : https://new-andoh-dohgad.vercel.app/admin/documentation
- **Documentation publique** : https://new-andoh-dohgad.vercel.app/documentation

---

## 📊 DERNIERS DÉPLOIEMENTS RÉUSSIS

| Date | Commit | Status | URL |
|------|--------|--------|-----|
| 2026-07-09 06:00 | `5d21696` Disable noUnusedLocals | ✅ Ready | https://new-andoh-dohgad-lue2wr5o0-guehipoegnansergejs-projects.vercel.app |
| 2026-07-09 01:00 | `7ae94ec` Add complete SQL for blog | ✅ Ready | https://new-andoh-dohgad-1mo9w7omk-guehipoegnansergejs-projects.vercel.app |

---

## 🔑 VARIABLES D'ENVIRONNEMENT VERCEL

Ces variables sont déjà configurées sur Vercel (Production) :

```
VITE_SUPABASE_URL=https://tszsvbzfufglvdcsjzpo.supabase.co
VITE_SUPABASE_ANON_KEY=sb_publishable_8JE4raZ0xYRgi4knQnFnbQ_YAbY9NEU
VITE_APP_URL=https://new-andoh-dohgad.vercel.app
```

**Source de la clé** : Récupérée depuis le commit `9a0988e` dans `configure-vercel.sh`

---

## ⚡ DÉPLOIEMENT AUTOMATIQUE

Vercel est connecté au repo GitHub `SERGELEBON/new_andoh-dohgad`.

Mais **ATTENTION** : Les pushs dans le sous-dossier `webandoh/` ne déclenchent PAS automatiquement Vercel car le dossier webandoh a son propre repo git indépendant.

**Pour déclencher un déploiement** :
1. Faire un commit dans le repo parent `/dohgahnew`
2. OU déployer manuellement avec `vercel --prod`

---

## 🛠️ TROUBLESHOOTING

### Erreur : Build failed avec erreurs TypeScript

**Cause** : `noUnusedLocals` et `noUnusedParameters` activés dans `tsconfig.app.json`

**Solution** : Déjà corrigé dans le commit `5d21696` - ces options sont maintenant à `false`

### Erreur : "Invalid API key"

**Cause** : Variable d'environnement `.env.local` manquante ou invalide

**Solution** :
```bash
cd /home/serge/Téléchargements/dohgahnew/webandoh
echo 'VITE_SUPABASE_ANON_KEY=sb_publishable_8JE4raZ0xYRgi4knQnFnbQ_YAbY9NEU' >> .env.local
```

### Déploiement bloqué sur commit ancien

**Cause** : Le sous-module webandoh n'est pas configuré comme un vrai submodule git

**Solution** : Déployer manuellement depuis le parent avec `vercel --prod`

---

## ✅ CHECKLIST AVANT DÉPLOIEMENT

- [ ] Je suis dans le dossier `/home/serge/Téléchargements/dohgahnew` (PARENT)
- [ ] Les modifications sont commitées dans `webandoh/`
- [ ] Les variables d'environnement Vercel sont configurées
- [ ] Je lance `vercel --prod --yes`

---

## 📌 MÉMO VISUEL

```
❌ MAUVAIS (Ne marche pas) :
cd /home/serge/Téléchargements/dohgahnew/webandoh
vercel --prod
→ Erreur: webandoh/webandoh does not exist

✅ BON (Fonctionne) :
cd /home/serge/Téléchargements/dohgahnew
vercel --prod
→ Succès: Build + Deploy
```

---

**Dernière mise à jour** : 2026-07-09 06:10  
**Testé et validé** : ✅ OUI  
**Ne jamais supprimer ce fichier**
