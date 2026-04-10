# Project Report — Newsly
**Author:** Jose Perez  
**Date:** April 2026

---

## 1. Introduction

Coming into this project, I felt confident. With 5 years of programming experience and prior exposure to Flutter, Firebase, and BLoC, the stack was familiar territory. My background is primarily in backend development using NestJS and Laravel with PostgreSQL, so the frontend-heavy nature of this project was a good challenge to lean into.

What excited me most was the Clean Architecture requirement — it closely mirrors patterns I've applied in production projects, which meant I could focus on execution quality rather than spending time figuring out structure.

---

## 2. Learning Journey

Most of the technologies involved were already part of my toolkit:

- **Flutter & BLoC** — I had worked with both before, so implementing the presentation layer and state management felt natural.
- **Firebase Auth & Storage** — also familiar from previous projects.
- **Clean Architecture** — the separation of domain, data, and presentation layers is something I've applied in backend contexts and adapted here for Flutter.

The main area of learning was **Firebase Firestore** as a primary data store. My previous database experience is centered around relational databases (PostgreSQL via NestJS/Laravel), so designing a NoSQL schema and thinking in terms of collections, documents, and composite indexes was a shift in mindset.

Additional learning that emerged during overdelivery:

- **Firebase Cloud Messaging (FCM)** — integrating push notifications end-to-end, from requesting permissions on the device to sending multicast messages via a Cloud Function.
- **Firebase Cloud Functions (2nd gen)** — writing and deploying event-driven serverless functions triggered by Firestore document creation, including IAM permission propagation for Eventarc.
- **Flutter Localizations** — setting up the `flutter_localizations` + `.arb` file pipeline for full i18n support, including locale persistence and auto-detection.

Resources used:
- Official Firebase, Flutter, and Cloud Functions documentation
- Claude (AI assistant) for architecture decisions and debugging
- Prior experience from personal and professional projects

---

## 3. Challenges Faced

**Firebase Firestore as a NoSQL database**  
The biggest challenge was adapting to Firestore's document model coming from a relational database background. Specific pain points:

- **Composite indexes**: Queries combining `where` and `orderBy` on different fields require explicit composite indexes in Firestore. This was not obvious initially and caused runtime errors that required adding `firestore.indexes.json`.
- **Named database**: The project used a named Firestore database (`newsly`) instead of the default `(default)` instance. The Flutter SDK requires explicitly passing the `databaseId` when initializing `FirebaseFirestore`, which took some debugging to identify.
- **Dependency conflicts**: Setting up the Flutter project from scratch with modern package versions (Dart 3.x) led to several version incompatibilities between packages like `hive_generator`, `drift`, and `build_runner`. Resolved by switching to `drift` + `drift_flutter` which are fully Dart 3 compatible.

**iOS deployment target**  
Firebase packages require a minimum iOS deployment target of 15.0. The default Flutter project targets 13.0, which caused a pod install failure. Fixed by updating the `Podfile`.

**Cloud Functions — Eventarc IAM propagation**  
Deploying a 2nd gen Cloud Function for the first time required the Eventarc Service Agent role to be assigned manually via `gcloud`. The Firebase CLI reported a permission error on first deploy and instructed to retry, but the issue only resolved after explicitly granting the IAM binding — a non-obvious step not documented in the Firebase quickstart.

**Global navigation with BLoC**  
Handling sign-out and guest-mode navigation required a `GlobalKey<NavigatorState>` placed above the `MaterialApp`, with a `BlocListener<AuthBloc>` that calls `pushAndRemoveUntil` on state changes. The challenge was that the standard approach of rebuilding `home` via `BlocBuilder` does not clear the navigator stack, leaving stale screens on top.

---

## 4. Reflection and Future Directions

**What I learned:**  
Working with Firestore reinforced the importance of thinking about data access patterns before designing a schema — in relational databases, you normalize first and query later; in Firestore, you design around your queries first.

The project also reinforced the value of Clean Architecture in keeping concerns separated. Having the domain layer completely independent from Firebase meant that swapping Firestore for a different backend would only require changes in the data layer.

Building the follow system and push notifications end-to-end — from Firestore `follows` collection to FCM multicast — gave me a concrete understanding of how social features are architected in production mobile apps.

**Future improvements I would make:**

- **AI-powered related articles**: Use Vertex AI text embeddings stored as Firestore vector fields and query with `findNearest` (Firestore Vector Search) to surface semantically similar articles at the bottom of each article detail screen.
- **Pagination**: Implement cursor-based pagination using Firestore's `startAfterDocument` to handle large article feeds efficiently.
- **Rich text editor**: Replace the plain text content field with a Markdown or rich text editor so journalists can format their articles properly.
- **Google / Apple Sign-In**: Add OAuth providers for a smoother onboarding experience.
- **Image compression**: Compress thumbnails client-side before uploading to Firebase Storage to reduce bandwidth and storage costs.
- **Comments**: Add a `comments` subcollection per article with real-time updates via Firestore snapshots.
- **Article versioning**: Preserve edit history in Firestore subcollections so authors can revert changes.
- **Admin role**: Firebase custom claims to allow moderators to unpublish articles.
- **CI/CD**: GitHub Actions pipeline for automated `flutter test` and `firebase deploy` on every push.

---

## 5. Proof of the Project

> Screenshots and screen recordings of the final app are located in `docs/screenshots/`.

Key screens implemented:

- **Welcome** — Branding screen with Sign In, Register, and Continue as Guest options
- **Login & Register** — Email/password authentication via Firebase Auth
- **Home (authenticated)** — Published articles feed with bookmark toggle, pull-to-refresh, and access to all journalist tools
- **Home (guest)** — Read-only feed with a banner prompting sign-in and a settings sheet for dark mode and language
- **Article Detail** — Full article view with hero image, bookmark action, and tappable author name
- **Author Profile** — Public author profile with follower count and follow/unfollow button
- **Write / Edit Article** — Form to create and publish articles with thumbnail upload to Firebase Storage, draft support
- **My Articles** — Journalist's own articles with edit and delete actions
- **Saved Articles** — Locally bookmarked articles stored with Drift (SQLite), accessible offline
- **Profile** — Account management: personal info, change password, dark mode toggle, language selector, sign out
- **Language** — Manual language selection (English / Español) with auto-detection on first launch

---

## 6. Overdelivery

### New Features Implemented

**1. Draft support (`isPublished` flag)**  
Articles can be saved as drafts before publishing. The "Publish immediately" toggle in the upload form controls visibility. Drafts are only readable by their author via Firestore security rules — not exposed in the public feed.

**2. Article categories**  
An optional `category` field was added to the schema. Categories are displayed as colored accent tags on article tiles and the detail screen, enabling future filtering by topic.

**3. Saved Articles — offline bookmarks**  
Users can bookmark any article for offline reading. Saved articles are persisted locally using Drift (SQLite), completely independent of Firestore. They remain accessible without internet connectivity.

**4. Author auto-population**  
The article upload form automatically reads `displayName` and `uid` from the authenticated `AuthBloc` state — no manual author input. This prevents spoofing and ensures data integrity at the form level.

**5. Composite Firestore indexes**  
Explicit composite indexes defined in `firestore.indexes.json` for the two main query patterns:
- `isPublished ASC + publishedAt DESC` — home feed
- `authorId ASC + publishedAt DESC` — my articles

**6. Firebase Storage security rules**  
Storage rules restricting uploads to authenticated users, capped at 5MB, images only (`image/*` content type).

**7. Dark mode with adaptive theming**  
Full dark mode support across every screen. A `ThemeCubit` persists the preference with `shared_preferences`. All UI components use `Theme.of(context).colorScheme` — no hardcoded colors — so cards, text, and backgrounds adapt correctly in both modes.

**8. Profile screen with account management**  
Dedicated profile screen with user header (avatar, name, email), Personal Information, Change Password (with Firebase re-authentication), Dark Mode toggle, Language selector, and Sign Out with confirmation dialog.

**9. Internationalization — English & Spanish**  
Full i18n using `flutter_localizations` with generated `.arb` files. Every UI string in every screen is localized. A `LocaleCubit` persists the selected language with `shared_preferences`. On first launch, the app auto-detects the device locale — if `es` or `en`, it is applied automatically; otherwise defaults to English.

**10. Language selection screen**  
Accessible from Profile, allows manual switching between English and Español. Current selection is highlighted with a checkmark. Change takes effect immediately across the entire app.

**11. Guest mode with Welcome screen**  
A `WelcomeScreen` is shown before login with three options: Sign In, Register, and Continue as Guest. Guest users get a read-only article feed with a banner prompting sign-in. A settings bottom sheet gives guests access to dark mode and language without requiring an account.

**12. Follow system**  
Users can follow authors from their public profile screen (accessed by tapping the author name in any article). Follow/unfollow uses optimistic UI updates. Follower count is displayed on the author profile and is readable publicly (including by guest users).

**13. Push notifications via Cloud Functions**  
A Firebase Cloud Function (`notifyFollowersOnArticlePublished`, 2nd gen, Node.js 22) triggers on every new published article. It queries the `follows` collection for the author's followers, fetches their FCM tokens from the `users` collection, and sends a multicast push notification via FCM. FCM tokens are saved/refreshed on every login and app start.

**14. Splash screen & launcher icon**  
Custom splash screen with brand colors (`#E94560`) using `flutter_native_splash`. Custom launcher icon with adaptive icon support for Android using `flutter_launcher_icons`.

### Prototypes & Architecture Decisions

**Decision: Fresh Flutter project over the starter skeleton**  
The starter project used outdated dependencies (`floor`, `retrofit`, Dart SDK `<3.0.0`) incompatible with current Firebase packages. Rather than patching legacy code, I created a new Flutter project targeting Dart 3.x and migrated only the relevant architecture and assets. This aligned with the "Truth is King" value — the technically correct choice over the comfortable one.

**Decision: Drift over Floor/Hive**  
`floor` (the starter's local DB) is unmaintained and incompatible with Dart 3. `hive` had generator conflicts with `build_runner ^2.13`. `drift` is the actively maintained successor to floor with full Dart 3 support and a clean type-safe query API.

**Decision: Named Firestore database**  
Used a named Firestore database (`newsly`) instead of the default instance to namespace the project's data cleanly, following Firebase best practices for multi-environment setups.

**Decision: GlobalKey navigator for auth state navigation**  
Rather than rebuilding `home` in `MaterialApp` on auth state changes (which doesn't clear the navigator stack), a `GlobalKey<NavigatorState>` combined with a top-level `BlocListener<AuthBloc>` handles all auth-driven navigation with `pushAndRemoveUntil`. This ensures a clean stack regardless of which screen the user is on when they sign out or enter guest mode.

**Decision: Optimistic UI for follow/unfollow**  
The `SocialBloc` applies the follow state change immediately on tap and reverts only if the Firestore write fails. This eliminates perceived latency for a social interaction that should feel instant.

### How This Could Be Improved Further

- **Vertex AI + Firestore Vector Search**: Generate text embeddings for each article on publish (via Cloud Function) and use Firestore's `findNearest` for semantic "related articles" recommendations — no third-party search service required.
- **Article versioning**: Store edit history in a `versions` subcollection so authors can review and revert changes.
- **Likes / reactions**: A counter field with a `likes` subcollection, similar to the follow system, to add engagement metrics to the feed.
- **Comments**: Real-time `comments` subcollection per article with Firestore snapshots.
- **Flutter Web dashboard**: A desktop-optimized interface for journalists to manage their article catalog, leveraging the same Clean Architecture data layer.
- **CI/CD with GitHub Actions**: Automate `flutter test`, `flutter analyze`, and `firebase deploy` on every push to main.

---

## 7. Extra Notes

**Package choices summary:**

| Purpose | Package | Reason |
|---|---|---|
| State management | `flutter_bloc ^9` | Mature, well-documented, team-friendly |
| Dependency injection | `get_it ^9` | Lightweight service locator, no code gen |
| Local database | `drift ^2.32` | Dart 3 compatible successor to floor |
| Image caching | `cached_network_image` | Standard for network images in Flutter |
| Image picking | `image_picker` | Official Flutter team plugin |
| ID generation | `uuid` | RFC-compliant UUIDs for Firestore document IDs |
| Push notifications | `firebase_messaging ^16` | Official FCM Flutter plugin |
| Internationalization | `flutter_localizations` (SDK) | Built-in, zero overhead, `.arb` based |
| Splash screen | `flutter_native_splash ^2` | Generates native splash for iOS + Android |
| Launcher icon | `flutter_launcher_icons ^0.14` | Generates adaptive icons for all densities |

**Repository structure follows Symmetry's Clean Architecture spec:**
```
lib/
├── config/
│   ├── locale/     # LocaleCubit — language persistence & auto-detection
│   ├── routes/     # AppRoutes
│   └── theme/      # AppTheme, ThemeCubit
├── core/
│   ├── services/   # NotificationService (FCM)
│   └── usecase/    # UseCase base class, NoParams
└── features/
    ├── articles/   # Full clean folder: data / domain / presentation
    ├── auth/       # Full clean folder: data / domain / presentation
    └── social/     # Follow system + SocialBloc + AuthorProfileScreen
```

**Cloud Function deployed:**
- `notifyFollowersOnArticlePublished` — 2nd gen, Node.js 22, `us-central1`
- Trigger: `onDocumentCreated` on `articles/{articleId}` in the `newsly` database
- Source: `backend/functions/index.js`
