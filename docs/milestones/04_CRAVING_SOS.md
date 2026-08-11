# Milestone 04 — Craving SOS

## Instructions for Codex

Read `docs/APP_SPEC.md` and `docs/PROJECT_STATUS.md` before making changes. The master spec is the source of truth. Inspect the existing repository first and preserve working architecture from completed milestones.

Implement **ONLY this milestone**. Do not proactively implement future milestones.

## Goal

Deliver craving sos as a complete, testable vertical slice while preserving the product principles in `APP_SPEC.md`.

## Scope

- [x] 5-minute SOS flow
- [x] Craving intensity before/after
- [x] Breathing, water, movement, distraction steps
- [x] Craving session persistence
- [x] passed/delayed/smoked/abandoned outcomes

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

- medication dosing
- AI chat
- social features

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

1. Added a one-tap Home entry point and a calm, timestamp-driven five-minute
   SOS experience. It progresses through Bernapas, Minum, Bergerak, Alihkan,
   and Cek lagi, and only runs its lightweight one-second display ticker while
   the active page is visible.
2. Added a feature-first craving repository, immutable domain models, a pure
   timer-progress calculation, and a narrow Riverpod controller that resumes
   any unfinished local session after ordinary rebuilds or app lifecycle
   changes. The timer is always derived from `started_at`, so background time
   does not drift.
3. Added schema version 4 with `craving_sessions`. It retains every previous
   table and record, stores start/end timestamps, initial/final intensity,
   outcome, and an optional note. A version-3 migration test verifies smoking
   data survives the new table.
4. The final check supports passed, delayed, smoked, and abandoned without
   shame-based copy. Delaying records the completed session and immediately
   starts another persisted five-minute session. Choosing smoked hands off to
   the existing quick smoking-log sheet rather than duplicating logging logic.
5. Added domain, repository, controller, migration, and widget tests. They use
   deterministic time and cover all outcomes, persistence, timer clamping,
   continuation, the smoked-history invariant, and the passed widget flow.
6. `dart format .`, `flutter analyze`, and `flutter test` pass. There are no
   known limitations within this milestone; the repository is ready for
   Milestone 05.
