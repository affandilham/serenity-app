# Milestone 02 — Onboarding & Profile

## Instructions for Codex

Read `docs/APP_SPEC.md` and `docs/PROJECT_STATUS.md` before making changes. The master spec is the source of truth. Inspect the existing repository first and preserve working architecture from completed milestones.

Implement **ONLY this milestone**. Do not proactively implement future milestones.

## Goal

Deliver onboarding & profile as a complete, testable vertical slice while preserving the product principles in `APP_SPEC.md`.

## Scope

- [x] 5-step onboarding
- [x] Profile persistence
- [x] Goal selection
- [x] Personal motivation / why
- [x] Baseline cigarettes and pack-price data

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

- smoking timeline
- craving SOS
- quit mode
- charts

## Definition of Done

- [x] Every Scope item is implemented.
- [x] Relevant unit/repository/widget tests exist.
- [x] No regression in completed milestones.
- [x] `dart format .` completed.
- [x] `flutter analyze` passes with no unresolved issues.
- [x] `flutter test` passes.
- [x] Update `docs/PROJECT_STATUS.md` only after the milestone passes validation.

## Completion Report

Completed on 2026-08-11.

1. Added a five-step Serenity onboarding flow for welcome, current smoking
   pattern, goal, personal motivation, and confirmation. It includes loading,
   recoverable error, field-validation, saving, and completed-profile states.
2. Added a feature-first onboarding domain, Drift-backed profile repository,
   and focused Riverpod providers. The root route now gates first launch into
   onboarding and shows the locally persisted completion state after saving.
3. Added schema version 2. It preserves version-1 `app_metadata` data and
   creates `user_profiles` plus `motivations`; both current-pattern data and
   an optional private motivation are stored locally in one transaction.
4. Added domain, repository, migration, and five-step widget-flow tests.
   `dart format .`, `flutter analyze`, and `flutter test` pass.
5. No known limitations within milestone scope. The repository is ready for
   Milestone 03; smoking logging, timeline, craving SOS, quit mode, and charts
   remain intentionally deferred.
