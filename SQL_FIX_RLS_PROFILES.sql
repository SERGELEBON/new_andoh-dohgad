-- ============================================================================
-- FIX RLS POLICIES - L'ADMIN DOIT VOIR TOUS LES UTILISATEURS
-- ============================================================================

-- Supprimer les anciennes policies
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
DROP POLICY IF EXISTS "Admins can view all profiles" ON public.profiles;

-- Nouvelle policy : Tout le monde peut voir son propre profil
CREATE POLICY "Users can view own profile"
    ON public.profiles FOR SELECT
    USING (auth.uid() = id);

-- Nouvelle policy : Les admins peuvent tout voir
CREATE POLICY "Admins can view all profiles"
    ON public.profiles FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Nouvelle policy : Les utilisateurs peuvent modifier leur propre profil
CREATE POLICY "Users can update own profile"
    ON public.profiles FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- Nouvelle policy : Les admins peuvent tout modifier
CREATE POLICY "Admins can manage all profiles"
    ON public.profiles FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Vérifier les policies
SELECT schemaname, tablename, policyname, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'profiles';
