# Milestone 04 — Craving SOS

## Instructions for Codex

Read `docs/APP_SPEC.md` and `docs/PROJECT_STATUS.md` before making changes. The master spec is the source of truth. Inspect the existing repository first and preserve working architecture from completed milestones.

Implement **ONLY this milestone**. Do not proactively implement future milestones.

## Goal

Deliver craving sos as a complete, testable vertical slice while preserving the product principles in `APP_SPEC.md`.

## Scope

- [ ] 5-minute SOS flow
- [ ] Craving intensity before/after
- [ ] Breathing, water, movement, distraction steps
- [ ] Craving session persistence
- [ ] passed/delayed/smoked/abandoned outcomes

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

- [ ] Every Scope item is implemented.
- [ ] Relevant unit/repository/widget tests exist.
- [ ] No regression in completed milestones.
- [ ] `dart format .` completed.
- [ ] `flutter analyze` passes with no unresolved issues.
- [ ] `flutter test` passes.
- [ ] Update `docs/PROJECT_STATUS.md` only after the milestone passes validation.

## Completion Report

When finished, report:
1. Files created/changed.
2. Architecture or schema decisions made.
3. Tests added and commands run.
4. Known limitations, if any.
5. Whether the repository is ready for Milestone 05.
