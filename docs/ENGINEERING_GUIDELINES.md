# Serenity Engineering Guidelines

Detailed maintainability conventions for Serenity. `AGENTS.md` contains mandatory rules; this document explains how to apply them. Optimize for cohesion, readability, testability, explicit ownership, and safe incremental change—not minimum line count.

## File size
File length is a signal, not a hard rule:
- `< 200` lines: usually acceptable.
- `200–300`: inspect responsibility.
- `300–450`: likely extraction candidate.
- `450–600`: strong refactor candidate.
- `> 600`: must be reviewed and split unless there is a compelling cohesion reason.

Never split only to hit a line-count target. Split by responsibility and reason-to-change.

## Pages and widgets
Pages should primarily compose sections and coordinate page-level behavior. Avoid giant pages mixing markup, calculations, persistence, formatting, dialogs, and many `_build...()` methods.

Extract widgets when they represent meaningful sections, are reused, own interaction/state, provide useful rebuild boundaries, or substantially simplify the parent. Prefer semantic names such as `TodaySummaryCard`, `SmokingPatternSection`, and `CravingInsightCard`.

Do not extract every `Row`, `Padding`, or `Text`. Keep feature-specific widgets inside their feature; move to `core/widgets` only when genuinely shared.

## Prop drilling
Avoid forwarding provider-derived state/callbacks through intermediate widgets that do not use them.

A feature-aware child may consume a narrow Riverpod provider close to where the dependency is owned. Do not overcorrect: reusable/presentational widgets should normally receive prepared display data.

Healthy:
```dart
MetricCard(title: 'Bebas rokok saat ini', value: displayDuration)
```

Rule of thumb:
- feature-aware widget → may consume narrow providers;
- presentational widget → receives prepared display data;
- intermediate layout widget → does not forward dependencies it does not use.

Never solve prop drilling with mutable global state.

## Riverpod and rebuilds
Keep providers narrow and domain-focused. Prefer derived providers and small consumer boundaries. Use `.select(...)` only when it creates a meaningful rebuild boundary.

Avoid giant application state, giant controllers, duplicated derived state, and watching providers too high in the tree. Do not migrate Serenity to another state-management framework as a refactoring shortcut.

State should rebuild the smallest practical subtree. Do not sacrifice clarity for micro-optimization.

## Business logic
Business rules must have one canonical implementation outside presentation, including smoke-free duration, longest streak, money not spent, cigarettes avoided, local-day grouping, craving outcomes, and quit/slip semantics.

Widgets consume results; they do not reinvent formulas.

## Helper methods
Review large private helpers:
- `_build...()` → dedicated widget for meaningful UI.
- `_calculate...()` → domain/service logic when non-trivial.
- `_format...()` → focused formatter when reused/non-trivial.
- `_save...()` → controller/notifier/repository orchestration.
- `_show...()` → presentation is fine; extract complex/reused dialogs/sheets.

Avoid dumping grounds such as `utils.dart`, `helpers.dart`, `common.dart`, and `functions.dart`. Prefer purpose-specific ownership.

## Constructors and view data
Large constructors can reveal ownership problems. Split responsibility, consume a narrow provider at the owning feature widget, or use a small immutable view-data object for tightly related display values.

Do not hide prop drilling inside a giant `Params` object. Do not create view models for trivial widgets.

## Models and duplicate logic
Prefer immutable, typed domain/state models. Avoid undocumented dynamic maps, arbitrary mutable fields, and passing Drift rows throughout presentation.

Before adding helpers, search for canonical implementations. Home and Insights must not calculate the same metric differently.

## Cross-feature boundaries
Keep dependency direction clear:
```text
presentation -> domain -> repository abstractions
data -----------------> domain
```

Domain must not import Flutter presentation. Repositories must not navigate. Widgets must not execute raw SQL. Avoid deep imports into another feature's internals.

## Forms and navigation
Separate form UI, validation, domain conversion, and persistence orchestration. Avoid passing many `TextEditingController`s through widget levels; dispose controllers correctly.

Keep navigation in presentation/application routing boundaries and preserve `go_router`.

## Async and errors
Audit repeated taps, duplicate writes, overlapping saves, `BuildContext` after async gaps, mounted checks, fire-and-forget operations, and timer/listener leaks.

Preserve safeguards against duplicate smoking-log and Craving SOS writes. Add regression tests for race-condition fixes when practical.

Do not silently swallow broad exceptions. Failures must not silently create duplicate or inconsistent records.

## Styling and copy
Reuse Serenity ThemeData, design tokens, spacing, typography, radii, semantic colors, and shared primitives. Do not globalize every visual literal.

Do not create a giant strings file merely for cleanliness. Extract stable/reused domain labels and keep page-specific copy near its feature. Preserve Serenity's calm, non-judgmental tone.

## Abstraction and constants
Prefer composition over inheritance. Do not create universal widgets, base pages/controllers/repositories, or generic frameworks merely to reduce lines.

Extract repeated meaningful constants into the module that owns them. Avoid global constants dumping grounds.

## Tests
Split large tests by behavior when useful. Use shared fixtures/builders only when they remove meaningful repetition without hiding intent.

For a real bug:
1. understand the root cause;
2. add a regression test when practical;
3. fix the root cause;
4. verify the regression;
5. run broader relevant tests.

## Naming and dead code
Prefer domain-specific names such as `activeQuitPlan`, `todaySmokingCount`, and `selectedTriggerIds` over vague names such as `data`, `temp`, `helper`, or `manager`.

When touching an area, safely remove nearby dead imports, unused private code, abandoned implementations, and debug output. Avoid large rename-only diffs without meaningful benefit.

## Feature organization
Use feature-first architecture pragmatically:
```text
feature/
├── data/
├── domain/
└── presentation/
    ├── controllers/
    ├── pages/
    └── widgets/
```

Create only directories that are needed. Do not create empty layers for symmetry.

## Cohesion over tiny files
Do not split one component into `label.dart`, `icon.dart`, `padding.dart`, etc. A cohesive widget may own layout, direct styling, and trivial display formatting. Extraction must improve understanding.

## Boy Scout Rule
Leave touched code slightly better than you found it, but do not expand scope unnecessarily. Small nearby cleanup is welcome when safe and relevant; do not turn every task into a repository-wide refactor.

## Refactoring workflow
For significant structural refactors:
1. establish a green baseline;
2. audit concrete smells;
3. refactor incrementally by feature/responsibility;
4. run targeted tests after meaningful changes;
5. periodically run the full suite;
6. review the final diff for accidental behavior changes.

Preserve database semantics, migrations, analytics formulas, notifications, quit/slip semantics, routing, and user-facing behavior unless a real bug is explicitly fixed.

## Validation
After structural changes:
```bash
dart format .
flutter analyze
flutter test
```

If behavior must change to fix a real bug, explain it and add a regression test where practical.
