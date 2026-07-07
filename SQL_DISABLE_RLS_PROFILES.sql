-- ============================================================================
-- DÉSACTIVER RLS SUR PROFILES (TEMPORAIRE POUR DEBUG)
-- ============================================================================

-- Option 1 : Désactiver complètement RLS (le plus simple)
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;

-- Vérifier l'état
SELECT tablename, rowsecurity
FROM pg_tables
WHERE tablename = 'profiles';

-- ============================================================================
-- SI LE PROBLÈME PERSISTE, VÉRIFIER LES DONNÉES
-- ============================================================================

-- Compter les utilisateurs dans auth.users
SELECT COUNT(*) as total_auth_users FROM auth.users;

-- Compter les profils dans profiles
SELECT COUNT(*) as total_profiles FROM public.profiles;

-- Lister tous les profils avec leurs rôles
SELECT id, email, first_name, last_name, role, created_at
FROM public.profiles
ORDER BY created_at DESC;

-- Vérifier s'il y a des utilisateurs sans profil
SELECT u.id, u.email, u.created_at
FROM auth.users u
LEFT JOIN public.profiles p ON u.id = p.id
WHERE p.id IS NULL;
