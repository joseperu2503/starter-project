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

### 12. Guest mode with Welcome screen
- **Where**: `frontend2/lib/features/auth/presentation/screens/welcome_screen.dart`, `frontend2/lib/features/auth/presentation/bloc/auth_bloc.dart`
- **What**: Users can browse and read articles without creating an account. A Welcome screen offers Sign In, Register, and Continue as Guest. Guests see a read-only home feed with a sign-in banner. Settings (dark mode, language) are accessible from a guest settings sheet.
- **Why**: Reduces onboarding friction — new users can evaluate the content before committing to registration.

### 13. Follow system
- **Where**: `frontend2/lib/features/social/`, `backend/firestore.rules`
- **What**: Authenticated users can follow/unfollow other authors. Author profile screen shows follower count and a follow button. Follows are stored in a `follows` Firestore collection with optimistic UI updates.
- **Why**: Adds a social layer that enables personalized feeds and author discovery.

### 14. Push notifications for new articles
- **Where**: `backend/functions/index.js`, `frontend2/lib/core/services/notification_service.dart`
- **What**: Firebase Cloud Function (2nd gen) triggers on new published article creation in Firestore. Queries the author's followers, fetches their FCM tokens from the `users` collection, and sends a multicast push notification.
- **Why**: Drives re-engagement — followers are notified in real time when authors they follow publish new content.

### 15. Likes and comments
- **Where**: `frontend2/lib/features/articles/presentation/screens/article_detail_screen.dart`, `frontend2/lib/features/articles/data/data_sources/remote/firestore_interaction_data_source.dart`
- **What**: Authenticated users can like articles (with optimistic toggle) and post/delete comments. Like count, comment list, and a comment input are shown at the bottom of the article detail screen. Guests see counts but cannot interact.
- **Why**: Core engagement mechanics for any content platform. Demonstrates subcollection design, optimistic UI, and role-based interaction.

### 16. Google Sign-In
- **Where**: `frontend2/lib/features/auth/`, `frontend2/lib/features/auth/presentation/widgets/google_sign_in_button.dart`
- **What**: One-tap Google authentication available on the Welcome screen and Login screen. Uses `google_sign_in` + `FirebaseAuth.signInWithCredential`. On sign-in, `GoogleSignIn.signOut()` is also called on logout to clear the Google session.
- **Why**: Reduces sign-up friction significantly — most users prefer OAuth over email/password flows.

### 17. Category master list from Firestore
- **Where**: `frontend2/lib/features/articles/data/data_sources/remote/firestore_category_data_source.dart`, `frontend2/lib/features/articles/presentation/screens/upload_article_screen.dart`
- **What**: Categories are stored in a `categories` Firestore collection (managed via Firebase Console). The article form loads them dynamically and presents a dropdown selector instead of a free-text field.
- **Why**: Ensures consistent categorization across all articles — no typos or inconsistent tags. Categories can be updated server-side without a new app release.

### 18. Real-time article search
- **Where**: `frontend2/lib/features/articles/presentation/screens/home_screen.dart`
- **What**: A search bar in the home screen filters articles in real time by title, category, and author name. Filtering is client-side on the already-loaded list — no extra Firestore queries. A clear button resets the search.
- **Why**: Essential discoverability feature for any content app. Client-side filtering is instant and cost-free.

### 19. Article view tracking
- **Where**: `frontend2/lib/features/articles/data/data_sources/remote/firestore_interaction_data_source.dart`, `frontend2/lib/features/articles/presentation/bloc/interaction/interaction_bloc.dart`
- **What**: Each article detail open registers a unique view in a `views/{userId}` subcollection. The author's own views are excluded. View count is displayed alongside likes and comments in the article detail screen.
- **Why**: Provides engagement data per article. Unique-per-user counting prevents view inflation and enables future ranking/trending features.

### 20. A/B Testing with Firebase Remote Config & Analytics
- **Where**: `frontend2/lib/core/services/remote_config_service.dart`, `frontend2/lib/core/services/analytics_service.dart`, `frontend2/lib/features/articles/presentation/widgets/article_card.dart`
- **What**: Remote Config parameter `article_card_style` controls whether the home feed renders as a compact list (`list`) or large image cards (`card`). Firebase A/B Testing experiment `article_card_style_test_android` splits users 50/50. Every article open fires an `article_opened` Analytics event with `card_style`, `article_id`, and `category` parameters for measuring CTR per variant.
- **Why**: Demonstrates production-grade experimentation infrastructure. Allows data-driven UI decisions without shipping a new app version.

### 21. Premium articles with paywall gate
- **Where**: `frontend2/lib/features/articles/domain/entities/article_entity.dart`, `frontend2/lib/features/articles/presentation/screens/article_detail_screen.dart`, `frontend2/lib/features/articles/presentation/screens/upload_article_screen.dart`
- **What**: Articles can be marked as premium via an `isPremium` toggle in the upload form. When a user opens a premium article, a non-dismissible modal bottom sheet blocks the content and prompts subscription. The sheet cannot be bypassed — closing it (via "Subscribe" or "Maybe later") navigates back to the feed. A gold PREMIUM badge is shown on the article header.
- **Why**: Simulates a real monetization gate. Demonstrates conditional navigation flow, non-dismissible modals, and field-level content access control.

### 22. Premium remarketing A/B test
- **Where**: `frontend2/lib/core/services/remote_config_service.dart`, `frontend2/lib/core/services/analytics_service.dart`, `frontend2/lib/features/articles/presentation/screens/article_detail_screen.dart`
- **What**: Remote Config parameter `premium_remarketing_offer` controls a second-chance offer shown after a user dismisses the paywall with "Maybe later". Control group sees nothing; treatment group sees a discount offer sheet (e.g. 20% off first month) with a green CTA. Four Analytics events track the full funnel: `premium_paywall_shown`, `premium_dismissed`, `premium_remarketing_shown`, `premium_subscribe_tapped` (with `source` and `offer` parameters). The true business metric is `purchase` revenue, measurable via RevenueCat when real payments are integrated.
- **Why**: Models a real revenue optimization experiment. Demonstrates multi-step funnel tracking, parametric offer configuration, and the connection between behavioral Analytics events and business outcomes.

---

## Ideas (not yet implemented)

- Article versioning with edit history stored in Firestore subcollections
- Admin role via Firebase custom claims to moderate/unpublish articles
- Trending screen — articles ranked by `viewCount` from Firestore
- Personalized feed — articles only from followed authors
- CI/CD with GitHub Actions for automated `flutter test` and `firebase deploy`
- Flutter Web dashboard for desktop article management
- RevenueCat integration for real subscription payments tied to the remarketing A/B test
