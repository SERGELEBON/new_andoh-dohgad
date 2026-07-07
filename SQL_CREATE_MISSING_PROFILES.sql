-- ============================================================================
-- CRÉER LES PROFILS MANQUANTS POUR LES UTILISATEURS SANS PROFIL
-- ============================================================================

-- Créer les profils pour les utilisateurs qui n'en ont pas
INSERT INTO public.profiles (id, email, first_name, last_name, role, created_at, updated_at)
SELECT
    u.id,
    u.email,
    COALESCE(u.raw_user_meta_data->>'first_name', split_part(u.email, '@', 1)) as first_name,
    COALESCE(u.raw_user_meta_data->>'last_name', '') as last_name,
    COALESCE((u.raw_user_meta_data->>'role')::user_role, 'visitor'::user_role) as role,
    u.created_at,
    now() as updated_at
FROM auth.users u
LEFT JOIN public.profiles p ON u.id = p.id
WHERE p.id IS NULL;

-- Vérifier combien de profils ont été créés
SELECT COUNT(*) as profiles_created FROM public.profiles;

-- Lister tous les profils
SELECT id, email, first_name, last_name, role, created_at
FROM public.profiles
ORDER BY created_at DESC;

-- Vérifier qu'il n'y a plus d'utilisateurs sans profil
SELECT u.id, u.email, u.created_at
FROM auth.users u
LEFT JOIN public.profiles p ON u.id = p.id
WHERE p.id IS NULL;
