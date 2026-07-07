-- ============================================================================
-- TABLES POUR FRONTEND DYNAMIQUE
-- ============================================================================

-- Table Services
CREATE TABLE public.services (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug TEXT NOT NULL UNIQUE,
    title_fr TEXT NOT NULL,
    title_en TEXT,
    title_es TEXT,
    short_description_fr TEXT NOT NULL,
    short_description_en TEXT,
    short_description_es TEXT,
    long_description_fr TEXT NOT NULL,
    long_description_en TEXT,
    long_description_es TEXT,
    icon TEXT NOT NULL,
    features JSONB DEFAULT '[]',
    image_url TEXT,
    active BOOLEAN DEFAULT true,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_services_slug ON public.services(slug);
CREATE INDEX idx_services_active ON public.services(active);

-- Table Solutions
CREATE TABLE public.solutions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug TEXT NOT NULL UNIQUE,
    title_fr TEXT NOT NULL,
    title_en TEXT,
    title_es TEXT,
    description_fr TEXT NOT NULL,
    description_en TEXT,
    description_es TEXT,
    icon TEXT NOT NULL,
    features JSONB DEFAULT '[]',
    image_url TEXT,
    active BOOLEAN DEFAULT true,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_solutions_slug ON public.solutions(slug);

-- Table Team Members
CREATE TABLE public.team_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    role_fr TEXT NOT NULL,
    role_en TEXT,
    role_es TEXT,
    bio_fr TEXT,
    bio_en TEXT,
    bio_es TEXT,
    image_url TEXT,
    linkedin_url TEXT,
    email TEXT,
    active BOOLEAN DEFAULT true,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table Testimonials
CREATE TABLE public.testimonials (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    author_name TEXT NOT NULL,
    author_role TEXT NOT NULL,
    author_company TEXT,
    author_image TEXT,
    content_fr TEXT NOT NULL,
    content_en TEXT,
    content_es TEXT,
    rating INTEGER DEFAULT 5 CHECK (rating >= 1 AND rating <= 5),
    active BOOLEAN DEFAULT true,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table Documentation
CREATE TABLE public.documentation (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title_fr TEXT NOT NULL,
    title_en TEXT,
    title_es TEXT,
    description_fr TEXT NOT NULL,
    description_en TEXT,
    description_es TEXT,
    category TEXT NOT NULL,
    file_url TEXT NOT NULL,
    file_size TEXT,
    pages INTEGER,
    price DECIMAL(10, 2) DEFAULT 0,
    preview_url TEXT,
    cover_image TEXT,
    active BOOLEAN DEFAULT true,
    downloads_count INTEGER DEFAULT 0,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_documentation_category ON public.documentation(category);
CREATE INDEX idx_documentation_active ON public.documentation(active);

-- Table Stats (pour les chiffres clés)
CREATE TABLE public.site_stats (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    key TEXT NOT NULL UNIQUE,
    value_number INTEGER,
    value_text TEXT,
    label_fr TEXT NOT NULL,
    label_en TEXT,
    label_es TEXT,
    icon TEXT,
    active BOOLEAN DEFAULT true,
    display_order INTEGER DEFAULT 0,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table Partners (logos partenaires)
CREATE TABLE public.partners (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    logo_url TEXT NOT NULL,
    website_url TEXT,
    active BOOLEAN DEFAULT true,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table FAQ
CREATE TABLE public.faq (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_fr TEXT NOT NULL,
    question_en TEXT,
    question_es TEXT,
    answer_fr TEXT NOT NULL,
    answer_en TEXT,
    answer_es TEXT,
    category TEXT,
    active BOOLEAN DEFAULT true,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS on all tables
ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.solutions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.team_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.testimonials ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.documentation ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.site_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.partners ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.faq ENABLE ROW LEVEL SECURITY;

-- Policies: Everyone can read, only admins can write
CREATE POLICY "Anyone can view active services"
    ON public.services FOR SELECT
    USING (active = true);

CREATE POLICY "Admins can manage services"
    ON public.services FOR ALL
    USING (EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

CREATE POLICY "Anyone can view active solutions"
    ON public.solutions FOR SELECT
    USING (active = true);

CREATE POLICY "Admins can manage solutions"
    ON public.solutions FOR ALL
    USING (EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

CREATE POLICY "Anyone can view active team members"
    ON public.team_members FOR SELECT
    USING (active = true);

CREATE POLICY "Admins can manage team members"
    ON public.team_members FOR ALL
    USING (EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

CREATE POLICY "Anyone can view active testimonials"
    ON public.testimonials FOR SELECT
    USING (active = true);

CREATE POLICY "Admins can manage testimonials"
    ON public.testimonials FOR ALL
    USING (EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

CREATE POLICY "Anyone can view active documentation"
    ON public.documentation FOR SELECT
    USING (active = true);

CREATE POLICY "Admins can manage documentation"
    ON public.documentation FOR ALL
    USING (EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

CREATE POLICY "Anyone can view active stats"
    ON public.site_stats FOR SELECT
    USING (active = true);

CREATE POLICY "Admins can manage stats"
    ON public.site_stats FOR ALL
    USING (EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

CREATE POLICY "Anyone can view active partners"
    ON public.partners FOR SELECT
    USING (active = true);

CREATE POLICY "Admins can manage partners"
    ON public.partners FOR ALL
    USING (EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

CREATE POLICY "Anyone can view active faq"
    ON public.faq FOR SELECT
    USING (active = true);

CREATE POLICY "Admins can manage faq"
    ON public.faq FOR ALL
    USING (EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

-- Trigger pour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON public.services FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_solutions_updated_at BEFORE UPDATE ON public.solutions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_team_members_updated_at BEFORE UPDATE ON public.team_members FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_testimonials_updated_at BEFORE UPDATE ON public.testimonials FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_documentation_updated_at BEFORE UPDATE ON public.documentation FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();


-- ============================================================================
-- INSERTION DES DONNÉES INITIALES
-- ============================================================================

-- Services initiaux
INSERT INTO public.services (slug, title_fr, short_description_fr, long_description_fr, icon, features, active, display_order) VALUES
('consulting-strategique', 'Consulting Stratégique', 'Accompagnement dans la définition et mise en œuvre de votre stratégie d''entreprise', 'Notre expertise en consulting stratégique vous aide à définir une vision claire et à mettre en place les actions nécessaires pour atteindre vos objectifs.', 'briefcase', '["Analyse de marché", "Définition de stratégie", "Plan d''action détaillé", "Suivi et accompagnement"]', true, 1),
('digital-transformation', 'Transformation Digitale', 'Modernisez votre entreprise avec nos solutions digitales', 'Accompagnement complet dans votre transformation digitale pour optimiser vos processus et améliorer votre compétitivité.', 'laptop', '["Audit digital", "Choix des technologies", "Formation équipes", "Mise en production"]', true, 2),
('business-intelligence', 'Business Intelligence', 'Exploitez vos données pour prendre de meilleures décisions', 'Solutions d''analyse et de visualisation de données pour transformer vos informations en insights actionnables.', 'chart-bar', '["Tableaux de bord", "Analyse prédictive", "Reporting automatisé", "KPIs personnalisés"]', true, 3),
('formation-professionnelle', 'Formation Professionnelle', 'Développez les compétences de vos équipes', 'Programmes de formation sur mesure pour renforcer les capacités de votre organisation.', 'users', '["Formations sur mesure", "Certifications", "E-learning", "Coaching individuel"]', true, 4);

-- Stats initiales
INSERT INTO public.site_stats (key, value_number, label_fr, label_en, label_es, icon, active, display_order) VALUES
('clients', 250, 'Clients satisfaits', 'Satisfied clients', 'Clientes satisfechos', 'users', true, 1),
('projects', 500, 'Projets réalisés', 'Completed projects', 'Proyectos completados', 'briefcase', true, 2),
('experience', 15, 'Années d''expérience', 'Years of experience', 'Años de experiencia', 'award', true, 3),
('success', 98, 'Taux de réussite', 'Success rate', 'Tasa de éxito', 'chart-line', true, 4);

COMMENT ON TABLE public.services IS 'Services offerts par l''entreprise';
COMMENT ON TABLE public.solutions IS 'Solutions digitales proposées';
COMMENT ON TABLE public.team_members IS 'Membres de l''équipe';
COMMENT ON TABLE public.testimonials IS 'Témoignages clients';
COMMENT ON TABLE public.documentation IS 'Documents téléchargeables';
COMMENT ON TABLE public.site_stats IS 'Statistiques du site (chiffres clés)';
COMMENT ON TABLE public.partners IS 'Logos des partenaires';
COMMENT ON TABLE public.faq IS 'Questions fréquemment posées';
