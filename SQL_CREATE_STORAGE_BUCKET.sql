-- ============================================================================
-- CRÉER BUCKET STORAGE POUR LES IMAGES
-- ============================================================================

-- Créer le bucket pour les images du blog
INSERT INTO storage.buckets (id, name, public)
VALUES ('blog-images', 'blog-images', true)
ON CONFLICT (id) DO NOTHING;

-- Policy : Tout le monde peut voir les images
CREATE POLICY "Public can view blog images"
ON storage.objects FOR SELECT
USING (bucket_id = 'blog-images');

-- Policy : Les admins peuvent uploader des images
CREATE POLICY "Admins can upload blog images"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'blog-images' AND
    EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = auth.uid() AND role = 'admin'
    )
);

-- Policy : Les admins peuvent supprimer des images
CREATE POLICY "Admins can delete blog images"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'blog-images' AND
    EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = auth.uid() AND role = 'admin'
    )
);

-- Créer aussi un bucket pour les autres images du site
INSERT INTO storage.buckets (id, name, public)
VALUES ('site-images', 'site-images', true)
ON CONFLICT (id) DO NOTHING;

-- Policy : Tout le monde peut voir les images du site
CREATE POLICY "Public can view site images"
ON storage.objects FOR SELECT
USING (bucket_id = 'site-images');

-- Policy : Les admins peuvent gérer les images du site
CREATE POLICY "Admins can upload site images"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'site-images' AND
    EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = auth.uid() AND role = 'admin'
    )
);

CREATE POLICY "Admins can delete site images"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'site-images' AND
    EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = auth.uid() AND role = 'admin'
    )
);
