# Milestone 03 — Smoking Log & Triggers

## Instructions for Codex

Read `docs/APP_SPEC.md` and `docs/PROJECT_STATUS.md` before making changes. The master spec is the source of truth. Inspect the existing repository first and preserve working architecture from completed milestones.

Implement **ONLY this milestone**. Do not proactively implement future milestones.

## Goal

Deliver smoking log & triggers as a complete, testable vertical slice while preserving the product principles in `APP_SPEC.md`.

## Scope

- [x] Quick smoking log under 10 seconds
- [x] Trigger tables and many-to-many mapping
- [x] Today dashboard count
- [x] Recent timeline
- [x] Daily/hour/trigger aggregation foundations

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

- craving SOS
- quit plan
- notifications

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

1. Added a quick, optional-detail smoking log sheet that saves the current
   local time, selected trigger tags, a 1–5 craving level, and an optional
   note. After save, it confirms calmly and returns to Home.
2. Added schema version 3 with `smoking_logs`, `triggers`, and
   `smoking_log_triggers`. The join table has a composite primary key and
   foreign keys to preserve a real many-to-many relationship. Version-1 and
   version-2 migration tests verify existing data remains available.
3. Added a feature-first smoking-log repository and narrow Riverpod providers
   for the trigger list, today's count, today's timeline, and save controller.
   Local-day boundaries and local hours are calculated in Dart from local time
   rather than UTC date strings.
4. Home now shows a reactive count and newest-first timeline while only their
   small consumer widgets rebuild for log updates. Repository, migration,
   provider, and widget-flow tests cover adding logs, multiple triggers,
   aggregations, ordering, persistence after reload, and reactive updates.
5. `dart format .`, `flutter analyze`, and `flutter test` pass. There are no
   known limitations within this milestone. The repository is ready for
   Milestone 04; Craving SOS remains intentionally unimplemented.
