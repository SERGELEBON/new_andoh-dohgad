# 🚀 BACKEND ANDOH & DOHGAD CONSULTING - DOCUMENTATION COMPLÈTE

## 📋 VUE D'ENSEMBLE

Ce backend complet utilise **Supabase (PostgreSQL)** comme base de données avec authentification intégrée, **Stripe** pour les paiements par carte, **Orange Money** et **MTN Mobile Money** pour les paiements mobile.

### Technologies utilisées
- **Supabase** : Base de données PostgreSQL + Auth + Storage + Edge Functions
- **Stripe** : Paiements par carte bancaire
- **Orange Money API** : Paiements mobile (Côte d'Ivoire)
- **MTN Mobile Money API** : Paiements mobile (Côte d'Ivoire)
- **EmailJS** : Envoi d'emails (conservé comme demandé)
- **React 19 + TypeScript** : Frontend
- **Row Level Security (RLS)** : Sécurité au niveau des données

---

## 🗄️ STRUCTURE DE LA BASE DE DONNÉES

### Tables principales

1. **profiles** - Profils utilisateurs avec rôles
2. **services** + **service_translations** - Services multilingues (FR/EN/ES)
3. **blog_posts** + **blog_post_translations** - Articles de blog (Markdown)
4. **documentation** + **documentation_translations** - Documents payants
5. **documentation_purchases** - Historique d'achats
6. **appointments** - Rendez-vous clients
7. **coworking_spaces** - Espaces de coworking
8. **coworking_subscriptions** - Abonnements coworking
9. **coworking_bookings** - Réservations d'espaces
10. **surveys** - Réponses aux sondages
11. **contact_messages** - Messages de contact
12. **solutions** + **solution_translations** - Solutions numériques
13. **audit_logs** - Logs d'audit

### Rôles utilisateurs

| Rôle | Description | Permissions |
|------|-------------|-------------|
| `admin` | Administrateur | Accès total, gestion CMS, approbations |
| `coworking_client` | Client co-working | Réservations, accès espace co-working |
| `standard_client` | Client standard | Achats documentation, rendez-vous |
| `visitor` | Visiteur | Formulaires publics uniquement |

---

## 🔧 INSTALLATION ET CONFIGURATION

### 1. Installation des dépendances

Les dépendances sont déjà installées :
```bash
npm install
```

Packages ajoutés :
- `@supabase/supabase-js` - Client Supabase
- `stripe` + `@stripe/stripe-js` - Paiements Stripe
- `simplemde` + `easymde` + `react-simplemde-editor` - Éditeur Markdown pour blog

### 2. Configuration des variables d'environnement

Copier `.env.example` vers `.env.local` et remplir les valeurs :

```bash
cp .env.example .env.local
```

**Variables critiques à configurer :**

```env
# Supabase (obligatoire)
VITE_SUPABASE_URL=https://tszsvbzfufglvdcsjzpo.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
SUPABASE_DB_PASSWORD=Proud@#2026-

# Stripe (obligatoire pour paiements carte)
VITE_STRIPE_PUBLIC_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...

# Orange Money (obligatoire pour mobile money)
ORANGE_MONEY_MERCHANT_KEY=your_key
ORANGE_MONEY_API_KEY=your_key

# MTN Mobile Money (obligatoire pour mobile money)
MTN_MOMO_SUBSCRIPTION_KEY=your_key
MTN_MOMO_API_USER=your_user
MTN_MOMO_API_KEY=your_key

# EmailJS (déjà configuré)
VITE_EMAILJS_SERVICE_ID=your_service_id
VITE_EMAILJS_TEMPLATE_ID=your_template_id
VITE_EMAILJS_PUBLIC_KEY=your_public_key
```

### 3. Exécution des migrations

**IMPORTANT** : Les migrations doivent être exécutées dans l'ordre sur votre base Supabase.

#### Option A : Via Supabase Dashboard (Recommandé)

1. Allez sur https://supabase.com/dashboard
2. Sélectionnez votre projet `tszsvbzfufglvdcsjzpo`
3. Menu "SQL Editor"
4. Exécutez les fichiers dans l'ordre :

```
supabase/migrations/20260706000001_create_profiles.sql
supabase/migrations/20260706000002_create_services.sql
supabase/migrations/20260706000003_create_blog.sql
supabase/migrations/20260706000004_create_documentation.sql
supabase/migrations/20260706000005_create_appointments.sql
supabase/migrations/20260706000006_create_coworking.sql
supabase/migrations/20260706000007_create_surveys.sql
supabase/migrations/20260706000008_create_contact_solutions.sql
supabase/migrations/20260706000009_create_audit_logs.sql
supabase/migrations/20260706000010_create_storage_buckets.sql
```

#### Option B : Via psql (Ligne de commande)

```bash
# Connexion directe
PGPASSWORD="Proud@#2026-" psql -h db.tszsvbzfufglvdcsjzpo.supabase.co -U postgres -d postgres -p 5432

# Exécuter les migrations
\i supabase/migrations/20260706000001_create_profiles.sql
\i supabase/migrations/20260706000002_create_services.sql
# ... etc
```

### 4. Seed des données initiales

Après les migrations, exécutez les seeds :

```sql
-- Via SQL Editor dans Supabase Dashboard
\i supabase/seed/seed_admin.sql
\i supabase/seed/seed_services.sql
```

**IMPORTANT** : Pour créer le compte admin `contact@andoh-dohgad.com` :

1. Allez dans **Authentication** > **Users** dans Supabase Dashboard
2. Cliquez "Add user" > "Create new user"
3. Email: `contact@andoh-dohgad.com`
4. Password: Choisissez un mot de passe fort
5. Cochez "Auto Confirm User"
6. Le trigger PostgreSQL créera automatiquement le profil avec role='admin'

---

## 🔐 AUTHENTIFICATION

### Flux d'inscription

```typescript
import { useAuth } from '@/contexts/AuthContext';

const { signUp } = useAuth();

await signUp('email@example.com', 'password123', {
  first_name: 'Jean',
  last_name: 'Dupont',
  role: 'visitor' // Par défaut
});
```

### Flux de connexion

```typescript
import { useAuth } from '@/contexts/AuthContext';

const { signIn, profile, hasRole } = useAuth();

await signIn('email@example.com', 'password123');

if (hasRole('admin')) {
  // Rediriger vers dashboard admin
}
```

### Protection de routes

```tsx
import { useAuth } from '@/contexts/AuthContext';
import { Navigate } from 'react-router-dom';

function ProtectedRoute({ children, allowedRoles }) {
  const { user, hasRole, loading } = useAuth();

  if (loading) return <div>Chargement...</div>;
  if (!user) return <Navigate to="/auth/connexion" />;
  if (allowedRoles && !hasRole(allowedRoles)) {
    return <Navigate to="/unauthorized" />;
  }

  return children;
}

// Usage
<Route path="/admin/*" element={
  <ProtectedRoute allowedRoles="admin">
    <AdminDashboard />
  </ProtectedRoute>
} />
```

---

## 💳 SYSTÈME DE PAIEMENT

### 1. Stripe (Cartes bancaires)

```typescript
import { getStripe, createPaymentIntent } from '@/lib/stripe/client';

// Créer un PaymentIntent
const { clientSecret } = await createPaymentIntent(15000, {
  documentId: 'xxx',
  buyerEmail: 'client@example.com'
});

// Confirmer le paiement
const stripe = await getStripe();
const result = await stripe.confirmCardPayment(clientSecret, {
  payment_method: {
    card: cardElement,
    billing_details: { name: 'Jean Dupont' }
  }
});

if (result.error) {
  // Erreur
} else {
  // Paiement réussi
}
```

### 2. Orange Money

```typescript
import {
  initiateOrangeMoneyPayment,
  redirectToOrangeMoneyPayment
} from '@/lib/mobile-money/orange-money';

// Initier le paiement
const { payment_url, payment_token } = await initiateOrangeMoneyPayment(
  15000, // montant en XOF
  'ORDER-123',
  'DOC-456'
);

// Rediriger l'utilisateur
redirectToOrangeMoneyPayment(payment_url);
```

### 3. MTN Mobile Money

```typescript
import {
  requestMTNMomoPayment,
  pollMTNMomoPaymentStatus
} from '@/lib/mobile-money/mtn-momo';

// Demander le paiement
const referenceId = await requestMTNMomoPayment(
  15000, // montant
  '+2250701234567', // numéro de téléphone
  'ORDER-123',
  'Achat document'
);

// Attendre confirmation (polling)
const status = await pollMTNMomoPaymentStatus(referenceId);

if (status.status === 'SUCCESSFUL') {
  // Paiement réussi
}
```

---

## 📝 EXEMPLES D'UTILISATION

### Créer un rendez-vous

```typescript
import { supabase } from '@/lib/supabase/client';

const { data, error } = await supabase
  .from('appointments')
  .insert({
    first_name: 'Jean',
    last_name: 'Dupont',
    email: 'jean@example.com',
    phone: '+2250701234567',
    service_id: 'service-uuid',
    preferred_date: '2026-07-15',
    time_slot: 'morning',
    message: 'Besoin de conseil fiscal'
  })
  .select()
  .single();
```

### Récupérer services multilingues

```typescript
const { data: services } = await supabase
  .from('services')
  .select(`
    *,
    service_translations!inner(*)
  `)
  .eq('status', 'active')
  .eq('service_translations.language', 'fr')
  .order('order_index');
```

### Soumettre un sondage

```typescript
const { data } = await supabase
  .from('surveys')
  .insert({
    survey_type: 'creation',
    respondent_name: 'Jean Dupont',
    respondent_email: 'jean@example.com',
    respondent_phone: '+2250701234567',
    responses: {
      structure: 'SARL',
      sector: 'Commerce',
      description: 'Import-export de produits alimentaires'
    }
  });
```

### Admin : Confirmer un rendez-vous

```typescript
await supabase.rpc('confirm_appointment', {
  appointment_uuid: 'rdv-uuid',
  confirmed_date_param: '2026-07-15',
  confirmed_time_param: '10:00',
  meeting_link_param: 'https://meet.google.com/abc-defg-hij'
});
```

### Admin : Exporter sondages en CSV

```typescript
const { data: surveys } = await supabase.rpc('export_surveys', {
  survey_type_param: 'creation',
  start_date: '2026-01-01',
  end_date: '2026-12-31'
});

// Convertir en CSV
const csv = convertToCSV(surveys);
```

---

## 🎨 INTÉGRATION FRONTEND

### Mise à jour de App.tsx

```tsx
import { AuthProvider } from '@/contexts/AuthContext';

function App() {
  return (
    <AuthProvider>
      <ScrollToTop />
      <Layout>
        <Routes>
          {/* Routes existantes */}
          <Route path="/auth/connexion" element={<Login />} />
          <Route path="/auth/inscription" element={<Signup />} />
          <Route path="/mon-compte" element={
            <ProtectedRoute>
              <MyAccount />
            </ProtectedRoute>
          } />
          <Route path="/admin/*" element={
            <ProtectedRoute allowedRoles="admin">
              <AdminDashboard />
            </ProtectedRoute>
          } />
        </Routes>
      </Layout>
    </AuthProvider>
  );
}
```

---

## 🛡️ SÉCURITÉ

### Row Level Security (RLS)

Toutes les tables ont des policies RLS activées :

- **Lecture** : Filtrage automatique selon le rôle
- **Écriture** : Seuls admins ou propriétaires
- **Suppression** : Admins uniquement

### Audit Logs

Toutes les opérations sensibles sont automatiquement loggées :

```sql
SELECT * FROM audit_logs
WHERE user_id = 'user-uuid'
ORDER BY created_at DESC;
```

### Storage Sécurisé

- **Buckets privés** : documentation (accès après achat uniquement)
- **Buckets publics** : blog-images, avatars, coworking-images
- **Signed URLs** : Expiration après 7 jours pour documents achetés

---

## 📊 DASHBOARD ADMIN

### Statistiques à afficher

```typescript
// Revenus du mois
const { data: revenue } = await supabase
  .from('documentation_purchases')
  .select('amount_paid')
  .eq('payment_status', 'completed')
  .gte('created_at', startOfMonth)
  .lte('created_at', endOfMonth);

// Rendez-vous en attente
const { count } = await supabase
  .from('appointments')
  .select('*', { count: 'exact', head: true })
  .eq('status', 'pending');

// Nouveaux utilisateurs
const { count: newUsers } = await supabase
  .from('profiles')
  .select('*', { count: 'exact', head: true })
  .gte('created_at', startOfMonth);
```

---

## 🧪 TESTS

### Tester la connexion Supabase

```bash
curl -X POST https://tszsvbzfufglvdcsjzpo.supabase.co/auth/v1/token?grant_type=password \
  -H "apikey: YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"email":"contact@andoh-dohgad.com","password":"your_password"}'
```

### Tester une fonction RPC

```bash
curl -X POST https://tszsvbzfufglvdcsjzpo.supabase.co/rest/v1/rpc/get_available_slots \
  -H "apikey: YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"check_date":"2026-07-15"}'
```

---

## 🚀 PROCHAINES ÉTAPES

### Phase 1 : Setup (FAIT ✅)
- [x] Migrations de base de données
- [x] Configuration Supabase
- [x] Intégration paiements (Stripe, Orange Money, MTN)
- [x] Contexte d'authentification

### Phase 2 : Composants Frontend (EN COURS 🔄)
- [ ] Formulaire d'inscription
- [ ] Composant de paiement unifié
- [ ] Dashboard utilisateur
- [ ] Dashboard admin (CMS)
- [ ] Éditeur de blog (SimpleMDE)

### Phase 3 : Edge Functions (TODO 📋)
- [ ] `/payment/create-intent`
- [ ] `/payment/confirm-mobile-money`
- [ ] `/documentation/purchase`
- [ ] `/documentation/download`
- [ ] `/appointments/notify`

### Phase 4 : Tests & Déploiement (TODO 📋)
- [ ] Tests end-to-end
- [ ] Audit sécurité
- [ ] Optimisation performances
- [ ] Documentation finale

---

## 📞 SUPPORT

**Questions techniques** :
- Documentation Supabase : https://supabase.com/docs
- Documentation Stripe : https://stripe.com/docs
- Orange Money API : https://developer.orange.com/
- MTN MoMo API : https://momodeveloper.mtn.com/

**Configuration admin** :
- Email admin : contact@andoh-dohgad.com
- Tableau de bord Supabase : https://supabase.com/dashboard/project/tszsvbzfufglvdcsjzpo

---

## 📝 NOTES IMPORTANTES

1. **Les clés API Orange Money et MTN MoMo** doivent être obtenues auprès des providers
2. **Stripe en mode test** : Utilisez `pk_test_` et `sk_test_` pour le développement
3. **Supabase ANON_KEY** : À récupérer dans Settings > API de votre projet
4. **Migrations** : TOUJOURS exécuter dans l'ordre pour éviter les dépendances cassées
5. **RLS** : Si une query échoue avec "permission denied", vérifiez les policies RLS

---

**Backend créé le** : 6 juillet 2026  
**Dernière mise à jour** : 6 juillet 2026  
**Version** : 1.0.0
