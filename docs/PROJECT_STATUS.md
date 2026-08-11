# Project Status

> AI-readable save point for the project. Update this file only after a milestone passes its Definition of Done.

## Current Milestone

**05 — Quit Plan & Slip Handling**

## Milestones

- [x] 01 Foundation
- [x] 02 Onboarding & Profile
- [x] 03 Smoking Log & Triggers
- [x] 04 Craving SOS
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
│   ├── time/
│   └── widgets/
└── features/
    ├── foundation/
    │   └── presentation/
    ├── onboarding/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── smoking_log/
        ├── data/
        ├── domain/
        └── presentation/
    └── craving/
        ├── data/
        ├── domain/
        └── presentation/
```

The root route is an onboarding gate: a fresh installation shows the five-step
onboarding flow, while a completed local profile opens the observation-mode
Home. Home composes small reactive consumers for today's count and timeline;
the quick-log sheet is a separate feature widget.

## Database Migrations

Schema version 1 creates `app_metadata`, a minimal local table that verifies
the Drift/SQLite connection. Product tables are intentionally deferred until
their owning milestones.

Schema version 2 preserves `app_metadata` and creates `user_profiles` and
`motivations` for onboarding. `user_profiles` stores the required baseline and
goal plus optional pack and first-cigarette details. `motivations` stores the
optional private onboarding reason. A migration test verifies version-1 data is
preserved.

Schema version 3 preserves all existing tables and creates `smoking_logs`,
`triggers`, and `smoking_log_triggers`. The join table uses a composite primary
key with foreign keys to make a smoking log's trigger tags a durable
many-to-many relationship. Migration tests verify that version-1 foundation
data and version-2 onboarding/profile data remain available.

Schema version 4 preserves all existing tables and creates `craving_sessions`.
It stores the start/end timestamps, initial/final intensity, completion outcome,
and an optional private note for every SOS session. A migration test verifies
version-3 smoking-log data remains available after the new table is created.

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
- Milestone 02 was re-audited against its implementation and test suite before
  beginning Milestone 03. Its scope is complete; no correction was required.
- Smoking-log timestamps are stored as instants, while daily counts, today's
  filters, and hourly aggregation use explicit local-time boundaries. This
  prevents behavioral data from being grouped by UTC day.
- Default trigger tags are seeded locally by the smoking-log repository.
  The presentation layer receives domain entities only, and separate providers
  keep the Home count and timeline rebuild boundaries narrow.
- Milestone 03 was audited before Milestone 04 work began. Its quick-log,
  trigger mapping, reactive Home count/timeline, local-time grouping, migration
  coverage, and tests match the documented scope; no correction was needed.
- Craving SOS uses one `AsyncNotifier` session controller backed by a craving
  repository. An unfinished session is restored from local storage, while a
  pure progress model derives elapsed/remaining time from `started_at` rather
  than counting timer ticks. The active page owns only a small, visible
  one-second display ticker and safely refreshes from timestamps on resume.
- Choosing "Tambah 5 menit" completes the current session as `delayed` and
  begins another persisted five-minute session. Choosing `smoked` completes the
  craving session then reuses the existing quick smoking-log sheet, preserving
  prior smoking history and avoiding duplicate logging logic.

## Known Issues

No known issues within completed milestones. Quit planning, notifications, and
later analytics remain intentionally deferred.

## Next Agent Instructions

1. Read `docs/APP_SPEC.md`.
2. Read this file.
3. Read `docs/milestones/05_QUIT_PLAN.md` completely.
4. Inspect the Foundation, Onboarding, Smoking Log, and Craving implementations
   before editing.
5. Work only on Milestone 05.
6. Run formatter, analyzer, and tests before marking anything complete.
