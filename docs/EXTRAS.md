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

*(entries will be added here as we build)*

---

## Ideas (not yet implemented)

*(feature ideas worth suggesting in the report go here)*
