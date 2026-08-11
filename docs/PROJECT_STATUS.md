# Project Status

> AI-readable save point for the project. Update this file only after a milestone passes its Definition of Done.

## Current Milestone

**02 — Onboarding & Profile**

## Milestones

- [x] 01 Foundation
- [ ] 02 Onboarding & Profile
- [ ] 03 Smoking Log & Triggers
- [ ] 04 Craving SOS
- [ ] 05 Quit Plan & Slip Handling
- [ ] 06 Insights & Journey
- [ ] 07 Notifications, Settings & Export
- [ ] 08 Polish, Accessibility & Testing

## Stable Product Decisions

- Flutter + Dart
- Riverpod
- Drift + SQLite
- go_router
- Offline-first
- No account/login for MVP
- No analytics/tracking SDK for MVP
- No backend/cloud sync for MVP
- Feature-first architecture
- Calm, non-judgmental cessation UX
- One smoking slip must not erase lifetime progress

## Current Architecture

```text
lib/
├── app/
│   ├── app.dart
│   ├── router/
│   └── theme/
├── core/
│   ├── database/
│   └── widgets/
└── features/
    └── foundation/
        └── presentation/
```

The root route renders the Foundation screen. Future product features should be
added as feature-first modules without changing the established app shell.

## Database Migrations

Schema version 1 creates `app_metadata`, a minimal local table that verifies
the Drift/SQLite connection. Product tables are intentionally deferred until
their owning milestones.

## Important Implementation Decisions

- Brand name: **Serenity** (`serenity-app` repository; `serenity_app` Dart
  package).
- Brand principle: **Small Efforts Restore Ease; New Intentions Transform You.**
- Theme uses a muted sage accent (`#5C7C67`) and supports system light/dark
  mode.
- Riverpod provides application dependencies; `appDatabaseProvider` owns and
  disposes the local Drift database.
- Router has only the Foundation route. Do not add onboarding or product routes
  until their milestones are active.

## Known Issues

The initial app screen is a Foundation placeholder, not the eventual Home or
Onboarding flow. This is intentional to respect milestone scope.

## Next Agent Instructions

1. Read `docs/APP_SPEC.md`.
2. Read this file.
3. Read `docs/milestones/02_ONBOARDING.md` completely.
4. Inspect the Foundation implementation before editing.
5. Work only on Milestone 02.
6. Run formatter, analyzer, and tests before marking anything complete.
