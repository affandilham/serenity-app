# Milestone 06 — Insights & Journey

## Instructions for Codex

Read `docs/APP_SPEC.md` and `docs/PROJECT_STATUS.md` before making changes. The master spec is the source of truth. Inspect the existing repository first and preserve working architecture from completed milestones.

Implement **ONLY this milestone**. Do not proactively implement future milestones.

## Goal

Deliver insights & journey as a complete, testable vertical slice while preserving the product principles in `APP_SPEC.md`.

## Scope

- [x] Daily cigarette chart
- [x] Top trigger analysis
- [x] Time-of-day patterns
- [x] Craving outcomes
- [x] Money not spent
- [x] Current/longest smoke-free period
- [x] Cigarettes avoided

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

- remote analytics
- leaderboards
- AI recommendations

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
5. Whether the repository is ready for Milestone 07.

## Completion Report

Completed on 2026-08-11.

1. Added a calm, locally derived Insights page, available from both Home modes,
   with 7- and 30-day cigarette charts, time-of-day patterns, normalized trigger
   distribution, craving outcomes/trend, and journey metrics.
2. Analytics are a pure domain snapshot built from existing profile, smoking-log,
   craving-session, and quit-plan data. No persistent analytics table, migration,
   or dependency was added.
3. Cigarettes avoided, days below baseline, and money not spent use only complete
   local calendar days. Savings uses only the user-provided pack price and pack
   size; it is omitted when either value is invalid or unavailable.
4. Added domain coverage for local-day continuity, trigger percentages, craving
   outcomes, progress/savings, and clamp behavior, plus a widget test for Insight
   learning states and range selection. `dart format .`, `flutter analyze`, and
   `flutter test` pass.
5. No known limitations within this milestone. The repository is ready for
   Milestone 07.
