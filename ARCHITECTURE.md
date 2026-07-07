# 🏗️ ARCHITECTURE DU BACKEND - ANDOH & DOHGAD CONSULTING

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     FRONTEND (React 19 + TypeScript)                         │
│                                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   Visiteur   │  │   Client     │  │ Client Co-   │  │    Admin     │  │
│  │  (public)    │  │  Standard    │  │  working     │  │              │  │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  │
│         │                 │                  │                  │           │
│         └─────────────────┴──────────────────┴──────────────────┘           │
│                                    │                                         │
│                          ┌─────────▼─────────┐                              │
│                          │  AuthContext      │                              │
│                          │  (useAuth hook)   │                              │
│                          └─────────┬─────────┘                              │
│                                    │                                         │
└────────────────────────────────────┼─────────────────────────────────────────┘
                                     │
         ┌───────────────────────────┼───────────────────────────┐
         │                           │                           │
         ▼                           ▼                           ▼
┌──────────────────┐     ┌──────────────────┐      ┌──────────────────┐
│  Supabase Client │     │  Stripe Client   │      │  Mobile Money    │
│  (PostgreSQL +   │     │  (Paiements CB)  │      │  (Orange + MTN)  │
│   Auth + Storage)│     └──────────────────┘      └──────────────────┘
└────────┬─────────┘
         │
         │  HTTPS (Row Level Security)
         │
         ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         SUPABASE (Backend as a Service)                      │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                      PostgreSQL Database                                │ │
│  │                                                                          │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                │ │
│  │  │   profiles   │  │   services   │  │  blog_posts  │                │ │
│  │  │              │  │ + translations│  │ + translations│                │ │
│  │  │ • id (UUID)  │  │              │  │              │                │ │
│  │  │ • role       │  │ • slug       │  │ • slug       │                │ │
│  │  │ • email      │  │ • icon_name  │  │ • category   │                │ │
│  │  │ • first_name │  │ • status     │  │ • author_id  │                │ │
│  │  │ • last_name  │  │              │  │ • views_count│                │ │
│  │  └──────────────┘  └──────────────┘  └──────────────┘                │ │
│  │                                                                          │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                │ │
│  │  │documentation │  │ appointments │  │  surveys     │                │ │
│  │  │ + purchases  │  │              │  │              │                │ │
│  │  │              │  │ • first_name │  │ • survey_type│                │ │
│  │  │ • price      │  │ • email      │  │ • responses  │                │ │
│  │  │ • file_url   │  │ • service_id │  │   (JSONB)    │                │ │
│  │  │ • download_  │  │ • status     │  │ • status     │                │ │
│  │  │   count      │  │ • confirmed_ │  │ • assigned_to│                │ │
│  │  └──────────────┘  │   at         │  └──────────────┘                │ │
│  │                    └──────────────┘                                    │ │
│  │                                                                          │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                │ │
│  │  │ coworking_   │  │ coworking_   │  │ coworking_   │                │ │
│  │  │   spaces     │  │subscriptions │  │   bookings   │                │ │
│  │  │              │  │              │  │              │                │ │
│  │  │ • name       │  │ • plan_type  │  │ • space_id   │                │ │
│  │  │ • type       │  │ • user_id    │  │ • booking_   │                │ │
│  │  │ • capacity   │  │ • status     │  │   date       │                │ │
│  │  │ • amenities  │  │ • monthly_   │  │ • start_time │                │ │
│  │  │ • hourly_rate│  │   price      │  │ • end_time   │                │ │
│  │  └──────────────┘  └──────────────┘  └──────────────┘                │ │
│  │                                                                          │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                │ │
│  │  │contact_      │  │  solutions   │  │  audit_logs  │                │ │
│  │  │ messages     │  │ + translations│  │              │                │ │
│  │  │              │  │              │  │ • user_id    │                │ │
│  │  │ • name       │  │ • icon_name  │  │ • action     │                │ │
│  │  │ • email      │  │ • status     │  │ • table_name │                │ │
│  │  │ • message    │  │ • demo_url   │  │ • old_values │                │ │
│  │  │ • status     │  │              │  │ • new_values │                │ │
│  │  └──────────────┘  └──────────────┘  └──────────────┘                │ │
│  │                                                                          │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                  Row Level Security (RLS) Policies                      │ │
│  │                                                                          │ │
│  │  Visitor       │ Public forms, read services/blog                       │ │
│  │  Standard      │ + Own appointments, own purchases                      │ │
│  │  Coworking     │ + Space bookings, own subscription                     │ │
│  │  Admin         │ Full CRUD on all tables                                │ │
│  │                                                                          │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                          Storage Buckets                                │ │
│  │                                                                          │ │
│  │  🔒 documentation (private)  │  Paid docs, signed URLs (7 days)        │ │
│  │  🌐 blog-images (public)     │  Blog cover images                      │ │
│  │  🌐 service-images (public)  │  Service illustrations                  │ │
│  │  🌐 avatars (public)         │  User profile pictures                  │ │
│  │  🌐 coworking-images (public)│  Space photos                           │ │
│  │                                                                          │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                      PostgreSQL Functions                               │ │
│  │                                                                          │ │
│  │  • increment_blog_views(slug)         • generate_download_link(id)     │ │
│  │  • get_available_slots(date)          • increment_download_count(id)   │ │
│  │  • confirm_appointment(...)           • check_space_availability(...)  │ │
│  │  • cancel_appointment(id)             • get_available_spaces(...)      │ │
│  │  • approve_subscription(id)           • export_surveys(filters)        │ │
│  │  • assign_survey(id, admin)           • mark_message_read(id)          │ │
│  │  • reply_to_message(id, text)         • log_audit(...)                 │ │
│  │                                                                          │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                       Authentication (Supabase Auth)                    │ │
│  │                                                                          │ │
│  │  • Email/Password signup                                                │ │
│  │  • Email confirmation                                                   │ │
│  │  • Password reset                                                       │ │
│  │  • JWT tokens (auto-refresh)                                            │ │
│  │  • Session management                                                   │ │
│  │  • Trigger: Auto-create profile on signup                               │ │
│  │                                                                          │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                        PAYMENT PROVIDERS                                     │
│                                                                              │
│  ┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────┐ │
│  │      STRIPE          │  │   ORANGE MONEY       │  │   MTN MOMO       │ │
│  │  (Cartes bancaires)  │  │  (Mobile Money CI)   │  │(Mobile Money CI) │ │
│  │                      │  │                      │  │                  │ │
│  │  • createPaymentIntent│  │ • initiatePayment    │  │ • requestPayment │ │
│  │  • confirmPayment     │  │ • checkStatus        │  │ • checkStatus    │ │
│  │  • webhooks           │  │ • redirect user      │  │ • pollStatus     │ │
│  │  • XOF support        │  │                      │  │                  │ │
│  └──────────────────────┘  └──────────────────────┘  └──────────────────┘ │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                          NOTIFICATION LAYER                                  │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │                           EmailJS                                      │  │
│  │                                                                        │  │
│  │  • Appointment confirmation                                            │  │
│  │  • Subscription approved                                               │  │
│  │  • Purchase confirmation                                               │  │
│  │  • Password reset                                                      │  │
│  │  • Admin notifications                                                 │  │
│  │                                                                        │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 🔄 FLUX DE DONNÉES

### 1. Inscription d'un utilisateur

```
┌─────────┐     ┌──────────┐     ┌───────────┐     ┌──────────┐
│ Frontend│     │ Supabase │     │PostgreSQL │     │  Email   │
│  (Form) │────▶│   Auth   │────▶│  Trigger  │────▶│ Confirm  │
└─────────┘     └──────────┘     └───────────┘     └──────────┘
                                       │
                                       ▼
                                ┌──────────────┐
                                │  profiles    │
                                │ (role:visitor)│
                                └──────────────┘
```

### 2. Achat de documentation

```
┌─────────┐     ┌─────────┐     ┌────────────┐     ┌──────────┐
│  Select │────▶│  Choose │────▶│   Payment  │────▶│  Confirm │
│   Doc   │     │ Payment │     │  (Stripe/  │     │          │
│         │     │ Method  │     │  Orange/   │     │          │
│         │     │         │     │   MTN)     │     │          │
└─────────┘     └─────────┘     └──────┬─────┘     └────┬─────┘
                                       │                  │
                                       ▼                  ▼
                                ┌──────────────┐   ┌──────────┐
                                │documentation_│   │ EmailJS  │
                                │  purchases   │   │ (receipt)│
                                │ + signed URL │   └──────────┘
                                └──────────────┘
```

### 3. Prise de rendez-vous

```
┌─────────┐     ┌──────────┐     ┌───────────┐     ┌──────────┐
│  Client │────▶│ Available│────▶│   Submit  │────▶│  Admin   │
│  Form   │     │  Slots   │     │  (pending)│     │ Notified │
└─────────┘     └──────────┘     └─────┬─────┘     └──────────┘
                                       │
                                       ▼
                                ┌──────────────┐
                                │ Admin confirms│
                                │ + adds link   │
                                └──────┬────────┘
                                       │
                                       ▼
                                ┌──────────────┐
                                │ Client email │
                                │ confirmation │
                                └──────────────┘
```

### 4. Abonnement co-working

```
┌─────────┐     ┌──────────┐     ┌───────────┐     ┌──────────┐
│  Client │────▶│  Select  │────▶│  Request  │────▶│  Admin   │
│  Signup │     │   Plan   │     │ (pending) │     │ Approves │
└─────────┘     └──────────┘     └───────────┘     └────┬─────┘
                                                         │
                                                         ▼
                                                  ┌──────────────┐
                                                  │ Role upgraded│
                                                  │ to coworking_│
                                                  │    client    │
                                                  └──────────────┘
```

---

## 🎯 POINTS D'ENTRÉE API

| Endpoint | Méthode | Auth | Description |
|----------|---------|------|-------------|
| `/rest/v1/profiles` | GET | ✅ | Récupérer profil utilisateur |
| `/rest/v1/services` | GET | ❌ | Lister services actifs |
| `/rest/v1/blog_posts` | GET | ❌ | Lister articles publiés |
| `/rest/v1/documentation` | GET | ❌ | Lister docs payants |
| `/rest/v1/appointments` | POST | ❌ | Créer rendez-vous |
| `/rest/v1/coworking_spaces` | GET | ❌ | Lister espaces disponibles |
| `/rest/v1/surveys` | POST | ❌ | Soumettre sondage |
| `/rest/v1/contact_messages` | POST | ❌ | Envoyer message |
| `/rest/v1/rpc/get_available_slots` | POST | ❌ | Vérifier disponibilités RDV |
| `/rest/v1/rpc/confirm_appointment` | POST | ✅ Admin | Confirmer rendez-vous |
| `/rest/v1/rpc/export_surveys` | POST | ✅ Admin | Exporter sondages CSV |
| `/storage/v1/object/documentation/*` | GET | ✅ Signed | Télécharger doc acheté |

---

## 🔐 MATRICE DE PERMISSIONS

| Ressource | Visitor | Standard | Coworking | Admin |
|-----------|---------|----------|-----------|-------|
| **Services** | Read | Read | Read | CRUD |
| **Blog** | Read | Read | Read | CRUD |
| **Documentation** | Read list | + Own purchases | + Own purchases | CRUD + All purchases |
| **Appointments** | Create | + Read own | + Read own | CRUD all |
| **Surveys** | Create | + Read own | + Read own | CRUD + Export |
| **Contact** | Create | Create | Create | CRUD |
| **Coworking Spaces** | Read | Read | Read | CRUD |
| **Coworking Bookings** | ❌ | ❌ | CRUD own | CRUD all |
| **Subscriptions** | ❌ | ❌ | Read own | CRUD all |
| **Profiles** | Own | Own | Own | All |
| **Audit Logs** | ❌ | ❌ | ❌ | Read all |

---

## 📊 MODÈLE DE DONNÉES SIMPLIFIÉ

```
profiles (users)
    ├── appointments (many-to-one)
    ├── documentation_purchases (many-to-one)
    ├── coworking_subscriptions (one-to-many)
    ├── coworking_bookings (one-to-many)
    ├── surveys (one-to-many)
    ├── contact_messages (one-to-many)
    └── blog_posts (one-to-many, author)

services
    └── service_translations (one-to-many)

blog_posts
    └── blog_post_translations (one-to-many)

documentation
    ├── documentation_translations (one-to-many)
    └── documentation_purchases (one-to-many)

coworking_spaces
    ├── coworking_subscriptions (one-to-many)
    └── coworking_bookings (one-to-many)

solutions
    └── solution_translations (one-to-many)
```

---

## 🚀 PERFORMANCE & SCALABILITÉ

| Aspect | Solution implémentée |
|--------|---------------------|
| **Database** | PostgreSQL avec indexes sur colonnes fréquemment requêtées |
| **Auth** | JWT tokens avec auto-refresh (pas de session serveur) |
| **CDN** | Supabase CDN pour Storage (images, avatars) |
| **Caching** | Supabase cache automatique pour queries fréquentes |
| **Connection pooling** | Transaction pooler Supabase (6543) pour haute charge |
| **Real-time** | Supabase Realtime pour notifications live (optionnel) |
| **Backup** | Point-in-Time Recovery Supabase (restauration 7 jours) |
| **Monitoring** | Logs PostgreSQL + Supabase Dashboard metrics |

---

## 🛡️ SÉCURITÉ

| Menace | Protection |
|--------|-----------|
| **SQL Injection** | Supabase parameterized queries + RLS |
| **XSS** | React auto-escape + CSP headers |
| **CSRF** | Supabase JWT tokens (not cookies) |
| **Unauthorized access** | Row Level Security sur toutes tables |
| **Data leaks** | Audit logs + signed URLs avec expiration |
| **Password storage** | Supabase bcrypt hashing |
| **API abuse** | Rate limiting Supabase (60 req/min free tier) |
| **File uploads** | Storage policies + file type validation |

---

**Architecture créée le** : 6 juillet 2026  
**Version** : 1.0.0  
**Status** : ✅ Production Ready
