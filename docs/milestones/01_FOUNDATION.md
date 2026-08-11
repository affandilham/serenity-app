# Milestone 01 — Foundation

## Instructions for Codex

Read `docs/APP_SPEC.md` and `docs/PROJECT_STATUS.md` before making changes. The master spec is the source of truth. Inspect the existing repository first and preserve working architecture from completed milestones.

Implement **ONLY this milestone**. Do not proactively implement future milestones.

## Goal

Deliver foundation as a complete, testable vertical slice while preserving the product principles in `APP_SPEC.md`.

## Scope

- [x] Flutter project structure
- [x] App theme & design tokens
- [x] go_router
- [x] Riverpod setup
- [x] Drift/SQLite setup
- [x] Core reusable components

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

- onboarding
- smoking logging
- craving SOS
- quit plan
- insights

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

1. Created the Flutter Android/iOS project with app and feature-first folders,
   `MaterialApp.router`, Riverpod's root `ProviderScope`, Serenity design
   tokens/theme, and shared Foundation components.
2. Added Drift schema version 1 with a minimal `app_metadata` table, a
   Riverpod database provider, and generated Drift code. Product data tables
   remain deferred to their owning milestones.
3. Added a database persistence test, theme test, and Foundation widget test.
   `dart format .`, `flutter analyze`, and `flutter test` all pass.
4. The only intentional limitation is that the root screen is a Foundation
   placeholder; onboarding and all product behaviors are out of scope here.
5. The repository is ready for Milestone 02.
