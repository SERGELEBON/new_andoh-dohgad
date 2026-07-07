# Andoh & Dohgad Consulting — Technical Specification

## 1. Development Environment

| Technology | Version | Purpose |
|------------|---------|---------|
| React | 18.x | UI framework |
| TypeScript | 5.x | Type safety |
| Vite | 5.x/6.x | Build tool & dev server |
| Tailwind CSS | 3.4.x | Utility-first CSS |
| shadcn/ui | latest | UI component primitives |
| Node.js | 20+ | Runtime (pinned by webapp-building skill) |

**Package Manager**: npm (as per webapp-building skill scripts)

---

## 2. Dependencies

### Core Framework (pre-installed by webapp-building skill)

| Package | Version | Purpose |
|---------|---------|---------|
| `react` | ^18.3.0 | UI library |
| `react-dom` | ^18.3.0 | React DOM renderer |
| `typescript` | ~5.6.0 | Type checking |
| `vite` | ^5.4.0 / ^6.0.0 | Build tool (auto-detected by skill) |
| `tailwindcss` | ^3.4.0 | CSS framework |
| `postcss` | ^8.4.0 | CSS processing |
| `autoprefixer` | ^10.4.0 | Vendor prefixing |
| `tailwind-merge` | ^2.6.0 | Tailwind class merging |
| `clsx` | ^2.1.0 | Conditional class names |
| `class-variance-authority` | ^0.7.0 | Component variant management |

### Routing

| Package | Version | Purpose |
|---------|---------|---------|
| `react-router-dom` | ^6.28.0 | Client-side SPA routing (14 routes) |

### Animation

| Package | Version | Purpose |
|---------|---------|---------|
| `gsap` | ^3.12.0 | Core animation engine — timelines, ScrollTrigger, DrawSVG |
| `framer-motion` | ^11.15.0 | Declarative React animations (page transitions, simple enter/exit) |
| `react-countup` | ^6.5.0 | Animated stat counters |

> **Note**: GSAP is primary for complex scroll-orchestrated animations (cascading reveals, SVG path draws, character-by-character text). Framer-motion handles page route transitions and simple hover states.

### Internationalization

| Package | Version | Purpose |
|---------|---------|---------|
| `react-i18next` | ^15.4.0 | i18n for React — FR/EN/ES language switching |
| `i18next` | ^24.0.0 | Core i18n engine |
| `i18next-browser-languagedetector` | ^8.0.0 | Auto-detect browser language |

### Forms & Validation

| Package | Version | Purpose |
|---------|---------|---------|
| `react-hook-form` | ^7.54.0 | Performant form management (5 forms) |
| `@hookform/resolvers` | ^3.9.0 | Zod resolver for react-hook-form |
| `zod` | ^3.24.0 | Schema validation for all forms |

### Email Sending

| Package | Version | Purpose |
|---------|---------|---------|
| `emailjs-com` | ^3.2.0 | Client-side email sending via EmailJS (forms → andoh.dohgad@gmail.com) |

### Icons

| Package | Version | Purpose |
|---------|---------|---------|
| `lucide-react` | ^0.460.0 | Icon library (service icons, UI icons, social icons) |

### shadcn/ui Dependencies (pre-installed)

All Radix UI primitives, `@radix-ui/react-*` packages — used via shadcn/ui components:
- `accordion`, `dialog`, `input`, `select`, `tabs`, `textarea`, `scroll-area`, `dropdown-menu`

### Google Fonts (loaded via `<link>` in `index.html`)

- **Playfair Display** (400, 500, 600, 700) — Display/title font
- **Inter** (300, 400, 500, 600, 700) — Body/UI font

---

## 3. Component Inventory

### 3.1 shadcn/ui Components (Built-in)

These are pre-installed by the webapp-building skill init script. Use `npx shadcn add <name>` to add any missing.

| Component | Purpose | Used On |
|-----------|---------|---------|
| `accordion` | FAQ expandable sections | Service Detail |
| `dialog` | Purchase modal overlay | Documentation |
| `input` | Form text inputs | All forms |
| `select` | Dropdown fields | Appointment, Surveys, Contact |
| `tabs` | Filter tabs on Documentation, Survey form selector | Documentation, Surveys |
| `textarea` | Message fields | All forms |
| `scroll-area` | Custom scrollable regions | Mobile menu, sidebar |
| `dropdown-menu` | Language switcher dropdown | Header |

### 3.2 Custom Components

#### Layout Components (shared across all pages)

| Component | Props | Description |
|-----------|-------|-------------|
| `Header` | — | Fixed header with scroll-aware background (transparent → solid violet), logo, nav links, language switcher, CTA button, mobile hamburger. Active route highlighting. |
| `MobileMenu` | `isOpen: boolean, onClose: () => void` | Full-screen overlay menu (mobile <1024px). Slide-in from right, stacked nav links, language switcher, CTA. Body scroll lock. |
| `Footer` | — | 4-column deep violet footer: brand column (logo + tagline + socials), services links, navigation links, contact info. Bottom copyright bar. |
| `PageHeader` | `breadcrumb: string[], title: string, subtitle: string` | Reusable page hero banner with violet gradient, breadcrumb trail, H1 title, subtitle. Used on all non-home pages. |
| `Layout` | `children: ReactNode` | Shared layout wrapper: Header + `<main>` + Footer. Handles scroll-to-top on route change. Wraps all pages via router. |

#### UI Components

| Component | Props | Description |
|-----------|-------|-------------|
| `Button` | `variant: 'primary' \| 'secondary' \| 'outline' \| 'text', size, children, ...` | 4 variants matching design tokens. Hover animations (translateY, shadow). Arrow icon support for text variant. |
| `SectionTitle` | `label: string, title: string, align?: 'left' \| 'center'` | Label → Title → Gold underline cascade. Used across all content sections. |
| `ServiceCard` | `icon: LucideIcon, title: string, description: string, features?: string[], link?: string` | Card with icon (in violet circle), title, description, optional features list, CTA link. Hover lift + shadow. |
| `BlogCard` | `image: string, category: string, title: string, excerpt: string, date: string, readTime: string, link: string` | Image top, category badge, title (2-line clamp), excerpt (3-line clamp), meta. Hover lift. |
| `DocumentCard` | `type: string, title: string, description: string, price: string, onPurchase: () => void` | File icon, type badge, title, description, price in gold, "Acheter" button. Hover border + shadow. |
| `TestimonialCard` | `quote: string, author: string, role: string, rating: number` | Quote mark icon, italic quote text, author avatar + name + role, 5-star rating. |
| `TeamCard` | `photo: string, name: string, role: string, bio: string` | Photo (3:4 aspect), name, role (violet), bio. |
| `PricingCard` | `name: string, price: string, features: string[], featured?: boolean, cta: string` | Plan card with optional gold border + "POPULAIRE" badge. Feature list with checkmarks. |
| `TestimonialSlider` | `testimonials: Testimonial[]` | Horizontal carousel/slider. Shows 1 (mobile) / 2 (tablet) / 3 (desktop) cards. Arrow nav + dot indicators. |
| `FormInput` | `label: string, name: string, type?: string, placeholder?: string, error?: string, ...` | Styled input with label, focus ring (violet), error state (red border + message). Integrates react-hook-form. |
| `FormSelect` | `label: string, name: string, options: Option[], ...` | Styled select dropdown with custom chevron. Integrates react-hook-form. |
| `FormTextarea` | `label: string, name: string, placeholder?: string, ...` | Styled textarea, min-height 120px. Integrates react-hook-form. |
| `LanguageSwitcher` | — | Dropdown toggle showing current lang (FR/EN/ES). Dropdown with 3 options (flag + label). Triggers i18n change. |
| `PurchaseModal` | `isOpen: boolean, onClose: () => void, document: Document` | Overlay modal with document summary, contact form, simulated payment options (Stripe/CinetPay), success confirmation. |
| `SurveyCard` | `icon: LucideIcon, title: string, description: string, onClick: () => void` | Small card for survey selection grid. Icon + title + description + "Commencer" button. |

#### Section Components (used in pages)

| Component | Used On | Description |
|-----------|---------|-------------|
| `HeroSection` | Home | Full-viewport hero: bg image + violet overlay + particle canvas + animated text + CTA buttons. Page load sequence. |
| `StatsBar` | Home | 3-column stat counters with animated count-up. Dark violet background. |
| `ServicesGrid` | Home, Services | 3-column card grid of ServiceCards. |
| `ValueProposition` | Home | 55/45 two-column: text (left) + image (right). Quote with gold border. |
| `TestimonialsSection` | Home | Section title + TestimonialSlider. |
| `BlogPreview` | Home | 3-column blog card grid with "Voir tous les articles" link. |
| `CTABanner` | Home, About, Services, Solutions, Contact | Full-width maroon bandeau with title + gold CTA button. |
| `VisionSection` | About | Centered vision statement with character reveal animation. |
| `ValuesGrid` | About | 2x2 grid of value cards with icons. |
| `MethodologySteps` | About | 4-step horizontal process flow with numbered circles + connecting line. |
| `TeamGrid` | About | 3-column team member cards. |
| `SolutionsGrid` | Solutions | 2-column solution cards with status badges. |
| `ERPTeaser` | Solutions | Full-width violet gradient card with two-column layout (text + mockup image). |
| `DocumentGrid` | Documentation | 4-column document cards with filter tabs. |
| `BlogGrid` | Blog | 2-column article cards with category filter tabs + sidebar. |
| `ArticleContent` | Blog Post | Rich text article body with TOC, share buttons, author bio, related articles. |
| `AppointmentForm` | Appointment | Complete booking form with validation + EmailJS submission. |
| `SpacePresentation` | Co-working | Two-column: features list + image gallery. |
| `PricingGrid` | Co-working | 3 pricing cards (Nomade, Résident, Domiciliation). |
| `RegistrationForm` | Co-working | Account creation form for co-working. |
| `SurveySelector` | Surveys | 5-card grid for survey selection. |
| `ActiveSurveyForm` | Surveys | Tabbed form area rendering the selected survey form. |
| `ContactForm` | Contact | Contact form with validation + EmailJS. |
| `ContactInfo` | Contact | Info card (phone, email, address, hours) + social icons + embedded map. |

#### Animation Components

| Component | Description |
|-----------|-------------|
| `ParticleCanvas` | Canvas-based floating particle effect for hero. ~50 white dots rising upward with organic movement. Rendered on `<canvas>` element. |
| `CharacterReveal` | GSAP-powered character-by-character text reveal. Wraps each character in `<span>`, animates opacity with stagger. |
| `LineReveal` | GSAP-powered line-by-line text reveal for section titles. |
| `FadeUp` | Reusable scroll-triggered fade-up wrapper. Uses GSAP ScrollTrigger. Configurable delay, stagger. |
| `CounterAnimation` | Wrapper around `react-countup` with ScrollTrigger start. |

---

## 4. Animation Implementation Table

| # | Animation | Library / Addons | Implementation Approach | Complexity |
|---|-----------|-----------------|------------------------|------------|
| 1 | **Hero particle canvas** | Custom Canvas API | `<canvas>` element with requestAnimationFrame loop. ~50 particles with random x position, rising y velocity, opacity 0.1-0.3. Parallax disabled on mobile. | 🔒 High |
| 2 | **Hero page load sequence** | GSAP Timeline | Single GSAP timeline: bg fade (0.8s) → overlay fade (0.6s) → label fade-up (0.5s) → CharacterReveal (cascading per char, 0.03s stagger) → subtitle fade-up (0.6s, 1.2s delay) → buttons fade-up (0.5s, 1.5s delay) | 🔒 High |
| 3 | **Character-by-character text reveal** | GSAP (SplitText or manual) | Manual text splitting: wrap each char in `<span>`, GSAP stagger animation on opacity (0.03s per char, 0.4s duration). Used on Hero title, About vision statement. | 🔒 High |
| 4 | **Line-by-line section title reveal** | GSAP ScrollTrigger | Split title into lines, animate each: opacity 0→1, translateY 30→0, stagger 0.1s. Duration 0.7s. Trigger at "top 85%". | Medium |
| 5 | **Gold underline draw** | GSAP ScrollTrigger | Animate `width: 0% → 100%` on the underline pseudo-element. 0.6s. Fires after parent title animation starts. | Low |
| 6 | **Section cascade entrance** | GSAP ScrollTrigger | Reusable pattern per section: label fade (0s) → title line reveal (0.1s) → underline draw (0.3s) → content fade-up with 0.15s stagger (0.4s). Applied to all content sections. | Medium |
| 7 | **Fade-up scroll entrance** | GSAP ScrollTrigger | `opacity: 0→1, y: 40→0`, duration 0.8s, easing `cubic-bezier(0.22, 0.61, 0.36, 1)`. Trigger: "top 85%". `once: true`. Applied to cards, text blocks, form fields. | Low |
| 8 | **Slide from left** | GSAP ScrollTrigger | `opacity: 0→1, x: -60→0`, 0.8s. Used on text columns in two-column layouts (Value Proposition, Firm Presentation). | Low |
| 9 | **Slide from right** | GSAP ScrollTrigger | `opacity: 0→1, x: 60→0`, 0.8s, 0.2s delay. Used on image columns in two-column layouts. | Low |
| 10 | **Scale-up entrance** | GSAP ScrollTrigger | `opacity: 0→1, scale: 0.9→1`, 0.6s. Used on modal, registration form card. | Low |
| 11 | **Counter animation** | react-countup + GSAP ScrollTrigger | `<CountUp>` component triggered by ScrollTrigger `onEnter`. Duration 2s, ease-out. Format with suffix (+, %). Stats bar on Home. | Low |
| 12 | **SVG path draw** | GSAP DrawSVG (Club plugin) | `stroke-dashoffset: fullLength → 0`, 1.5s, ease-in-out. Used on: connecting line in Methodology, decorative shapes. | Medium |
| 13 | **Parallax background** | GSAP ScrollTrigger | Background image `y` transform at 0.3x scroll speed. Decorative shapes at 0.1-0.2x. Disabled on mobile (<768px). | Medium |
| 14 | **Card hover effect** | CSS Transition | `translateY(0 → -4px)`, `box-shadow` increase, `border-color` change. 0.3s ease-out. Pure CSS, no library needed. | Low |
| 15 | **Button hover effect** | CSS Transition | `translateY(0 → -2px)`, background darkens, shadow appears. 0.3s ease-out. Pure CSS. | Low |
| 16 | **Header background transition** | CSS + JS scroll listener | Scroll listener updates CSS class at 100px threshold. CSS transition on `background-color` and `box-shadow`, 0.3s ease. | Low |
| 17 | **Mobile menu slide-in** | Framer Motion | `AnimatePresence` + `motion.div` with `x: 100% → 0`, 0.3s. Overlay fade. Body scroll lock via `useEffect`. | Low |
| 18 | **Testimonial slider** | Custom + Framer Motion | State-driven active index. Outgoing: `opacity:1→0, x:0→-30` (0.3s). Incoming: `opacity:0→1, x:30→0` (0.3s). Arrow buttons + dot indicators. | Medium |
| 19 | **Page route transitions** | Framer Motion | `AnimatePresence` wrapping `<Outlet>`. Exit: opacity 1→0 (0.2s). Enter: opacity 0→1 (0.3s). Scroll reset to top on route change. | Medium |
| 20 | **Language switch transition** | Framer Motion | Content `AnimatePresence`: fade out (0.2s) → language change → fade in (0.3s). No page reload. | Low |
| 21 | **Hero scroll fade-out** | GSAP ScrollTrigger | Hero content opacity decreases proportionally with scroll position. ScrollTrigger scrubbed animation. | Low |
| 22 | **Filter tab cross-fade** | Framer Motion | `AnimatePresence` on filtered card grid. Cards cross-fade (opacity, 0.2s) on category change. Documentation + Blog. | Low |
| 23 | **FAQ accordion** | shadcn Accordion + CSS | Height `0 → auto` via Radix. 0.3s ease. Chevron rotates 180°. | Low |
| 24 | **Purchase modal entrance** | Framer Motion | Overlay fade (0.2s). Modal: `scale: 0.9 → 1, opacity: 0 → 1` (0.3s). | Low |
| 25 | **Form success animation** | Framer Motion | Success message: `scale: 0.8 → 1, opacity: 0 → 1` (0.5s). Green checkmark icon scales in first. | Low |
| 26 | **Decorative shape parallax** | GSAP ScrollTrigger | SVG triangle/circle/arc shapes move at 0.1-0.2x scroll speed for subtle depth. | Low |

---

## 5. State & Logic Planning

### 5.1 Language State (i18n)

- **Library**: `react-i18next` with `i18next-browser-languagedetector`
- **Detection order**: localStorage → navigator.language → default (fr)
- **3 namespaces**: `common` (shared UI), `home`, `pages` (all other pages)
- **Language files**: `public/locales/fr/*.json`, `public/locales/en/*.json`, `public/locales/es/*.json`
- **Switching**: `i18n.changeLanguage(lang)` → content fades out/in via Framer Motion `AnimatePresence`
- **HTML lang attribute**: Updated via `useEffect` on language change
- **SEO**: `<title>` and `<meta name="description">` are language-specific, updated via `react-helmet-async`

### 5.2 Form Management Pattern (shared across 5 forms)

All forms use the same architecture:
- **Validation library**: Zod schemas per form
- **Form library**: `react-hook-form` with `@hookform/resolvers/zod`
- **Submission**: `emailjs-com` → `andoh.dohgad@gmail.com`
- **States**: `idle → submitting → success | error`
- **State machine**: Managed via `useState<'idle' | 'submitting' | 'success' | 'error'>`
- **Success display**: Form replaced with animated success message (Framer Motion)
- **Error display**: Field-level errors from Zod + global error message

**Forms affected**: Appointment, Contact, Co-working Registration, Surveys (5 forms), Documentation Purchase Modal

### 5.3 Scroll Orchestration (GSAP ScrollTrigger)

- **Global initialization**: In `useEffect` in Layout or per-section `useEffect`
- **Cleanup**: `ScrollTrigger.getAll().forEach(t => t.kill())` on unmount
- **Trigger defaults**: `start: "top 85%"`, `once: true`
- **Cascading timeline**: Per-section GSAP timeline with labeled positions for each element
- **Reduced motion**: Check `window.matchMedia('(prefers-reduced-motion: reduce)')` — disable complex animations, keep simple fades

### 5.4 Header Scroll State

- **Listener**: `scroll` event with `requestAnimationFrame` throttling
- **Threshold**: 100px scroll position
- **State**: `isScrolled: boolean` → toggles CSS class for transparent/solid background
- **Mobile menu**: `isMobileMenuOpen: boolean` → body overflow hidden when open

### 5.5 Testimonial Slider State

- **State**: `activeIndex: number`
- **Navigation**: prev/next arrows (disabled at ends), dot click
- **Visible count**: 1 (mobile), 2 (tablet), 3 (desktop) — derived from window width
- **Auto-play**: None (manual navigation only)

### 5.6 Survey Tab State

- **State**: `activeSurvey: 'creation' | 'service' | 'rh' | 'domiciliation' | 'coworking'`
- **Switching**: Click survey card → active form fades in (Framer Motion)
- **Form data**: Each survey maintains its own react-hook-form instance

### 5.7 Documentation Filter State

- **State**: `activeFilter: 'all' | 'guides' | 'fiscaux' | 'modeles' | 'notes'`
- **Derived**: Filtered document array computed from activeFilter
- **Animation**: `AnimatePresence` cross-fade on card grid

### 5.8 Blog Filter State

- **State**: `activeCategory: 'all' | 'comptabilite' | 'fiscalite' | 'rh' | 'strategie' | 'reglementation'`
- **Derived**: Filtered articles array

### 5.9 Purchase Modal State

- **State**: `isModalOpen: boolean`, `selectedDocument: Document | null`
- **Flow**: Click "Acheter" → open modal with document → fill form → simulated payment → success confirmation

### 5.10 Routing

- **Router**: `BrowserRouter` from `react-router-dom`
- **Scroll behavior**: `useEffect` on route change → `window.scrollTo(0, 0)`
- **Routes**: 14 routes (see table in Section 7.1)
- **Dynamic routes**: `/services/:slug`, `/blog/:slug`
- **404**: Catch-all route → redirect to Home

---

## 6. Project File Structure

```
/mnt/agents/output/app/
├── public/
│   ├── locales/
│   │   ├── fr/
│   │   │   ├── common.json
│   │   │   ├── home.json
│   │   │   └── pages.json
│   │   ├── en/
│   │   │   ├── common.json
│   │   │   ├── home.json
│   │   │   └── pages.json
│   │   └── es/
│   │       ├── common.json
│   │       ├── home.json
│   │       └── pages.json
│   ├── images/
│   │   ├── hero-background.jpg
│   │   ├── value-proposition.jpg
│   │   ├── about-team.jpg
│   │   ├── team-1.jpg
│   │   ├── team-2.jpg
│   │   ├── team-3.jpg
│   │   ├── blog-fiscalite.jpg
│   │   ├── blog-entrepreneuriat.jpg
│   │   ├── blog-rh.jpg
│   │   ├── blog-comptabilite.jpg
│   │   ├── blog-strategie.jpg
│   │   ├── blog-reglementation.jpg
│   │   ├── erp-mockup.jpg
│   │   ├── coworking-main.jpg
│   │   ├── logo.png                 # uploaded logo
│   │   └── favicon.ico
│   └── sitemap.xml
├── src/
│   ├── main.tsx                     # Entry point, BrowserRouter wrapper
│   ├── App.tsx                      # Route definitions, Layout wrapper, AnimatePresence
│   ├── index.css                    # Tailwind directives, CSS variables, global styles, fonts
│   ├── vite-env.d.ts               # Vite client types
│   ├── pages/                       # Route-level page components
│   │   ├── Home.tsx
│   │   ├── About.tsx
│   │   ├── Services.tsx
│   │   ├── ServiceDetail.tsx
│   │   ├── Solutions.tsx
│   │   ├── Documentation.tsx
│   │   ├── Blog.tsx
│   │   ├── BlogPost.tsx
│   │   ├── Appointment.tsx
│   │   ├── Coworking.tsx
│   │   ├── Surveys.tsx
│   │   └── Contact.tsx
│   ├── sections/                    # Page section components
│   │   ├── HeroSection.tsx
│   │   ├── StatsBar.tsx
│   │   ├── ServicesGrid.tsx
│   │   ├── ValueProposition.tsx
│   │   ├── TestimonialsSection.tsx
│   │   ├── BlogPreview.tsx
│   │   ├── CTABanner.tsx
│   │   ├── VisionSection.tsx
│   │   ├── ValuesGrid.tsx
│   │   ├── MethodologySteps.tsx
│   │   ├── TeamGrid.tsx
│   │   ├── SolutionsGrid.tsx
│   │   ├── ERPTeaser.tsx
│   │   ├── DocumentGrid.tsx
│   │   ├── BlogGrid.tsx
│   │   ├── ArticleContent.tsx
│   │   ├── SpacePresentation.tsx
│   │   ├── PricingGrid.tsx
│   │   ├── RegistrationForm.tsx
│   │   ├── SurveySelector.tsx
│   │   ├── ActiveSurveyForm.tsx
│   │   ├── ContactForm.tsx
│   │   └── ContactInfo.tsx
│   ├── components/                  # Reusable components
│   │   ├── layout/
│   │   │   ├── Header.tsx
│   │   │   ├── MobileMenu.tsx
│   │   │   ├── Footer.tsx
│   │   │   ├── PageHeader.tsx
│   │   │   └── Layout.tsx
│   │   ├── ui/                      # Custom UI components + shadcn overrides
│   │   │   ├── Button.tsx
│   │   │   ├── SectionTitle.tsx
│   │   │   ├── ServiceCard.tsx
│   │   │   ├── BlogCard.tsx
│   │   │   ├── DocumentCard.tsx
│   │   │   ├── TestimonialCard.tsx
│   │   │   ├── TeamCard.tsx
│   │   │   ├── PricingCard.tsx
│   │   │   ├── SurveyCard.tsx
│   │   │   ├── FormInput.tsx
│   │   │   ├── FormSelect.tsx
│   │   │   ├── FormTextarea.tsx
│   │   │   ├── LanguageSwitcher.tsx
│   │   │   ├── PurchaseModal.tsx
│   │   │   ├── TestimonialSlider.tsx
│   │   │   └── ParticleCanvas.tsx
│   │   └── animations/
│   │       ├── CharacterReveal.tsx
│   │       ├── LineReveal.tsx
│   │       ├── FadeUp.tsx
│   │       └── CounterAnimation.tsx
│   ├── hooks/                       # Custom React hooks
│   │   ├── useScrollHeader.ts       # Header transparent/solid state
│   │   ├── useMediaQuery.ts         # Responsive breakpoint detection
│   │   ├── useScrollTrigger.ts      # GSAP ScrollTrigger setup/cleanup
│   │   └── useReducedMotion.ts      # prefers-reduced-motion detection
│   ├── lib/
│   │   ├── utils.ts                 # cn() helper, shadcn utils
│   │   ├── i18n.ts                  # i18next configuration + resource imports
│   │   └── emailjs.ts               # EmailJS initialization + send function
│   ├── data/                        # Static data files
│   │   ├── services.ts              # 6 services with full details
│   │   ├── blog.ts                  # 6 blog articles with content
│   │   ├── testimonials.ts          # 3 client testimonials
│   │   ├── documentation.ts         # 8 documents with pricing
│   │   ├── team.ts                  # 3 team members
│   │   ├── solutions.ts             # 4 digital solutions
│   │   └── surveys.ts              # 5 survey form schemas + fields
│   └── types/                       # TypeScript type definitions
│       ├── index.ts
│       ├── service.ts
│       ├── blog.ts
│       ├── form.ts
│       └── survey.ts
├── index.html                       # HTML entry with Google Fonts link
├── vite.config.ts                   # Vite config
├── tailwind.config.js               # Tailwind config with custom colors/fonts
├── tsconfig.json                    # TypeScript config
├── tsconfig.app.json                # App-specific TS config
├── postcss.config.js               # PostCSS config
├── components.json                  # shadcn/ui configuration
└── package.json
```

---

## 7. Tailwind Configuration

### Custom Theme Extensions

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#5C0F8B',
          dark: '#3D0A5E',
          light: '#7B3FA0',
          tint: 'rgba(92, 15, 139, 0.08)',
        },
        secondary: {
          DEFAULT: '#8B1A1A',
          dark: '#6B1414',
          light: '#A83232',
        },
        accent: {
          DEFAULT: '#F5C518',
          dark: '#D4A017',
          tint: 'rgba(245, 197, 24, 0.15)',
        },
        body: '#374151',
        dark: '#1A1A1A',
      },
      fontFamily: {
        display: ['Playfair Display', 'serif'],
        body: ['Inter', 'sans-serif'],
      },
      borderRadius: {
        DEFAULT: '8px',
      },
      boxShadow: {
        card: '0 4px 20px rgba(0,0,0,0.12)',
        'card-hover': '0 12px 40px rgba(0,0,0,0.1)',
        header: '0 2px 20px rgba(0,0,0,0.15)',
        dropdown: '0 8px 24px rgba(0,0,0,0.15)',
      },
      transitionTimingFunction: {
        smooth: 'cubic-bezier(0.22, 0.61, 0.36, 1)',
        bounce: 'cubic-bezier(0.34, 1.56, 0.64, 1)',
      },
    },
  },
};
```

### CSS Variables (`src/index.css`)

```css
:root {
  --color-primary: #5C0F8B;
  --color-primary-dark: #3D0A5E;
  --color-primary-light: #7B3FA0;
  --color-secondary: #8B1A1A;
  --color-secondary-dark: #6B1414;
  --color-accent: #F5C518;
  --color-accent-dark: #D4A017;
  --color-white: #FFFFFF;
  --color-bg-light: #F9F9F9;
  --color-text: #1A1A1A;
  --color-text-muted: #6B7280;
  --font-display: 'Playfair Display', serif;
  --font-body: 'Inter', sans-serif;
  --shadow-md: 0 4px 20px rgba(0,0,0,0.12);
  --transition: all 0.3s ease;
}
```

---

## 8. Routing Table

| Route | Component | Data Source |
|-------|-----------|-------------|
| `/` | `Home` | Static + data files |
| `/a-propos` | `About` | Static + data files |
| `/services` | `Services` | `data/services.ts` |
| `/services/:slug` | `ServiceDetail` | `data/services.ts` (filtered by slug) |
| `/solutions` | `Solutions` | `data/solutions.ts` |
| `/documentation` | `Documentation` | `data/documentation.ts` |
| `/blog` | `Blog` | `data/blog.ts` |
| `/blog/:slug` | `BlogPost` | `data/blog.ts` (filtered by slug) |
| `/rendez-vous` | `Appointment` | Static form |
| `/co-working` | `Coworking` | Static + form |
| `/sondages` | `Surveys` | `data/surveys.ts` |
| `/contact` | `Contact` | Static form + info |
| `*` | Redirect to `/` | — |

---

## 9. Data Architecture

### 9.1 Data Files (TypeScript with typed exports)

| File | Content | Type |
|------|---------|------|
| `data/services.ts` | 6 services with slug, icon, title, description, features, problematics, value, process | `Service[]` |
| `data/blog.ts` | 6 articles with slug, category, title, author, date, readTime, image, content | `Article[]` |
| `data/testimonials.ts` | 3 testimonials with quote, author, role, rating | `Testimonial[]` |
| `data/documentation.ts` | 8 documents with id, type, title, description, price | `Document[]` |
| `data/team.ts` | 3 members with photo, name, role, bio | `TeamMember[]` |
| `data/solutions.ts` | 4 solutions with icon, title, description, features, status | `Solution[]` |
| `data/surveys.ts` | 5 survey schemas with fields, validation, labels | `SurveySchema[]` |

### 9.2 Internationalization Files (JSON)

| File | Content |
|------|---------|
| `locales/fr/common.json` | Navigation, buttons, form labels, footer, shared UI |
| `locales/fr/home.json` | Hero, stats, services preview, value prop, testimonials, blog preview, CTA |
| `locales/fr/pages.json` | About, Services, Solutions, Documentation, Blog, Appointment, Co-working, Surveys, Contact |
| Same for `en/` and `es/` | Translated versions of above |

---

## 10. Performance Considerations

### Animation Performance
- All scroll animations use `transform` and `opacity` only (GPU-composited)
- `will-change: transform, opacity` on elements with scroll-triggered animations
- GSAP ScrollTrigger uses `requestAnimationFrame` internally
- Reduce animation complexity on mobile (<768px): shorter durations, fewer stagger steps
- Honor `prefers-reduced-motion`: disable particle canvas, character reveal, parallax; keep simple fade-ins

### Image Optimization
- Hero background: compressed JPG/WebP, 1920px wide
- Blog/team images: lazy-loaded via `loading="lazy"`, WebP format where possible
- All images: appropriate sizing for their display size (no oversized images)

### Code Splitting
- Route-based code splitting via `React.lazy()` + `Suspense` for all page components
- Shared components (Header, Footer, Layout) loaded eagerly
- Animation libraries: GSAP tree-shakes unused plugins

### EmailJS
- Initialize once in `lib/emailjs.ts` with `emailjs.init(publicKey)`
- Use `emailjs.send(serviceId, templateId, templateParams)` for all form submissions
- Template parameters include: form type, user info, message, timestamp

---

## 11. Accessibility Checklist

- **Keyboard navigation**: All interactive elements reachable via Tab
- **Focus states**: Visible gold (`#F5C518`) outline on all focusable elements
- **ARIA labels**: Header navigation, mobile menu toggle, language switcher, form errors
- **Semantic HTML**: `<header>`, `<nav>`, `<main>`, `<section>`, `<article>`, `<footer>` throughout
- **Alt text**: All images have descriptive `alt` attributes
- **Color contrast**: White on violet/maroon passes WCAG AA; dark gray on white passes AAA
- **Language attribute**: `<html lang>` updates on language switch (fr/en/es)
- **Reduced motion**: Respects `prefers-reduced-motion` for all animations
- **Form labels**: All inputs have visible labels + programmatic association
- **Error messages**: Form errors announced via `aria-describedby` + live regions
