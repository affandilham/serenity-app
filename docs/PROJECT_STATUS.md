# Project Status

> AI-readable save point for the project. Update this file only after a milestone passes its Definition of Done.

## Current Milestone

**03 — Smoking Log & Triggers**

## Milestones

- [x] 01 Foundation
- [x] 02 Onboarding & Profile
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
    ├── foundation/
    │   └── presentation/
    └── onboarding/
        ├── data/
        ├── domain/
        └── presentation/
```

The root route is an onboarding gate: a fresh installation shows the five-step
onboarding flow, while a completed local profile shows its saved completion
state. Future product features should be added as feature-first modules without
changing the established app shell.

## Database Migrations

Schema version 1 creates `app_metadata`, a minimal local table that verifies
the Drift/SQLite connection. Product tables are intentionally deferred until
their owning milestones.

Schema version 2 preserves `app_metadata` and creates `user_profiles` and
`motivations` for onboarding. `user_profiles` stores the required baseline and
goal plus optional pack and first-cigarette details. `motivations` stores the
optional private onboarding reason. A migration test verifies version-1 data is
preserved.

## Important Implementation Decisions

- Brand name: **Serenity** (`serenity-app` repository; `serenity_app` Dart
  package).
- Brand principle: **Small Efforts Restore Ease; New Intentions Transform You.**
- Theme uses a muted sage accent (`#5C7C67`) and supports system light/dark
  mode.
- Riverpod provides application dependencies; `appDatabaseProvider` owns and
  disposes the local Drift database.
- The onboarding repository maps Drift rows to domain models, so presentation
  code has no database coupling. Saving profile and optional motivation data is
  atomic.
- The root router uses a narrow stream provider to determine whether onboarding
  is complete; the onboarding draft and save state are separate providers.

## Known Issues

The post-onboarding completion state is intentionally minimal. The observation
mode Home, smoking timeline, and all logging behaviors belong to Milestone 03.

## Next Agent Instructions

1. Read `docs/APP_SPEC.md`.
2. Read this file.
3. Read `docs/milestones/03_SMOKING_LOG.md` completely.
4. Inspect the Foundation and Onboarding implementations before editing.
5. Work only on Milestone 03.
6. Run formatter, analyzer, and tests before marking anything complete.
