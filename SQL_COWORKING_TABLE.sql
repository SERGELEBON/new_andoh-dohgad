-- ========================================
-- TABLE: coworking_subscriptions
-- Description: Abonnements co-working
-- ========================================

-- Create enum for plan types
DO $$ BEGIN
    CREATE TYPE coworking_plan AS ENUM ('daily', 'weekly', 'monthly');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Create enum for payment status
DO $$ BEGIN
    CREATE TYPE payment_status AS ENUM ('pending', 'completed', 'failed');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Create coworking_subscriptions table
CREATE TABLE IF NOT EXISTS coworking_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
    plan_type coworking_plan NOT NULL,
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE NOT NULL,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'expired', 'cancelled')),
    amount_paid DECIMAL(10, 2) DEFAULT 0,
    payment_status payment_status DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_coworking_user_id ON coworking_subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_coworking_status ON coworking_subscriptions(status);
CREATE INDEX IF NOT EXISTS idx_coworking_dates ON coworking_subscriptions(start_date, end_date);

-- Enable RLS
ALTER TABLE coworking_subscriptions ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own subscriptions" ON coworking_subscriptions;
DROP POLICY IF EXISTS "Users can create own subscriptions" ON coworking_subscriptions;
DROP POLICY IF EXISTS "Admins can manage all subscriptions" ON coworking_subscriptions;

-- RLS Policies
CREATE POLICY "Users can view own subscriptions"
    ON coworking_subscriptions FOR SELECT
    USING (user_id = auth.uid() OR EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

CREATE POLICY "Users can create own subscriptions"
    ON coworking_subscriptions FOR INSERT
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "Admins can manage all subscriptions"
    ON coworking_subscriptions FOR ALL
    USING (EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

-- ========================================
-- TABLE: contact_messages
-- Description: Messages de contact
-- ========================================

CREATE TABLE IF NOT EXISTS contact_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    subject TEXT,
    message TEXT NOT NULL,
    status TEXT DEFAULT 'new' CHECK (status IN ('new', 'read', 'replied', 'archived')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index
CREATE INDEX IF NOT EXISTS idx_contact_messages_status ON contact_messages(status);
CREATE INDEX IF NOT EXISTS idx_contact_messages_created ON contact_messages(created_at DESC);

-- Enable RLS
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Admins can manage all messages" ON contact_messages;

-- RLS Policy
CREATE POLICY "Admins can manage all messages"
    ON contact_messages FOR ALL
    USING (EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

-- ========================================
-- TABLE: appointments
-- Description: Rendez-vous
-- ========================================

CREATE TABLE IF NOT EXISTS appointments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    service TEXT NOT NULL,
    preferred_date TIMESTAMP WITH TIME ZONE NOT NULL,
    message TEXT,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled', 'completed')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_appointments_user_id ON appointments(user_id);
CREATE INDEX IF NOT EXISTS idx_appointments_status ON appointments(status);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON appointments(preferred_date);

-- Enable RLS
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own appointments" ON appointments;
DROP POLICY IF EXISTS "Users can create appointments" ON appointments;
DROP POLICY IF EXISTS "Admins can manage all appointments" ON appointments;

-- RLS Policies
CREATE POLICY "Users can view own appointments"
    ON appointments FOR SELECT
    USING (user_id = auth.uid() OR EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

CREATE POLICY "Users can create appointments"
    ON appointments FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Admins can manage all appointments"
    ON appointments FOR ALL
    USING (EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

-- ========================================
-- TABLE: surveys
-- Description: Sondages
-- ========================================

CREATE TABLE IF NOT EXISTS surveys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    survey_type TEXT NOT NULL,
    data JSONB NOT NULL,
    status TEXT DEFAULT 'new' CHECK (status IN ('new', 'reviewed', 'archived')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_surveys_user_id ON surveys(user_id);
CREATE INDEX IF NOT EXISTS idx_surveys_type ON surveys(survey_type);
CREATE INDEX IF NOT EXISTS idx_surveys_status ON surveys(status);

-- Enable RLS
ALTER TABLE surveys ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own surveys" ON surveys;
DROP POLICY IF EXISTS "Users can create surveys" ON surveys;
DROP POLICY IF EXISTS "Admins can manage all surveys" ON surveys;

-- RLS Policies
CREATE POLICY "Users can view own surveys"
    ON surveys FOR SELECT
    USING (user_id = auth.uid() OR EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

CREATE POLICY "Users can create surveys"
    ON surveys FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Admins can manage all surveys"
    ON surveys FOR ALL
    USING (EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

-- ========================================
-- TABLE: documentation_purchases
-- Description: Achats de documentation
-- ========================================

CREATE TABLE IF NOT EXISTS documentation_purchases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    doc_id UUID REFERENCES documentation(id) ON DELETE CASCADE,
    amount_paid DECIMAL(10, 2) NOT NULL,
    payment_status payment_status DEFAULT 'pending',
    payment_method TEXT,
    transaction_id TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_doc_purchases_user_id ON documentation_purchases(user_id);
CREATE INDEX IF NOT EXISTS idx_doc_purchases_doc_id ON documentation_purchases(doc_id);
CREATE INDEX IF NOT EXISTS idx_doc_purchases_status ON documentation_purchases(payment_status);

-- Enable RLS
ALTER TABLE documentation_purchases ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "Users can view own purchases" ON documentation_purchases;
DROP POLICY IF EXISTS "Users can create purchases" ON documentation_purchases;
DROP POLICY IF EXISTS "Admins can manage all purchases" ON documentation_purchases;

-- RLS Policies
CREATE POLICY "Users can view own purchases"
    ON documentation_purchases FOR SELECT
    USING (user_id = auth.uid() OR EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));

CREATE POLICY "Users can create purchases"
    ON documentation_purchases FOR INSERT
    WITH CHECK (user_id = auth.uid());

CREATE POLICY "Admins can manage all purchases"
    ON documentation_purchases FOR ALL
    USING (EXISTS (
        SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'
    ));