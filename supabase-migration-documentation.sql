-- ========================================
-- MIGRATION: Documentation System
-- Date: 2026-07-09
-- Description: Tables et buckets pour le système de gestion de documentation
-- ========================================

-- Create enum for document types
DO $$ BEGIN
    CREATE TYPE document_type AS ENUM ('guides', 'fiscaux', 'modeles', 'notes');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Create documentation table
CREATE TABLE IF NOT EXISTS documentation (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type document_type NOT NULL,
    price DECIMAL(10, 2) DEFAULT 0,
    file_url TEXT NOT NULL,
    file_size BIGINT DEFAULT 0,
    download_count INTEGER DEFAULT 0,
    status content_status DEFAULT 'draft',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create documentation_translations table
CREATE TABLE IF NOT EXISTS documentation_translations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    doc_id UUID NOT NULL REFERENCES documentation(id) ON DELETE CASCADE,
    language TEXT NOT NULL CHECK (language IN ('fr', 'en', 'es')),
    title TEXT NOT NULL,
    description TEXT,
    UNIQUE(doc_id, language)
);

-- Create indexes for documentation
CREATE INDEX IF NOT EXISTS idx_documentation_type ON documentation(type);
CREATE INDEX IF NOT EXISTS idx_documentation_status ON documentation(status);
CREATE INDEX IF NOT EXISTS idx_documentation_translations_doc_id ON documentation_translations(doc_id);
CREATE INDEX IF NOT EXISTS idx_documentation_translations_language ON documentation_translations(language);

-- Enable RLS for documentation
ALTER TABLE documentation ENABLE ROW LEVEL SECURITY;
ALTER TABLE documentation_translations ENABLE ROW LEVEL SECURITY;

-- Drop existing policies for documentation
DROP POLICY IF EXISTS "Anyone can view active documentation" ON documentation;
DROP POLICY IF EXISTS "Admins can manage all documentation" ON documentation;
DROP POLICY IF EXISTS "Anyone can view active documentation translations" ON documentation_translations;
DROP POLICY IF EXISTS "Admins can manage all documentation translations" ON documentation_translations;

-- RLS Policies for documentation
CREATE POLICY "Anyone can view active documentation"
    ON documentation FOR SELECT
    USING (status = 'active');

CREATE POLICY "Admins can manage all documentation"
    ON documentation FOR ALL
    USING (EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

-- RLS Policies for documentation_translations
CREATE POLICY "Anyone can view active documentation translations"
    ON documentation_translations FOR SELECT
    USING (EXISTS (
        SELECT 1 FROM documentation
        WHERE id = doc_id AND status = 'active'
    ));

CREATE POLICY "Admins can manage all documentation translations"
    ON documentation_translations FOR ALL
    USING (EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

-- ========================================
-- STORAGE BUCKET: documentation
-- ========================================

-- Créer le bucket pour la documentation
INSERT INTO storage.buckets (id, name, public)
VALUES ('documentation', 'documentation', true)
ON CONFLICT (id) DO NOTHING;

-- Supprimer les anciennes policies si elles existent
DROP POLICY IF EXISTS "Public can view documentation files" ON storage.objects;
DROP POLICY IF EXISTS "Admins can upload documentation files" ON storage.objects;
DROP POLICY IF EXISTS "Admins can delete documentation files" ON storage.objects;

-- Policy : Tout le monde peut voir les fichiers
CREATE POLICY "Public can view documentation files"
ON storage.objects FOR SELECT
USING (bucket_id = 'documentation');

-- Policy : Les admins peuvent uploader des fichiers
CREATE POLICY "Admins can upload documentation files"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'documentation' AND
    EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = auth.uid() AND role = 'admin'
    )
);

-- Policy : Les admins peuvent supprimer des fichiers
CREATE POLICY "Admins can delete documentation files"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'documentation' AND
    EXISTS (
        SELECT 1 FROM public.profiles
        WHERE id = auth.uid() AND role = 'admin'
    )
);
