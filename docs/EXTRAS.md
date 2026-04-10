# Extras & Overdelivery Log

This document tracks all additions that go beyond the project requirements.
Each entry explains what was added, why, and where it lives.

---

## Backend

### 1. `category` field in Article schema
- **Where**: `backend/docs/DB_SCHEMA.md`
- **What**: Optional string field to tag articles by topic (e.g., "Technology", "Politics", "Health")
- **Why**: Enables filtering articles by category in the UI — a natural feature for a news app

### 2. `isPublished` field in Article schema + draft support
- **Where**: `backend/docs/DB_SCHEMA.md`, `backend/firestore.rules`
- **What**: Boolean flag that separates published articles from drafts
- **Why**: Allows journalists to save work-in-progress before making it public. Also reflected in Firestore rules (drafts only readable by their author)

---

## Frontend

### 3. Dark mode with adaptive theming
- **Where**: `frontend2/lib/config/theme/app_theme.dart`, `frontend2/lib/config/theme/theme_cubit.dart`
- **What**: Full dark mode support across every screen. Uses `ThemeCubit` (persisted with `shared_preferences`) and `ThemeMode` in `MaterialApp`. All hardcoded colors replaced with `Theme.of(context).colorScheme` values so cards, text, and backgrounds adapt correctly.
- **Why**: Dark mode is a standard user expectation in modern apps. It also demonstrates proper Flutter theming beyond simple color swaps.

### 4. Profile screen with account management
- **Where**: `frontend2/lib/features/auth/presentation/screens/profile_screen.dart`
- **What**: Dedicated profile screen accessible from the home app bar. Includes user header (avatar with initial, name, email), Personal Information, Change Password, Dark Mode toggle, Language selector, and Sign Out with confirmation dialog.
- **Why**: The base requirement only asked for authentication — a profile screen adds a complete account management experience.

### 5. Change Password screen
- **Where**: `frontend2/lib/features/auth/presentation/screens/change_password_screen.dart`
- **What**: Re-authenticates the user with their current password before allowing a change. Uses `FirebaseAuth` re-authentication to meet Firebase's security requirements.
- **Why**: Improves account security and is expected functionality for any app with user accounts.

### 6. Internationalization (i18n) — English & Spanish
- **Where**: `frontend2/lib/l10n/`, `frontend2/lib/config/locale/locale_cubit.dart`
- **What**: Full i18n using `flutter_localizations` and generated `.arb` files. Every UI string in every screen is localized in English and Spanish. Includes a `LocaleCubit` (persisted with `shared_preferences`) and a Language selection screen in Profile.
- **Why**: Multi-language support is a real-world requirement for any production app. Demonstrates proper Flutter i18n architecture — not just hardcoded string replacement.

### 7. Language selection screen with auto-detection
- **Where**: `frontend2/lib/features/auth/presentation/screens/language_screen.dart`
- **What**: Screen accessible from Profile where the user can manually switch between English and Español. On first launch, the app auto-detects the device locale — if it's `es` or `en` it's applied automatically, otherwise defaults to English. Selection persists across sessions.
- **Why**: Auto-detection removes friction on first launch while still giving users manual control.

### 8. Saved Articles (offline bookmarks)
- **Where**: `frontend2/lib/features/articles/`
- **What**: Users can bookmark any article for offline reading. Persisted locally with Drift (SQLite), completely independent of Firestore.
- **Why**: Enables a read-later flow that works without internet — a natural feature for a news reader app.

### 9. Author auto-population on article upload
- **Where**: `frontend2/lib/features/articles/presentation/screens/upload_article_screen.dart`
- **What**: The article form reads `displayName` and `uid` from the authenticated `AuthBloc` state — no manual author input.
- **Why**: Prevents spoofing, ensures data integrity, and improves the upload UX.

### 10. Composite Firestore indexes
- **Where**: `backend/firestore.indexes.json`
- **What**: Explicit composite indexes for `isPublished + publishedAt` (home feed) and `authorId + publishedAt` (my articles).
- **Why**: Required for Firestore queries that combine `where` and `orderBy` on different fields. Without these the queries fail at runtime.

### 11. Firebase Storage security rules
- **Where**: `backend/storage.rules`
- **What**: Rules restricting uploads to authenticated users, max 5MB, images only.
- **Why**: Prevents unauthorized uploads and limits abuse of Storage bandwidth and quota.

---

## Ideas (not yet implemented)

- Article versioning with edit history stored in Firestore subcollections
- Admin role via Firebase custom claims to moderate/unpublish articles
- Push notifications with Firebase Cloud Messaging on new article publish
- Full-text search via Algolia or Firestore array-contains for category filtering
- CI/CD with GitHub Actions for automated `flutter test` and `firebase deploy`
- Flutter Web dashboard for desktop article management
