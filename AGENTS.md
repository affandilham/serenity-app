# AGENTS.md

## Project

**Serenity** is a private, offline-first Flutter application that helps a user understand smoking patterns, prepare to quit, handle cravings, and maintain progress without shame-based UX.

This file defines repository-wide instructions for coding agents, including Codex.

---

## 1. Read Before Editing

Before making changes, read these files in order:

1. `docs/APP_SPEC.md`
2. `docs/PROJECT_STATUS.md`
3. `docs/ENGINEERING_GUIDELINES.md`
4. The active milestone/task document, if one exists.

Then inspect the existing repository and relevant implementation.

Do not assume the documentation is perfectly synchronized with the code. Existing working code is the implementation reality; documentation defines intended product behavior. If they conflict, stop and identify the conflict before making a destructive architectural change.

---

## 2. Source of Truth

Responsibility is divided as follows:

- `docs/APP_SPEC.md` — product vision, architecture, UX principles, privacy, design system, and overall requirements.
- `docs/PROJECT_STATUS.md` — current progress, architectural decisions, migrations, known issues, and active work.
- `docs/ENGINEERING_GUIDELINES.md` — detailed maintainability, refactoring, widget composition, Riverpod, and code-organization conventions.
- `docs/milestones/*.md` — scope and Definition of Done when milestone-based work is active.
- Source code and tests — current implementation reality.

Never silently change product requirements to make implementation easier.

---

## 3. Task Scope Discipline

Implement **only the explicitly active task, milestone, or refactor scope** unless the user explicitly asks otherwise.

If `docs/PROJECT_STATUS.md` identifies an active milestone, follow it completely. If there is no active milestone, follow the user's explicit task and any task-specific document.

Before coding:

1. Identify the active task or milestone.
2. Read its complete requirements.
3. Inspect relevant existing code.
4. Produce a short implementation plan.
5. Verify that the plan stays inside scope.

Do not proactively begin Phase 2, future features, or unrelated refactors. If a useful change is outside scope, report it instead of implementing it.

---

## 4. Tech Stack

Primary stack:

- Flutter
- Dart
- Riverpod
- Drift + SQLite
- go_router
- flutter_local_notifications
- timezone
- fl_chart where charts materially improve comprehension

Do not replace major technologies without explicit approval.

Do not add dependencies merely for convenience.

Before adding a package:

1. Check whether the requirement can reasonably be implemented with Flutter/Dart or an existing dependency.
2. Explain why the new dependency is justified.
3. Prefer mature, narrowly scoped packages.
4. Keep platform impact in mind.

---

## 5. Architecture

Use feature-first architecture.

Expected high-level structure:

```text
lib/
├── app/
│   ├── app.dart
│   ├── router/
│   └── theme/
├── core/
│   ├── database/
│   ├── notifications/
│   ├── time/
│   ├── utils/
│   └── widgets/
├── features/
│   └── <feature>/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

Keep architecture pragmatic.

Do not create abstractions that have no current purpose.

Avoid:

- god classes,
- giant providers,
- giant widget files,
- business logic inside widgets,
- SQL inside presentation code,
- navigation inside repositories,
- mutable global state,
- direct database coupling throughout UI code.

Prefer:

- small composable widgets,
- immutable domain models,
- repository boundaries,
- narrow Riverpod providers,
- explicit state transitions,
- testable pure functions for calculations.

---

## 5A. Maintainability Rules

Follow `docs/ENGINEERING_GUIDELINES.md` for detailed code organization, widget extraction, Riverpod boundaries, prop-drilling prevention, file-size heuristics, helper extraction, and refactoring conventions.

Key invariants:

- Pages should primarily compose feature sections.
- Prefer semantic feature-local widgets over giant page files.
- File length is a smell signal, not a hard target.
- Avoid forwarding provider-derived state/callbacks through intermediate widgets that do not use them.
- Keep healthy presentational parameters; do not turn every widget into a `ConsumerWidget`.
- Business calculations must have one canonical implementation outside presentation.
- Avoid generic dumping grounds such as `utils.dart`, `helpers.dart`, or `common.dart`.
- Do not split cohesive code into tiny files merely to reduce line count.
- Prefer composition over premature abstraction or inheritance.
- Leave touched code slightly better without unnecessarily expanding task scope.

---

## 6. Riverpod Rules

Use Riverpod as the application state-management system.

Prefer:

- `Provider` for dependencies/services,
- `Notifier` for synchronous mutable application state,
- `AsyncNotifier` where asynchronous state lifecycle warrants it,
- small providers scoped to a clear responsibility,
- `ref.watch()` close to the smallest UI subtree that needs the state.

Avoid one global `AppState`.

Do not rebuild an entire page because one counter changed if the UI can reasonably be split into smaller consumers.

Business logic should not depend unnecessarily on `BuildContext`.

---

## 7. Drift / Database Rules

The application is offline-first.

Persist user behavioral data locally using Drift/SQLite.

Requirements:

- migrations must be explicit,
- schema changes must be documented,
- migration tests should be added when schema evolution begins,
- use local timezone correctly for behavioral analytics,
- do not accidentally group smoking behavior by UTC day,
- do not destroy historical data when handling a slip/lapse.

Do not perform destructive migrations merely to simplify development unless explicitly approved.

Update `docs/PROJECT_STATUS.md` when a database migration is introduced.

---

## 8. Privacy

Treat all smoking, craving, motivation, and behavioral data as private.

For MVP:

- no analytics SDK,
- no ads,
- no trackers,
- no mandatory account,
- no remote backend,
- no silent telemetry,
- no automatic cloud upload.

Do not introduce network transmission of personal behavioral data without explicit user approval and corresponding documentation.

Secrets and credentials must never be committed.

---

## 9. Medical Safety

This application is a behavioral support tool, not a doctor.

Do not implement:

- diagnosis,
- individualized medical claims,
- medication dosing calculators,
- prescription recommendations,
- unsupported health timelines,
- invented contraindications.

When medical treatment or medication is discussed in product copy, direct the user toward an appropriate healthcare professional or pharmacist.

Do not invent medical statistics.

If health-related copy needs factual claims, use authoritative sources documented in `APP_SPEC.md` or request/source an appropriate reference before shipping the claim.

---

## 10. Product Tone

The application must feel like an ally, not a judge.

Preferred language:

- calm,
- warm,
- concise,
- non-judgmental,
- action-oriented.

Never use shame-based copy such as:

- `Kamu gagal`
- `Streak gagal`
- `Kurang disiplin`
- `Kamu merusak progresmu`

A slip does not erase lifetime progress.

Prefer language such as:

- `Tercatat.`
- `Kita lihat polanya.`
- `Mau coba lewatkan beberapa menit ini?`
- `Hari ini cukup fokus pada hari ini.`

---

## 11. UI / UX Rules

Visual direction:

- calm,
- modern,
- intimate,
- premium,
- breathable,
- conversational.

The design may take inspiration from high-quality modern conversational interfaces, but must have its own identity.

Do not clone ChatGPT/OpenAI UI pixel-for-pixel.

Do not use:

- OpenAI logos,
- OpenAI names as branding,
- copied proprietary icons,
- branding that implies affiliation with OpenAI.

Prefer:

- generous spacing,
- clear typography hierarchy,
- rounded surfaces,
- thin borders,
- one application accent color,
- restrained animation,
- strong light/dark mode support.

Avoid:

- excessive gradients,
- constant animation,
- neon visual language,
- heavy blur,
- gamification that creates guilt,
- unnecessary dashboards.

---

## 12. Reusable UI

Before creating a new visual pattern, check whether an existing shared component can be reused.

Expected primitives may include:

```text
AppScaffold
AppTopBar
AppCard
MetricCard
InsightCard
PrimaryButton
SecondaryButton
PillChoice
CravingScale
EmptyState
TimelineItem
SectionHeader
MotivationCard
BottomActionSheet
```

Do not force reuse when the semantics genuinely differ.

---

## 13. Accessibility

All new UI should account for:

- text scaling,
- dark mode,
- semantic labels,
- screen readers where practical,
- tap targets of at least ~44 logical pixels,
- keyboard visibility/forms,
- readable contrast,
- status communication beyond color alone,
- reduced-motion preferences where relevant.

Never intentionally clip text to preserve a visual layout.

---

## 14. Performance

The app should remain smooth on mid-range Android hardware.

Avoid:

- continuously repainting idle screens,
- unnecessary animation controllers,
- excessive `BackdropFilter`,
- expensive effects,
- rebuilding large widget trees for tiny state changes,
- eager rendering of long lists,
- unnecessary nested scrolling.

Prefer:

- lazy lists,
- narrow consumers,
- isolated chart rebuilds,
- `const` widgets where appropriate,
- animations that stop when no longer visible.

Do not optimize blindly. Profile when performance is uncertain.

---

## 15. Coding Style

Follow standard Dart/Flutter conventions.

Requirements:

- null safety,
- meaningful names,
- small focused methods,
- minimal comments that explain *why*, not obvious syntax,
- no dead code,
- no commented-out implementation left behind,
- no ignored analyzer warnings as a shortcut,
- no broad exception swallowing.

Prefer readable code over clever code.

Do not prematurely generalize.

---

## 16. Testing

Business logic requires tests.

At minimum, preserve or add tests for behavior touched by the active milestone.

Important domain tests eventually include:

- money-not-spent calculation,
- cigarettes-avoided calculation,
- current smoke-free streak,
- longest streak,
- daily grouping,
- trigger aggregation,
- craving outcomes,
- quit-plan transitions,
- slip handling without loss of lifetime progress.

Repository tests should use an isolated/in-memory database where appropriate.

Important widget flows eventually include:

- onboarding,
- quick smoking log,
- Craving SOS,
- Home reactive updates,
- theme behavior.

A feature is not considered complete merely because it renders.

---

## 17. Required Validation

Before declaring implementation complete, run:

```bash
dart format .
flutter analyze
flutter test
```

If the repository uses additional established checks, run those too.

Do not claim success if a required command fails.

Fix failures introduced by the work.

If an unrelated pre-existing failure blocks validation, report:

- exact failing command,
- relevant failure,
- why it appears unrelated,
- whether the new work itself was otherwise verified.

Never hide test failures.

---

## 18. Documentation Updates

After completing a task or milestone:

1. Update the milestone checklist.
2. Add a concise completion report to the milestone file if that convention is present.
3. Update `docs/PROJECT_STATUS.md`.
4. Record meaningful architectural decisions.
5. Record database migrations.
6. Record known issues or deferred work.

Do not mark a milestone complete until its Definition of Done is satisfied.

---

## 19. Git Discipline

Do not:

- rewrite unrelated user changes,
- reset files merely because they are inconvenient,
- delete unknown work,
- force-push,
- rewrite repository history,
- commit secrets.

Before modifying an existing file, inspect it.

Keep changes focused on the active task.

If the working tree contains unrelated modifications, preserve them.

---

## 20. Agent Completion Response

At the end of a coding task, report concisely:

### Implemented
What changed.

### Key files
Important files created or modified.

### Validation
Results of:

```text
dart format .
flutter analyze
flutter test
```

### Deferred
Anything intentionally left outside the active task scope.

### Status
Whether the active task is fully satisfied. For milestone work, also state whether its Definition of Done is fully satisfied.

Do not produce a long tutorial unless asked.

---

## 21. Decision Rule

When choosing between:

> more architecture

and

> the simplest design that safely supports current requirements

choose the simpler design.

When choosing between:

> more metrics

and

> one useful next action for the user

choose the useful next action.

When choosing between:

> protecting a streak number

and

> protecting the user's long-term progress

protect long-term progress.

---

## 22. Core Principle

The user is trying to make their life less controlled by cigarettes.

Every technical, product, and UX decision should support that goal without creating shame, dependency on the app, unnecessary complexity, or avoidable privacy risk.
