import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/app/app.dart';
import 'package:serenity_app/core/database/app_database.dart';
import 'package:serenity_app/core/database/database_provider.dart';
import 'package:drift/native.dart';

void main() {
  testWidgets('fresh Serenity install completes the five-step onboarding', (
    tester,
  ) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(database)],
        child: const SerenityApp(),
      ),
    );
    expect(find.byType(Image), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.text('Serenity'), findsOneWidget);
    expect(
      find.text('Kita nggak perlu menyelesaikan semuanya hari ini.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Mulai'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '10');
    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Saya mau mengurangi dulu'));
    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Keluarga'));
    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();

    expect(find.text('Tidak harus sempurna.'), findsOneWidget);
    await tester.tap(find.text('Simpan dan mulai'));
    await tester.pumpAndSettle();

    expect(find.text('Hari ini'), findsOneWidget);

    await tester.tap(find.text('+ Catat rokok'));
    await tester.pumpAndSettle();
    expect(find.text('Catat rokok'), findsOneWidget);
    await tester.tap(find.text('Catat'));
    await tester.pumpAndSettle();

    expect(find.text('1 batang'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
