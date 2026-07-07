-- ============================================================================
-- METTRE À JOUR LE RÔLE DU COMPTE ADMIN
-- ============================================================================

-- Vérifier le rôle actuel
SELECT id, email, first_name, last_name, role
FROM profiles
WHERE email = 'contact@andoh-dohgad.com';

-- Mettre à jour le rôle en admin
UPDATE profiles
SET role = 'admin'::user_role,
    first_name = 'Admin',
    last_name = 'Andoh & Dohgad',
    updated_at = now()
WHERE email = 'contact@andoh-dohgad.com';

-- Vérifier que la mise à jour a fonctionné
SELECT id, email, first_name, last_name, role
FROM profiles
WHERE email = 'contact@andoh-dohgad.com';

-- ✅ Le résultat doit afficher : role = 'admin'
