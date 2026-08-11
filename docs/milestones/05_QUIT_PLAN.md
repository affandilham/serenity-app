# Milestone 05 — Quit Plan & Slip Handling

## Instructions for Codex

Read `docs/APP_SPEC.md` and `docs/PROJECT_STATUS.md` before making changes. The master spec is the source of truth. Inspect the existing repository first and preserve working architecture from completed milestones.

Implement **ONLY this milestone**. Do not proactively implement future milestones.

## Goal

Deliver quit plan & slip handling as a complete, testable vertical slice while preserving the product principles in `APP_SPEC.md`.

## Scope

- [x] Quit plan editor
- [x] Quit date
- [x] Trigger-to-strategy mapping
- [x] Quit Day mode
- [x] Smoke-free streak
- [x] Slip handling without deleting lifetime progress

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

- advanced analytics
- cloud sync
- partner mode

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

1. Added an editable, locally persisted Quit Plan with a local-calendar quit
   date, a link to an existing private motivation, an optional support person,
   up to three trigger plans, and an optional general craving action.
2. Added explicit `draft`, `active`, `paused`, and `completed` domain states.
   A draft activates when its local quit date arrives; active plans can pause
   and resume. The transition rules and smoke-free calculations are pure,
   deterministic domain logic.
3. Home switches to a focused Quit Day experience with the primary daily goal,
   time since the last cigarette, passed cravings, the existing SOS action,
   and a way to edit the plan. It deliberately leaves money and richer journey
   metrics to Milestone 06.
4. Smoking after an active quit date is still stored exclusively as a normal
   smoking log. The user sees a calm slip message and can continue quitting or
   adjust their plan. No smoking logs, craving sessions, longest periods, or
   plan state are deleted or reset automatically.
5. Schema version 5 adds `quit_plans` and normalized `quit_plan_strategies`.
   Its migration preserves version-4 data and uses foreign keys to existing
   motivations and triggers.
6. Added domain, repository, controller, migration, widget, and regression
   coverage; `dart format .`, `flutter analyze`, and `flutter test` pass (28
   tests).

The repository is ready for Milestone 06.
