# 🔐 CREDENTIALS ADMINISTRATEUR

## Compte Super Admin

**Email** : `contact@andoh-dohgad.com`  
**Mot de passe** : `Admin@2026!`

## Création du compte

### Étape 1 : Créer l'utilisateur dans Supabase

1. Aller sur : https://supabase.com/dashboard/project/tszsvbzfufglvdcsjzpo/auth/users
2. Cliquer **"Add user"** > **"Create new user"**
3. Remplir :
   - Email : `contact@andoh-dohgad.com`
   - Password : `Admin@2026!`
   - ✅ Cocher **"Auto Confirm User"**
4. Cliquer **"Create user"**

### Étape 2 : Définir le rôle admin

1. Aller sur : https://supabase.com/dashboard/project/tszsvbzfufglvdcsjzpo/sql/new
2. Exécuter ce SQL :

```sql
UPDATE profiles 
SET role = 'admin',
    first_name = 'Admin',
    last_name = 'Andoh & Dohgad',
    updated_at = now()
WHERE email = 'contact@andoh-dohgad.com';
```

### Étape 3 : Se connecter

1. Aller sur : http://localhost:3000/connexion
2. Se connecter avec les credentials ci-dessus
3. Accéder au dashboard : http://localhost:3000/admin

## Structure du Dashboard Admin

### Sidebar Menu (à gauche)
- 📊 Dashboard - Vue d'ensemble
- 📝 Blog - Gestion articles (CRUD complet)
- 👥 Utilisateurs - Gestion comptes
- 📅 Rendez-vous - Gestion RDV
- 💬 Messages - Gestion messages
- 🏢 Co-working - Gestion espaces
- 📄 Documentation - Gestion docs
- ⚙️ Paramètres - Configuration

### Fonctionnalités Blog
- ✅ Liste tous les articles
- ✅ Recherche
- ✅ Publier/Dépublier
- ✅ Éditer
- ✅ Supprimer
- ✅ Voir
- ⏳ Créer (à implémenter)

## Sécurité

✅ **Accès protégé** : Seul le rôle `admin` peut accéder  
✅ **Routes sécurisées** : Vérification via `ProtectedRoute`  
✅ **Pas de footer** dans le dashboard  
✅ **Sidebar professionnelle** avec navigation claire

## Notes importantes

⚠️ Ne JAMAIS committer ce fichier avec le mot de passe réel  
⚠️ Changer le mot de passe après le premier login  
⚠️ Le compte admin a tous les droits CRUD sur toutes les entités

---

**Date de création** : 6 juillet 2026  
**Version** : 1.0
