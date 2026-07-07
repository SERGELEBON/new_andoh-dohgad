# 🔧 CRÉER LE COMPTE ADMIN - PROCÉDURE EXACTE

## Erreur actuelle
```
Invalid login credentials
```

**Cause** : Le compte `contact@andoh-dohgad.com` n'existe pas encore dans Supabase.

## Solution (5 minutes)

### ÉTAPE 1 : Créer l'utilisateur dans Supabase

1. **Ouvrir** : https://supabase.com/dashboard/project/tszsvbzfufglvdcsjzpo/auth/users

2. **Cliquer** sur le bouton **"Add user"** (en haut à droite)

3. **Sélectionner** : **"Create new user"**

4. **Remplir le formulaire** :
   ```
   Email address: contact@andoh-dohgad.com
   Password: Admin@2026!
   Auto Confirm User: ✓ (COCHER CETTE CASE)
   ```

5. **Cliquer** : **"Create user"**

6. ✅ **Résultat** : L'utilisateur apparaît dans la liste

### ÉTAPE 2 : Créer le profil admin

1. **Ouvrir** : https://supabase.com/dashboard/project/tszsvbzfufglvdcsjzpo/sql/new

2. **Coller ce SQL** :
```sql
-- Vérifier d'abord si l'utilisateur existe
SELECT id, email FROM auth.users WHERE email = 'contact@andoh-dohgad.com';

-- Si un ID est retourné, créer/mettre à jour le profil
INSERT INTO profiles (
    id,
    email,
    first_name,
    last_name,
    role,
    created_at,
    updated_at
)
SELECT 
    id,
    email,
    'Admin',
    'Andoh & Dohgad',
    'admin'::user_role,
    now(),
    now()
FROM auth.users
WHERE email = 'contact@andoh-dohgad.com'
ON CONFLICT (id) DO UPDATE
SET 
    role = 'admin'::user_role,
    first_name = 'Admin',
    last_name = 'Andoh & Dohgad',
    updated_at = now();

-- Vérifier que le profil est créé
SELECT id, email, first_name, last_name, role FROM profiles 
WHERE email = 'contact@andoh-dohgad.com';
```

3. **Cliquer** : **"Run"** (ou Ctrl+Enter)

4. ✅ **Résultat attendu** : 
   ```
   Success. 1 row(s) affected.
   
   Et en bas :
   id | email | first_name | last_name | role
   [uuid] | contact@andoh-dohgad.com | Admin | Andoh & Dohgad | admin
   ```

### ÉTAPE 3 : Se connecter

1. **Retourner sur** : http://localhost:3000/connexion

2. **Entrer les credentials** :
   ```
   Email : contact@andoh-dohgad.com
   Password : Admin@2026!
   ```

3. **Cliquer** : **"Se connecter"**

4. ✅ **Succès** : Redirection vers `/mon-compte`

5. **Vérifier** : Le bouton **"👑 Admin"** est visible dans le header

6. **Cliquer** sur le bouton **"👑 Admin"**

7. ✅ **Accès** au dashboard admin avec sidebar

## Vérifications

### Si l'erreur persiste

**Test 1** : Vérifier que l'utilisateur existe
```sql
SELECT id, email, email_confirmed_at, created_at 
FROM auth.users 
WHERE email = 'contact@andoh-dohgad.com';
```

**Attendu** : 1 ligne avec `email_confirmed_at` non null

**Test 2** : Vérifier que le profil existe
```sql
SELECT id, email, role, first_name, last_name
FROM profiles
WHERE email = 'contact@andoh-dohgad.com';
```

**Attendu** : 1 ligne avec `role = 'admin'`

### Si "Auto Confirm" n'était pas coché

L'utilisateur doit confirmer son email. Pour le faire manuellement :

```sql
UPDATE auth.users 
SET email_confirmed_at = now() 
WHERE email = 'contact@andoh-dohgad.com';
```

## Troubleshooting

### Erreur : "User already registered"
→ Le compte existe déjà, passer directement à l'ÉTAPE 2

### Erreur : "relation profiles does not exist"
→ La table profiles n'existe pas, exécuter d'abord :
```bash
# Exécuter la migration
cat /home/serge/Téléchargements/dohgahnew/supabase/migrations/20260706000001_create_profiles.sql
```
Puis copier/coller le contenu dans SQL Editor et exécuter

### Mot de passe oublié
Si vous avez utilisé un autre mot de passe, réinitialiser :
1. Dans Supabase Dashboard > Authentication > Users
2. Trouver contact@andoh-dohgad.com
3. Cliquer sur les 3 points > "Reset password"
4. Ou supprimer l'utilisateur et le recréer

## Résumé

✅ **ÉTAPE 1** : Créer user dans Auth (avec Auto Confirm)  
✅ **ÉTAPE 2** : Créer profil admin via SQL  
✅ **ÉTAPE 3** : Se connecter sur le site  
✅ **RÉSULTAT** : Accès au dashboard admin

---

**Credentials finaux** :
```
Email    : contact@andoh-dohgad.com
Password : Admin@2026!
```
