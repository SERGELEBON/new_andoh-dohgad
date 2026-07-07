# 🔍 DIAGNOSTIC : Problème de Changement de Langue

## Symptôme
Quand on change la langue en anglais ou espagnol, le site ne fonctionne plus correctement.

## Causes Identifiées

### 1. **Données statiques non traduites**
Les fichiers dans `src/data/` (services.ts, blog.ts, etc.) contiennent du texte en dur en français :

```typescript
// src/data/services.ts
export const services = [
  {
    title: "Consulting Stratégique", // ❌ En dur en français
    description: "Accompagnement...",
  }
];
```

**Problème** : Ces données ne changent pas quand on switch de langue.

### 2. **Pages qui n'utilisent pas i18n**
Certaines pages affichent directement les données statiques sans passer par `useTranslation()` :

```tsx
// Page Services
import { services } from '@/data/services'; // ❌ Données statiques

function Services() {
  return (
    <div>
      {services.map(s => <h3>{s.title}</h3>)} {/* ❌ Toujours en français */}
    </div>
  );
}
```

### 3. **Traductions incomplètes**
Même si i18n est utilisé, certaines clés manquent en EN/ES :

```typescript
// i18n.ts
fr: { home: { ctaTitle: "..." } }  // ✅ Existe
en: { home: { /* ctaTitle manquant */ } }  // ❌ Manque
```

## Solutions

### ✅ Solution Temporaire (Appliquée)

**Fichier modifié** : `src/lib/i18n.ts`

Configuration ajoutée pour éviter les crashes :
```typescript
fallbackLng: "fr",  // Utiliser FR si traduction manquante
returnNull: false,  // Ne jamais retourner null
returnEmptyString: false,
missingKeyHandler: (lng, ns, key) => {
  console.warn(`Missing translation: ${lng}.${ns}.${key}`);
}
```

**Résultat** : Le site ne crashe plus, mais affiche du français quand la traduction manque.

### 🔧 Solution Complète (À Faire)

#### Étape 1 : Remplacer les données statiques par des données dynamiques

**Avant** (données statiques) :
```typescript
// src/data/services.ts
export const services = [
  { title: "Consulting Stratégique", ... }
];

// Page qui utilise
import { services } from '@/data/services';
```

**Après** (données dynamiques de Supabase) :
```typescript
// Hook qui charge depuis Supabase
import { useServices } from '@/hooks/useDynamicContent';

function Services() {
  const { data: services } = useServices();
  const { i18n } = useTranslation();
  
  return (
    <div>
      {services.map(s => (
        <h3>{s[`title_${i18n.language}`]}</h3> // title_fr, title_en, title_es
      ))}
    </div>
  );
}
```

#### Étape 2 : Ajouter les traductions manquantes

Compléter `src/lib/i18n.ts` avec toutes les clés pour EN et ES :

```typescript
fr: {
  translation: {
    services: {
      title: "Nos Services",
      subtitle: "...",
      // ... toutes les clés
    }
  }
},
en: {
  translation: {
    services: {
      title: "Our Services",  // ✅ Ajouter
      subtitle: "...",         // ✅ Ajouter
      // ... toutes les clés
    }
  }
}
```

#### Étape 3 : Pages à migrer vers données dynamiques

1. **src/pages/Services.tsx** → Utiliser `useServices()` au lieu de `import { services }`
2. **src/pages/Blog.tsx** → Utiliser `useBlogPosts()` au lieu de `import { blogPosts }`
3. **src/pages/About.tsx** → Utiliser `useTeamMembers()` + `useTestimonials()`
4. **src/pages/Documentation.tsx** → Utiliser `useDocumentation()`
5. **src/pages/Home.tsx** → Utiliser `useSiteStats()` + `usePartners()`

## Tests

### Test 1 : Vérifier les clés manquantes
1. Ouvrir la console navigateur (F12)
2. Changer la langue en anglais
3. Regarder les warnings `[i18n] Missing translation: ...`
4. Noter toutes les clés manquantes

### Test 2 : Vérifier les pages qui cassent
1. Français → Naviguer sur toutes les pages → ✅ OK
2. Anglais → Naviguer sur toutes les pages → ❓ Noter les problèmes
3. Espagnol → Naviguer sur toutes les pages → ❓ Noter les problèmes

## Commandes SQL Utiles

### Vérifier les tables multilingues
```sql
-- Services
SELECT slug, title_fr, title_en, title_es FROM services;

-- Blog
SELECT slug, title_fr, title_en, title_es FROM blog_posts;

-- Team
SELECT name, role_fr, role_en, role_es FROM team_members;
```

## État Actuel

- ✅ **i18n.ts configuré** pour ne pas crasher
- ✅ **Fallback FR** activé
- ❌ **Données statiques** encore utilisées
- ❌ **Traductions incomplètes** en EN/ES
- ⏳ **Migration vers données dynamiques** en cours

## Prochaines Actions

1. **Exécuter** `SQL_TABLES_FRONTEND_DYNAMIQUE.sql` si pas encore fait
2. **Exécuter** `SQL_DISABLE_RLS_PROFILES.sql` pour voir tous les users
3. **Migrer** les pages pour utiliser les hooks dynamiques
4. **Compléter** les traductions EN/ES dans i18n.ts
5. **Tester** chaque page dans les 3 langues

## Debugging

### Console Navigateur
```javascript
// Vérifier la langue actuelle
console.log('Current language:', i18n.language);

// Vérifier si une clé existe
console.log('Key exists:', i18n.exists('services.title'));

// Forcer une langue
i18n.changeLanguage('en');

// Voir toutes les traductions chargées
console.log('Translations:', i18n.store.data);
```

### LocalStorage
```javascript
// Voir la langue sauvegardée
console.log('Saved language:', localStorage.getItem('i18nextLng'));

// Réinitialiser
localStorage.removeItem('i18nextLng');
location.reload();
```
