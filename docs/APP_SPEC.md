# SERENITY — Product & Engineering Spec

> Personal Flutter app untuk membantu berhenti merokok secara bertahap, tanpa menghakimi.
> Fokus utama: mengenali pola, melewati craving, membangun quit plan, dan mempertahankan motivasi.

---

## 0. Instruksi untuk Codex

Bangun aplikasi Flutter berdasarkan spesifikasi ini.

Prioritas:
1. UX harus terasa tenang, premium, ringan, dan sangat mudah dipakai.
2. Offline-first. Jangan butuh akun/login untuk MVP.
3. Jangan membuat klaim medis yang tidak bersumber.
4. Jangan memakai logo, nama, ikon, atau branding OpenAI/ChatGPT.
5. UI boleh terinspirasi dari kualitas visual conversational UI modern: spacing lega, card lembut, typography jelas, animasi minimal, hierarchy kuat.
6. Jangan menyalin UI ChatGPT pixel-for-pixel. Buat design system sendiri.
7. Semua state dan business logic harus testable.
8. Gunakan feature-first architecture.
9. Jangan over-engineer MVP.
10. Jalankan `flutter analyze` dan `flutter test` sebelum menganggap task selesai.

Nama aplikasi: **Serenity**

Target awal:
- Android
- iOS
- Personal use
- Bahasa Indonesia

---

# 1. Product Vision

Aplikasi ini bukan sekadar penghitung "berapa hari tidak merokok".

Aplikasi harus menjadi teman pribadi saat user:
- belum berhenti sepenuhnya,
- sedang mengurangi,
- sudah menentukan quit date,
- mengalami craving,
- terpeleset dan merokok lagi,
- ingin melihat pola pemicunya,
- butuh diingatkan alasan kenapa ia ingin berhenti.

Tone aplikasi:
- hangat,
- tidak menggurui,
- tidak mempermalukan,
- tidak menakut-nakuti,
- tidak memakai kalimat seperti "kamu gagal",
- tidak membuat streak terasa seperti seluruh progres hilang karena satu slip.

Prinsip utama:

> **Satu batang bukan berarti semua progres hilang. Catat, pahami pemicunya, lalu lanjut.**

---

# 2. Evidence-informed Product Principles

Fitur produk mengikuti prinsip umum cessation support berikut:

- membantu user mengenali trigger,
- membuat quit plan,
- menyediakan strategi menghadapi craving,
- memberi dukungan behavioral,
- mengarahkan user ke tenaga kesehatan untuk opsi terapi/obat bila dibutuhkan,
- menjadikan digital intervention sebagai pendamping, bukan pengganti layanan kesehatan.

Jangan membuat aplikasi bertindak sebagai dokter.

Sumber referensi:
- WHO tobacco cessation guideline:
  https://www.who.int/publications/i/item/9789240096431
- WHO digital tobacco cessation support:
  https://www.who.int/publications/i/item/B09473
- CDC How to Quit Smoking:
  https://www.cdc.gov/tobacco/about/how-to-quit.html
- Smokefree Quit Plan:
  https://smokefree.gov/build-your-quit-plan
- Smokefree Triggers:
  https://smokefree.gov/challenges-when-quitting/cravings-triggers/know-your-triggers

---

# 3. Core User Journey

## Phase A — Observe

Sebelum berhenti, user cukup mencatat rokok.

Setiap kali merokok:
- tap tombol `+ Rokok`,
- waktu otomatis,
- pilih trigger opsional,
- pilih craving intensity 1–5,
- catatan opsional.

Tujuan:
mendeteksi pola tanpa memaksa user berubah di hari pertama.

## Phase B — Prepare

Setelah data mulai terkumpul:
- tampilkan jam paling sering merokok,
- trigger paling dominan,
- rata-rata batang/hari,
- rekomendasi sederhana untuk membuat Quit Plan.

## Phase C — Quit

Pada Quit Day:
- fokus berubah dari logging rokok ke mempertahankan keputusan,
- Home menampilkan progress hari ini,
- akses `SOS Craving` harus sangat mudah.

## Phase D — Maintain

Setelah berhenti:
- streak,
- jumlah rokok yang berhasil dihindari,
- estimasi uang yang tidak dibelanjakan,
- craving trend,
- trigger yang berhasil dilewati.

Jika user merokok lagi:
- jangan reset seluruh histori,
- simpan sebagai `slip`,
- streak aktif dapat dihitung ulang,
- lifetime progress tetap ada.

---

# 4. Tech Stack

## Framework

**Flutter + Dart**

Alasan:
- satu codebase Android/iOS,
- cocok untuk personal app,
- animation dan custom UI bagus,
- user sudah familiar dengan Flutter.

## State Management

**Riverpod**

Package:
```yaml
flutter_riverpod:
```

Gunakan API Riverpod modern.
Jangan memakai global mutable singleton.

Pola:
- repository provider,
- service provider,
- `Notifier` / `AsyncNotifier` sesuai kebutuhan,
- `ref.watch()` hanya di subtree yang membutuhkan state.

## Local Database

**Drift + SQLite**

Packages:
```yaml
drift:
drift_flutter:
```

Dev:
```yaml
drift_dev:
build_runner:
```

Alasan:
- offline-first,
- relational data cocok untuk smoking logs + triggers + plans,
- reactive query,
- mudah dibuat analytics lokal.

## Navigation

Gunakan:
```yaml
go_router:
```

Routes:
```text
/
 /onboarding
 /home
 /log
 /craving
 /insights
 /plan
 /settings
 /history
```

## Local Notification

```yaml
flutter_local_notifications:
timezone:
```

Use cases:
- reminder check-in,
- reminder sebelum jam rawan,
- Quit Day reminder.

Jangan spam notification.

## Charts

```yaml
fl_chart:
```

Gunakan hanya untuk insight yang benar-benar berguna:
- batang per hari,
- craving trend,
- trigger distribution.

## Utility

```yaml
intl:
uuid:
freezed_annotation:
json_annotation:
```

Optional jika benar-benar diperlukan:
```yaml
freezed:
json_serializable:
```

Jangan menambah package hanya karena tersedia.

---

# 5. Architecture

Gunakan feature-first architecture.

```text
lib/
├── app/
│   ├── app.dart
│   ├── router/
│   └── theme/
│
├── core/
│   ├── database/
│   ├── notifications/
│   ├── time/
│   ├── utils/
│   └── widgets/
│
├── features/
│   ├── onboarding/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── smoking_log/
│   ├── craving/
│   ├── quit_plan/
│   ├── dashboard/
│   ├── insights/
│   ├── motivation/
│   └── settings/
│
└── main.dart
```

Untuk setiap feature:

```text
feature/
├── data/
│   ├── repositories/
│   └── datasources/
├── domain/
│   ├── entities/
│   └── repositories/
└── presentation/
    ├── controllers/
    ├── pages/
    └── widgets/
```

Jangan membuat abstraction berlapis jika tidak memberi manfaat nyata.

---

# 6. Design Direction

## Goal

UI harus terasa:

- calm,
- intimate,
- modern,
- premium,
- conversational,
- breathable.

Referensi kualitas:
- hierarchy dan spacing seperti conversational AI UI modern,
- tapi bukan clone ChatGPT.

## Do

- rounded card,
- thin border,
- soft surface,
- large whitespace,
- typography kuat,
- satu accent color,
- micro-animation 150–250ms,
- bottom sheet untuk quick action,
- haptic ringan untuk action penting.

## Don't

- gradient berlebihan,
- confetti setiap hari,
- neon,
- leaderboard,
- badge kekanak-kanakan,
- guilt UI,
- tengkorak/paru hitam sebagai scare tactic,
- terlalu banyak angka di dashboard.

---

# 7. Design Tokens

Buat token sendiri.

```dart
abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}
```

Radius:
```text
small  = 10
medium = 16
large  = 22
pill   = 999
```

Light theme:
```text
background     #F7F7F5
surface        #FFFFFF
surfaceMuted   #F0F0ED
textPrimary    #171717
textSecondary  #6B6B68
border         #E5E5E1
```

Dark theme:
```text
background     #111110
surface        #1A1A18
surfaceMuted   #22221F
textPrimary    #F4F4F0
textSecondary  #A7A79F
border         #30302C
```

Accent:
pilih warna original aplikasi.
Default rekomendasi:
```text
#5C7C67
```

Jangan gunakan OpenAI green sebagai identitas brand.

---

# 8. Typography

Gunakan system font terlebih dahulu.

Hierarchy:

```text
Display     34 / medium
Title       24 / medium
Section     18 / medium
Body        16 / regular
Secondary   14 / regular
Caption     12 / regular
```

Hindari bold di semua tempat.

---

# 9. Bottom Navigation

4 tab saja:

```text
Hari Ini
Insight
Perjalanan
Saya
```

Floating/primary quick action:
```text
+ Catat
```

Saat mode Quit aktif, primary action berubah menjadi:

```text
Saya Lagi Ngidam
```

---

# 10. Onboarding

Maksimal 5 langkah.

## Screen 1 — Welcome

Copy:

```text
Kita nggak perlu menyelesaikan semuanya hari ini.

Mulai dari mengenali pola merokokmu.
```

CTA:
```text
Mulai
```

## Screen 2 — Current Pattern

Input:
- rata-rata batang / hari,
- harga sebungkus,
- isi batang per bungkus,
- kapan biasanya rokok pertama setelah bangun.

Semua boleh di-skip kecuali batang/hari.

## Screen 3 — Goal

Pilihan:

```text
Saya mau berhenti sepenuhnya
Saya mau mengurangi dulu
Saya belum tahu, saya mau memahami pola saya
```

## Screen 4 — Personal Why

Judul:

```text
Kenapa kamu ingin berhenti?
```

Preset:
```text
Kesehatan
Keluarga
Pasangan
Anak
Keuangan
Kebebasan
Lainnya
```

Text area:

```text
Tulis dengan kata-katamu sendiri...
```

Data ini privat dan disimpan lokal.

## Screen 5 — Finish

```text
Tidak harus sempurna.
Yang penting kita mulai mencatat dengan jujur.
```

---

# 11. Home — Observation Mode

Header:

```text
Selamat malam
Hari ini seperti apa?
```

Hero card:

```text
6 batang
hari ini

↓ 2 dari rata-rata minggu lalu
```

Primary actions:

```text
[ + Catat rokok ]
[ Saya lagi ngidam ]
```

Section:
```text
Pola hari ini
```

Timeline:
```text
08:12  Setelah sarapan
10:47  Ngopi
13:06  Setelah makan
...
```

Motivation card kecil:
```text
Alasanmu

"Aku ingin punya waktu lebih panjang bersama keluargaku."
```

---

# 12. Quick Smoking Log

Harus selesai dalam < 10 detik.

Bottom sheet:

```text
Catat rokok

Sekarang
22:14

Apa yang memicunya?
[ Kopi ] [ Setelah makan ] [ Stres ]
[ Nongkrong ] [ Bosan ] [ Alkohol ]
[ Lainnya ]

Keinginan merokok
1 ─────●───── 5

[ Catat ]
```

Trigger optional.

Setelah save:
jangan tampilkan guilt message.

Copy:

```text
Tercatat.
Kita pakai ini untuk memahami polamu.
```

---

# 13. Craving SOS

Ini adalah feature paling penting.

Entry point harus tersedia dalam 1 tap dari Home.

## First screen

```text
Oke. Jangan pikirkan selamanya.

Kita lewati beberapa menit ini dulu.
```

CTA besar:

```text
Mulai 5 menit
```

Secondary:
```text
Saya sudah merokok
```

## During SOS

Timer:
```text
04:32
```

Stepper horizontal:

```text
Bernapas → Minum → Bergerak → Alihkan → Cek lagi
```

Cards:

### 1. Bernapas

```text
Tarik biasa.
Keluarkan sedikit lebih lambat.
```

No pseudo-scientific breathing claims.

### 2. Minum

```text
Minum air perlahan.
Beri tangan dan mulut sesuatu untuk dilakukan.
```

### 3. Bergerak

```text
Berdiri dan berjalan sebentar.
Ubah tempatmu kalau bisa.
```

### 4. Alihkan

User dapat membuat daftar sendiri:

```text
Buka game
Mandi
Chat seseorang
Keluar ruangan
Permen karet
```

### 5. Check Again

```text
Seberapa kuat keinginannya sekarang?
1 2 3 4 5
```

Buttons:

```text
Sudah lewat
Tambah 5 menit
Saya merokok
```

Jika `Saya merokok`:

```text
Tidak apa-apa untuk mencatat apa yang terjadi.

Apa pemicunya?
```

Jangan memakai:
```text
Streak gagal
Kamu kalah
Mulai dari nol
```

---

# 14. Quit Plan

Fields:

```text
Quit date
Alasan utama
3 trigger terbesar
Strategi untuk setiap trigger
Support person
Hal yang akan dilakukan saat craving
```

Example mapping:

```text
Trigger: kopi
Plan: minum di tempat berbeda + permen karet

Trigger: setelah makan
Plan: langsung sikat gigi + jalan 5 menit

Trigger: stres kerja
Plan: keluar dari meja + air + breathing
```

User bebas edit.

---

# 15. Quit Day Mode

Hero:

```text
Hari ini cukup satu tujuan:
tidak merokok hari ini.
```

Cards:

```text
12 jam
sejak rokok terakhir
```

```text
3 craving
berhasil dilewati
```

```text
Rp18.000
tidak dibelanjakan
```

CTA:

```text
Saya Lagi Ngidam
```

Jangan terlalu banyak statistik.

---

# 16. Slip Handling

Jika user merokok setelah quit date:

modal:

```text
Tercatat.

Satu kejadian ini tidak menghapus semua hal
yang sudah kamu pelajari.
```

Question:

```text
Apa yang terjadi sebelum kamu merokok?
```

Actions:
```text
Catat pemicu
Lewati
```

Setelah itu:

```text
Mau lanjut berhenti dari sekarang?
[ Ya ]
[ Atur ulang rencana ]
```

Distinguish:
- lapse/slip,
- return to regular smoking.

Jangan otomatis mengubah status quit plan tanpa keputusan user.

---

# 17. Insights

Jangan membuat dashboard ala enterprise.

Tampilkan insight dalam bentuk kalimat.

Example:

```text
Kamu paling sering merokok
antara 20:00–23:00.
```

```text
Kopi muncul pada 38% catatanmu minggu ini.
```

```text
Rata-rata craving sebelum merokok:
4.1 / 5
```

Charts:

## Cigarettes / day
7–30 hari line/bar.

## Time-of-day heatmap
Buckets:
```text
00–06
06–09
09–12
12–15
15–18
18–21
21–24
```

## Top triggers
Horizontal bar.

## Craving outcome
```text
Dilewati
Menunda
Merokok
```

---

# 18. Journey

Bukan streak saja.

Metrics:

```text
Current smoke-free streak
Longest smoke-free period
Total cigarettes avoided
Total craving sessions completed
Days below baseline
Estimated money not spent
```

`cigarettes avoided`:

```text
baseline_daily_cigarettes * elapsed_days - cigarettes_smoked
```

Clamp minimum 0.

Money:
gunakan harga rokok yang user input sendiri.

Jangan hardcode harga.

---

# 19. Motivation Feature

Screen:

```text
Kenapa aku melakukan ini
```

Cards editable.

User bisa menulis private note seperti:

```text
Aku ingin hadir lebih lama untuk keluargaku.
Aku ingin pasangan merasa nyaman dekat denganku.
Aku ingin bebas dari kebutuhan mencari rokok.
```

Tambahkan feature:

```text
Tampilkan saat craving
```

Jika enabled, satu motivation card muncul di Craving SOS.

Tidak perlu cloud sync pada MVP.

---

# 20. Database Schema

## user_profile

```text
id
created_at
baseline_cigarettes_per_day
cigarettes_per_pack
pack_price
goal_type
quit_date nullable
last_cigarette_at nullable
onboarding_completed
```

## smoking_logs

```text
id
smoked_at
craving_level nullable
note nullable
created_at
```

## triggers

```text
id
name
is_default
created_at
```

## smoking_log_triggers

```text
smoking_log_id
trigger_id
```

Many-to-many.

## craving_sessions

```text
id
started_at
ended_at nullable
initial_intensity
final_intensity nullable
outcome
note nullable
```

Outcome enum:
```text
passed
delayed
smoked
abandoned
```

## quit_plans

```text
id
quit_date
status
created_at
updated_at
```

Status:
```text
draft
active
paused
completed
```

## motivations

```text
id
text
category
show_during_craving
sort_order
created_at
```

## coping_strategies

```text
id
trigger_id nullable
title
description nullable
is_default
created_at
```

---

# 21. Repository Interfaces

Example:

```dart
abstract interface class SmokingLogRepository {
  Stream<List<SmokingLog>> watchLogs({
    DateTime? from,
    DateTime? to,
  });

  Future<void> addLog(CreateSmokingLogInput input);

  Future<void> deleteLog(String id);

  Future<int> countForDay(DateTime date);
}
```

```dart
abstract interface class CravingRepository {
  Future<String> startSession({
    required int intensity,
  });

  Future<void> finishSession({
    required String sessionId,
    required int finalIntensity,
    required CravingOutcome outcome,
  });
}
```

---

# 22. Riverpod State

Example responsibilities:

```text
todayDashboardProvider
smokingLogControllerProvider
cravingSessionControllerProvider
quitPlanControllerProvider
insightsProvider
motivationProvider
settingsProvider
```

Avoid one gigantic `AppState`.

Dashboard should compose providers.

---

# 23. Analytics Queries

Drift queries needed:

## Daily cigarette counts

```sql
SELECT
  DATE(smoked_at) AS day,
  COUNT(*) AS count
FROM smoking_logs
WHERE smoked_at >= ?
GROUP BY DATE(smoked_at)
ORDER BY day;
```

## Most common trigger

```sql
SELECT
  t.id,
  t.name,
  COUNT(*) AS usage_count
FROM smoking_log_triggers slt
JOIN triggers t ON t.id = slt.trigger_id
JOIN smoking_logs sl ON sl.id = slt.smoking_log_id
WHERE sl.smoked_at >= ?
GROUP BY t.id, t.name
ORDER BY usage_count DESC;
```

## Hour distribution

Use local timezone.

Never derive behavioral pattern in UTC.

---

# 24. Notification Strategy

Default: OFF.

Ask permission only after user explicitly enables reminder.

Notification types:

## Daily check-in

```text
Mau catat bagaimana harimu?
```

## Pre-trigger window

Only after enough local data.

Example:
if user frequently smokes around 21:00:

```text
Jam ini biasanya agak berat.
Kalau craving datang, tombol SOS siap dipakai.
```

Do not say:
```text
Kamu biasanya akan merokok sekarang.
```

## Quit date

```text
Hari yang kamu pilih sudah tiba.
Hari ini cukup fokus pada hari ini.
```

---

# 25. Settings

```text
Tema
Notifikasi
Baseline
Harga rokok
Quit plan
Export data
Reset data
Tentang aplikasi
```

Data export MVP:
JSON.

Later:
CSV.

---

# 26. Privacy

This is personal behavioral data.

Requirements:

- offline by default,
- no analytics SDK for MVP,
- no ads,
- no trackers,
- no account,
- no remote backup unless explicitly added later,
- allow Delete All Data.

Optional later:
platform-secure backup.

---

# 27. Medical Safety UX

App must have a lightweight disclaimer under About:

```text
Serenity adalah alat bantu kebiasaan dan bukan pengganti
saran dokter atau tenaga kesehatan.
```

Medication screen must NOT calculate dosages.

Allowed content:

```text
Ada terapi dan obat yang dapat membantu berhenti merokok.
Tenaga kesehatan atau apoteker dapat membantu memilih opsi
yang sesuai untukmu.
```

Provide a generic CTA:

```text
Bicarakan dengan tenaga kesehatan
```

Do not prescribe:
- nicotine patch dose,
- nicotine gum dose,
- varenicline dose,
- bupropion dose.

Do not invent contraindications.

---

# 28. Accessibility

Minimum:
- respect text scaling,
- tap target >= 44 logical px,
- semantic labels,
- never use color as only status signal,
- dark mode,
- Reduce Motion support where practical.

---

# 29. Animation

Use sparingly.

Allowed:
- AnimatedSwitcher,
- AnimatedContainer,
- progress interpolation,
- subtle number transitions.

Avoid:
- constant particle effects,
- looping animations,
- expensive blur everywhere,
- huge custom painters repainting continuously.

Goal:
smooth on mid-range Android.

---

# 30. Performance Requirements

Important because UI should remain light.

- avoid rebuilding entire page from one counter update,
- use Riverpod selectors / small Consumer widgets,
- lazy list,
- isolate charts,
- no animation controller running while offscreen,
- avoid nested scroll views unless needed,
- avoid excessive backdrop filters,
- profile in Flutter DevTools.

Home idle screen must not continuously repaint.

---

# 31. Components

Reusable UI primitives:

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

Each component supports light/dark theme.

---

# 32. Example Home Widget Tree

```text
HomePage
└── CustomScrollView
    ├── GreetingHeader
    ├── TodaySummaryCard
    ├── QuickActions
    │   ├── LogSmokingButton
    │   └── CravingSosButton
    ├── PersonalWhyCard
    ├── TodayPatternSection
    └── RecentSmokingTimeline
```

Keep rebuild boundaries small.

---

# 33. MVP Scope

Must ship:

- onboarding,
- profile,
- smoking logging,
- trigger tagging,
- craving SOS,
- quit plan,
- motivation notes,
- dashboard,
- basic insights,
- smoke-free tracking,
- money calculation,
- local notifications,
- data export,
- dark/light theme.

Do NOT build yet:

- authentication,
- backend,
- social feed,
- public leaderboard,
- AI chat,
- cloud sync,
- doctor portal,
- subscriptions.

---

# 34. Phase 2 Ideas

Only after MVP works well:

- optional AI reflection on smoking patterns,
- encrypted sync,
- home screen widget,
- smartwatch quick craving action,
- partner/support mode,
- adaptive reminder based on trigger hours,
- richer analytics,
- localization.

---

# 35. Testing

## Unit

Must test:

```text
money saved calculation
cigarettes avoided calculation
current streak
longest streak
daily grouping
trigger aggregation
craving outcome
quit-plan state transition
```

## Repository

Use temporary/in-memory Drift database.

## Widget

Test:

```text
Home renders current day count
Log sheet saves record
SOS can finish as passed
Slip doesn't erase lifetime progress
Theme switches correctly
```

---

# 36. Acceptance Criteria

MVP is complete when:

1. Fresh install reaches onboarding.
2. User can complete or skip optional onboarding fields.
3. User can log a cigarette in <10 seconds.
4. Log survives app restart.
5. User can tag multiple triggers.
6. Home daily count updates reactively.
7. User can start and finish a craving SOS session.
8. User can define a quit date.
9. App handles a post-quit smoking event without destroying history.
10. Insight shows daily counts and top triggers.
11. User can store private motivations.
12. Money calculation uses user's own price data.
13. Notifications are opt-in.
14. All personal data can be deleted.
15. App works without internet.
16. `flutter analyze` passes.
17. `flutter test` passes.

---

# 37. Suggested Implementation Order for Codex

Implement one vertical slice at a time.

## Milestone 1

```text
Flutter project
Theme
Router
Drift setup
Riverpod setup
```

## Milestone 2

```text
Onboarding
Profile persistence
```

## Milestone 3

```text
Smoking log
Trigger system
Home count
Timeline
```

## Milestone 4

```text
Craving SOS
Craving history
```

## Milestone 5

```text
Quit plan
Quit mode
Slip handling
```

## Milestone 6

```text
Insights
Charts
Money calculation
Journey
```

## Milestone 7

```text
Notifications
Settings
Export/delete data
```

## Milestone 8

```text
Polish
Accessibility
Performance profiling
Tests
```

---

# 38. Codex Working Rules

Codex must:

- inspect existing code before editing,
- explain intended architecture briefly before large changes,
- keep files reasonably small,
- avoid god classes,
- avoid deeply nested widgets,
- prefer immutable domain models,
- never put SQL directly inside UI widgets,
- never put navigation logic inside repositories,
- never put DB objects directly into presentation if mapping is useful,
- add tests with each business-logic feature,
- run formatter,
- run analyzer,
- run tests,
- fix errors instead of suppressing analyzer warnings.

Commands:

```bash
dart format .
flutter analyze
flutter test
```

---

# 39. Visual QA Checklist

Before finishing a page:

```text
[ ] Looks good at 320px width
[ ] Looks good with large text
[ ] Dark mode readable
[ ] No clipped text
[ ] No unnecessary scroll nesting
[ ] Primary CTA obvious
[ ] Tap target large enough
[ ] Loading state
[ ] Empty state
[ ] Error state
[ ] Keyboard doesn't cover form action
```

---

# 40. Product Copy Rules

Prefer:

```text
Tercatat.
Mau coba lewatkan beberapa menit ini?
Kita lihat polanya.
Hari ini cukup fokus pada hari ini.
```

Avoid:

```text
Kamu gagal.
Kamu merusak streak.
Kurang disiplin.
Rokok membunuhmu.
Masa depanmu hancur.
```

The app must feel like an ally, not a judge.

---

# 41. Final Product Principle

When deciding between:

```text
more metrics
```

and

```text
one useful next action
```

always prefer the useful next action.

The user opens this app because they want their life to become less controlled by cigarettes.

Build for that.
