# 📚 Configuration du Système de Documentation

## ⚠️ Étapes Obligatoires

Le système de documentation nécessite l'exécution d'une migration SQL dans Supabase.

---

## 🔧 Étape 1 : Créer les Tables Documentation (5 min)

### URL à ouvrir :
https://supabase.com/dashboard/project/tszsvbzfufglvdcsjzpo/sql/new

### Instructions :

1. **Ouvrir le SQL Editor** dans le lien ci-dessus
2. **Copier tout le contenu** du fichier `supabase-migration-documentation.sql`
3. **Coller dans l'éditeur SQL**
4. **Cliquer sur "Run"** (ou appuyer sur Ctrl+Enter)

### ✅ Résultat attendu :

Vous devriez voir :
```
Success. No rows returned
```

Cela crée :
- ✅ Type `document_type` (guides, fiscaux, modeles, notes)
- ✅ Table `documentation` avec colonnes (type, price, file_url, status, etc.)
- ✅ Table `documentation_translations` pour FR/EN/ES
- ✅ Indexes de performance
- ✅ RLS Policies (sécurité)
- ✅ Bucket Storage `documentation`

---

## 🧪 Étape 2 : Vérifier l'Installation

### Vérifier les tables :

1. Aller sur : https://supabase.com/dashboard/project/tszsvbzfufglvdcsjzpo/editor
2. Dans la sidebar gauche, vous devriez voir :
   - ✅ `documentation`
   - ✅ `documentation_translations`

### Vérifier le bucket :

1. Aller sur : https://supabase.com/dashboard/project/tszsvbzfufglvdcsjzpo/storage/buckets
2. Vous devriez voir le bucket `documentation` (public)

---

## 🎯 Étape 3 : Tester l'Interface Admin

### Accéder à l'interface :

1. Se connecter : https://new-andoh-dohgad.vercel.app/connexion
   - Email : `contact@andoh-dohgad.com`
   - Password : `Admin@2026!`

2. Aller sur : https://new-andoh-dohgad.vercel.app/admin/documentation

### Tester la création :

#### Option A : Créer avec éditeur de texte
1. Cliquer sur **"Créer avec éditeur"**
2. Remplir les champs (au minimum Titre FR)
3. Écrire du contenu dans l'éditeur
4. Sélectionner le type de document
5. Définir un prix (optionnel, défaut 0 XOF)
6. Cliquer **"Publier"** ou **"Enregistrer brouillon"**

#### Option B : Upload de fichier
1. Cliquer sur **"Télécharger un fichier"**
2. Remplir les champs (au minimum Titre FR)
3. Uploader un fichier PDF/DOC
4. Sélectionner le type de document
5. Définir un prix
6. Cliquer **"Publier"** ou **"Enregistrer brouillon"**

---

## 🐛 Dépannage

### Erreur : "Could not find a relationship between 'documentation' and 'documentation_translations'"

**Cause** : Les tables n'existent pas encore dans Supabase

**Solution** : Exécuter la migration SQL (Étape 1 ci-dessus)

---

### Erreur : "new row violates row-level security policy"

**Cause** : L'utilisateur n'a pas le rôle `admin`

**Solution** : Vérifier que le compte a bien le rôle admin :

```sql
-- Vérifier le rôle
SELECT email, role FROM profiles WHERE email = 'contact@andoh-dohgad.com';

-- Si nécessaire, mettre à jour
UPDATE profiles SET role = 'admin' WHERE email = 'contact@andoh-dohgad.com';
```

---

### Erreur lors de l'upload : "new row violates check constraint"

**Cause** : Le bucket `documentation` n'existe pas

**Solution** : Exécuter la partie Storage de la migration SQL (incluse dans `supabase-migration-documentation.sql`)

---

## 📊 Structure de Données

### Table `documentation`
| Colonne | Type | Description |
|---------|------|-------------|
| id | UUID | Identifiant unique |
| type | document_type | guides, fiscaux, modeles, notes |
| price | DECIMAL | Prix en XOF |
| file_url | TEXT | URL du fichier dans Storage |
| file_size | BIGINT | Taille du fichier en bytes |
| download_count | INTEGER | Nombre de téléchargements |
| status | content_status | draft, active, archived |
| created_at | TIMESTAMP | Date de création |
| updated_at | TIMESTAMP | Date de modification |

### Table `documentation_translations`
| Colonne | Type | Description |
|---------|------|-------------|
| id | UUID | Identifiant unique |
| doc_id | UUID | Référence à documentation |
| language | TEXT | fr, en, ou es |
| title | TEXT | Titre du document |
| description | TEXT | Description |

---

## ✅ Checklist Complète

- [ ] Migration SQL exécutée
- [ ] Tables `documentation` et `documentation_translations` visibles dans Supabase
- [ ] Bucket `documentation` créé dans Storage
- [ ] Compte admin configuré avec rôle 'admin'
- [ ] Accès à `/admin/documentation` sans erreur
- [ ] Test création d'un document avec upload
- [ ] Test création d'un document avec éditeur
- [ ] Toggle brouillon/publié fonctionne
- [ ] Suppression d'un document fonctionne

---

## 🚀 Après Installation

Le système est prêt quand :
- ✅ Page `/admin/documentation` charge sans erreur
- ✅ Les statistiques affichent "0" pour chaque type
- ✅ Les deux boutons de création sont visibles
- ✅ Un document peut être créé et affiché dans la liste