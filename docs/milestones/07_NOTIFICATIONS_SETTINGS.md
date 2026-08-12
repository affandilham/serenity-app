# Milestone 07 — Notifications, Settings & Export

## Instructions for Codex

Read `docs/APP_SPEC.md` and `docs/PROJECT_STATUS.md` before making changes. The master spec is the source of truth. Inspect the existing repository first and preserve working architecture from completed milestones.

Implement **ONLY this milestone**. Do not proactively implement future milestones.

## Goal

Deliver notifications, settings & export as a complete, testable vertical slice while preserving the product principles in `APP_SPEC.md`.

## Scope

- [x] Opt-in local notifications
- [x] Daily check-in
- [x] Quit date reminder
- [x] Settings
- [x] Theme preference
- [x] JSON export
- [x] Delete all data

## UX Requirements

- Calm, non-judgmental Indonesian copy.
- Keep primary actions obvious and interaction count low.
- Support light/dark theme and text scaling.
- Avoid unnecessary animation and broad widget rebuilds.
- Preserve offline-first behavior.

## Engineering Requirements

- Follow feature-first architecture.
- Business logic must be testable outside widgets.
- Keep Riverpod rebuild boundaries small.
- Persist relevant state with Drift; UI must not contain SQL.
- Do not add dependencies without a concrete need.
- Add/update tests for business logic introduced here.

## Out of Scope

- cloud backup
- account/login
- push server

## Definition of Done

- [x] Every Scope item is implemented.
- [x] Relevant unit/repository/widget tests exist.
- [x] No regression in completed milestones.
- [x] `dart format .` completed.
- [x] `flutter analyze` passes with no unresolved issues.
- [x] `flutter test` passes.
- [x] Update `docs/PROJECT_STATUS.md` only after the milestone passes validation.

## Completion Report

When finished, report:
1. Files created/changed.
2. Architecture or schema decisions made.
3. Tests added and commands run.
4. Known limitations, if any.
5. Whether the repository is ready for Milestone 08.

## Completion Report

Completed on 2026-08-12.

1. Added persisted, opt-in reminder preferences backed by the existing
   `app_metadata` table. Notifications default off. Permission is requested
   only after the user enables a reminder. Daily check-ins use stable ID 7101;
   quit-day reminders use stable ID 7102 and derive their date from the
   existing Quit Plan. Scheduling the same category replaces its old schedule.
2. Local platform scheduling is isolated in `FlutterNotificationService`. It
   resolves the device's IANA timezone before scheduling wall-clock times and
   uses inexact idle-safe Android scheduling, so no exact-alarm permission is
   requested. There are no remote notifications, trackers, or network calls.
3. Added Settings with persisted System/Light/Dark theme selection, editable
   baseline/pack/price values, notification controls, Quit Plan entry, JSON
   export via the device share sheet, deliberate delete-all confirmation, and
   the required About disclaimer. Profile changes preserve historical logs and
   existing Insights recalculate reactively.
4. JSON export version 1 contains profile, motivations, triggers, smoking logs
   and trigger IDs, craving sessions, quit plans and strategies, and Serenity
   settings. Delete all cancels Serenity notifications, clears all personal
   tables and preferences, then returns the root onboarding gate to fresh state.
5. Added repository/service/controller coverage for defaults, persistence,
   permission denial, stable notification categories, scheduling, JSON export
   relationships/empty state, and full reset. `dart format .`, `flutter
   analyze`, and the complete test suite pass.
6. The rename audit found no previous user-facing product name. The local
   `serenity` database name, `serenity_app` package name, and Android/iOS
   identifiers remain intentionally, to avoid breaking existing installations
   or local data. The repository is ready for Milestone 08.
