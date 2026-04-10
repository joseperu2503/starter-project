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

Resources used:
- Official Firebase and Flutter documentation
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

---

## 4. Reflection and Future Directions

**What I learned:**  
Working with Firestore reinforced the importance of thinking about data access patterns before designing a schema — in relational databases, you normalize first and query later; in Firestore, you design around your queries first.

The project also reinforced the value of Clean Architecture in keeping concerns separated. Having the domain layer completely independent from Firebase meant that swapping Firestore for a different backend would only require changes in the data layer.

**Future improvements I would make:**

- **Firebase Authentication providers**: Add Google and Apple Sign-In for a smoother onboarding experience.
- **Pagination**: Implement cursor-based pagination for the articles list using Firestore's `startAfterDocument` to handle large datasets efficiently.
- **Rich text editor**: Replace the plain text content field with a Markdown or rich text editor so journalists can format their articles properly.
- **Push notifications**: Notify users when a new article is published using Firebase Cloud Messaging.
- **Search**: Implement full-text search using Algolia or Firestore's array-contains queries for category filtering.
- **Image compression**: Compress thumbnails client-side before uploading to Firebase Storage to reduce bandwidth and storage costs.

---

## 5. Proof of the Project

> Screenshots and screen recordings of the final app are located in `docs/screenshots/`.

Key screens implemented:
- **Login & Register** — Email/password authentication via Firebase Auth
- **Home** — Published articles feed with bookmark toggle and pull-to-refresh
- **Article Detail** — Full article view with hero image and bookmark action
- **Write Article** — Form to create and publish articles with thumbnail upload to Firebase Storage
- **My Articles** — Journalist's own articles with edit and delete actions
- **Saved Articles** — Locally bookmarked articles stored with Drift (SQLite)

---

## 6. Overdelivery

### New Features Implemented

**1. Draft support (`isPublished` flag)**  
Articles can be saved as drafts before publishing. The toggle "Publish immediately" in the upload form controls visibility. Drafts are only readable by their author via Firestore security rules.

**2. Article categories**  
An optional `category` field was added to the schema. Categories are displayed as colored tags on article tiles and the detail screen, enabling future filtering by topic.

**3. Saved Articles (offline bookmarks)**  
Users can bookmark any article for offline reading. Saved articles are persisted locally using Drift (SQLite) — completely independent of Firestore, so they remain accessible without internet.

**4. Author auto-population**  
The article upload form automatically uses the authenticated user's display name and UID as the author — no manual input required. This prevents spoofing and ensures data integrity.

**5. Composite Firestore indexes**  
Defined explicit composite indexes in `firestore.indexes.json` for the two main query patterns:
- `isPublished ASC + publishedAt DESC` (home feed)
- `authorId ASC + publishedAt DESC` (my articles)

**6. Storage security rules**  
Wrote explicit Firebase Storage rules restricting uploads to authenticated users, limiting file size to 5MB and content type to images only.

### Prototypes & Architecture Decisions

**Decision: Fresh Flutter project over the starter skeleton**  
The starter project used outdated dependencies (`floor`, `retrofit`, Dart SDK `<3.0.0`) incompatible with current Firebase packages. Rather than patching legacy code, I created a new Flutter project targeting Dart 3.x and migrated only the relevant architecture and assets. This decision aligned with the "Truth is King" value — the technically correct choice over the comfortable one.

**Decision: Drift over Floor/Hive**  
`floor` (the starter's local DB) is unmaintained and incompatible with Dart 3. `hive` had similar generator conflicts. `drift` is the actively maintained successor to floor with full Dart 3 support and a clean migration path.

**Decision: Named Firestore database**  
Used a named Firestore database (`newsly`) instead of the default instance to namespace the project's data cleanly, following Firebase best practices for multi-environment setups.

### How This Could Be Improved Further

- Implement article versioning so edit history is preserved in Firestore subcollections.
- Add an admin role via Firebase custom claims to allow moderators to unpublish articles.
- Build a web dashboard (Flutter Web) for journalists to manage their articles from a desktop interface.
- Introduce CI/CD with GitHub Actions to automate `flutter test` and `firebase deploy` on every push.

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

**Repository structure follows Symmetry's Clean Architecture spec:**
```
lib/
├── config/         # Theme, routes
├── core/           # Shared abstractions (UseCase, NoParams)
└── features/
    ├── articles/   # Full clean folder: data / domain / presentation
    └── auth/       # Full clean folder: data / domain / presentation
```
