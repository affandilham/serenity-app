# Project Status

> AI-readable save point for the project. Update this file only after a milestone passes its Definition of Done.

## Current Milestone

**Serenity MVP Complete**

## Milestones

- [x] 01 Foundation
- [x] 02 Onboarding & Profile
- [x] 03 Smoking Log & Triggers
- [x] 04 Craving SOS
- [x] 05 Quit Plan & Slip Handling
- [x] 06 Insights & Journey
- [x] 07 Notifications, Settings & Export
- [x] 08 Polish, Accessibility & Testing

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
    └── quit_plan/
        ├── data/
        ├── domain/
        └── presentation/
    └── insights/
        ├── domain/
        └── presentation/
    └── settings/
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

Schema version 5 preserves all existing tables and creates `quit_plans` and
`quit_plan_strategies`. A plan stores its local calendar quit date, explicit
lifecycle status, optional existing motivation link, support person, and audit
timestamps. The strategy table maps plan-specific actions to optional existing
triggers, so relational data is not encoded as comma-separated text. A
migration test verifies version-4 smoking logs and craving sessions survive.

Milestone 07 adds no schema migration. Its small, non-behavioral preferences
use the existing `app_metadata` table and are removed by Delete All Data.

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
- Quit plans have explicit `draft`, `active`, `paused`, and `completed`
  statuses. A draft activates when the user's local quit date arrives; the
  supported user transitions are draft → active, active → paused, and paused →
  active.
- `QuitProgress` derives the current and longest smoke-free durations from the
  plan's local start day and immutable smoking logs. The latest cigarette is
  never duplicated into the profile or plan; it is calculated from smoking-log
  data.
- A post-quit smoking event is a derived slip, not destructive state. It is
  recorded through the existing logging flow, keeps the plan active unless the
  user changes it, and offers a calm choice to continue or adjust the plan.
- Milestone 04 was re-audited before Quit Plan work. Its persisted five-minute
  flow, all outcomes, controller restoration, migration coverage, and existing
  regression tests satisfy its Definition of Done; no correction was needed.
- Milestone 05 was audited before Insight work. Its persisted plan/strategy
  relationships, explicit transitions, Quit Day mode, pure streak calculation,
  derived slips, and regression coverage satisfy its Definition of Done; no
  correction was needed.
- Insights are derived in a pure domain snapshot from existing local profile,
  smoking-log, craving-session, and quit-plan data. No analytics table or
  schema migration is needed. Charts and patterns use local calendar days and
  local clock hours; trigger percentages use all smoking logs in the selected
  range as their denominator, including logs without triggers.
- Journey progress deliberately counts only completed local days from the active
  quit date (or profile creation before a plan is active). This avoids claiming
  a full baseline benefit for a partial current day. Slip logs reset only the
  current smoke-free duration through the established QuitProgress semantics;
  avoided cigarettes and estimated savings remain lifetime-derived progress.
- Notification preferences default off and are stored in `app_metadata`.
  `NotificationController` requests platform permission only after the user
  explicitly enables a reminder; a denial leaves the preference off and the app
  usable. `FlutterNotificationService` owns platform setup, resolves the
  device's IANA timezone, and schedules local wall-clock times. Daily check-in
  and quit-day reminders use stable IDs 7101 and 7102; rescheduling replaces
  an old ID and reset cancels all Serenity notifications. Android uses inexact
  idle-safe scheduling, avoiding an exact-alarm permission prompt.
- Theme preference (`system`, `light`, `dark`) is persisted in `app_metadata`
  and drives `MaterialApp` reactively. Profile baseline, cigarettes-per-pack,
  and pack-price edits reuse the onboarding repository, allowing Insights to
  update without altering historical logs.
- JSON export version 1 is generated outside widgets and contains only
  user-owned Serenity data: profile, motivations, triggers, smoking logs and
  trigger links, craving sessions, quit plans and strategies, and settings. A
  device share sheet is shown only after an explicit export action.
- Delete All Data is centralized in `AppDatabase.deleteAllPersonalData` and
  `ResetService`: it cancels notifications, clears all Serenity behavioral data
  and settings in one local transaction, and returns the root onboarding gate
  to fresh state. No unrelated device data is touched.
- The rename audit found no old user-facing product name. The local `serenity`
  database file name, `serenity_app` package, and current Android/iOS IDs are
  intentionally retained technical names to protect existing installations and
  data.
- Milestone 08 final audit verified the prior milestones against their source,
  persistence paths, migrations, and regression tests. It corrected range
  filtering for craving summaries so 7/30-day insight values use only sessions
  in the selected local-day range, and added in-flight guards that prevent a
  repeated quick-log or SOS action from creating duplicate local records.
- Accessibility and responsive checks cover semantic chart labels, explicit
  icon tooltips, 44+ logical-pixel primary controls, light/dark themes, and an
  Insights widget flow at 320 logical pixels with 1.8x text scaling. Insight
  metrics and progress bars now stack their labels to avoid narrow-screen text
  clipping. Performance review found timestamp-driven SOS ticking only while
  visible, lazy Home timelines, scoped Riverpod consumers, and no idle visual
  animation loops; no broad state-management rewrite was justified.
- The version-4-to-5 migration regression now verifies preservation of profile,
  motivations, trigger links, craving history, and settings metadata in
  addition to prior migration coverage. No new schema migration was needed.

## Known Issues

No known product-code issues within the completed MVP scope. Android debug APK
build validation is still environment-limited on this workstation because no
Java Runtime is installed (`flutter build apk --debug` fails before Gradle can
compile). Run that non-destructive build on a JDK-configured machine before
shipping to a device.

## Next Agent Instructions

Serenity MVP is complete. Do not begin Phase 2 without explicit user direction.
