import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/core/database/app_database.dart';
import 'package:serenity_app/core/database/database_provider.dart';
import 'package:serenity_app/features/craving/presentation/controllers/craving_providers.dart';
import 'package:serenity_app/features/craving/presentation/pages/craving_sos_page.dart';

void main() {
  testWidgets(
    'SOS can start and finish as passed without waiting five real minutes',
    (tester) async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      var now = DateTime(2026, 8, 11, 10);
      addTearDown(database.close);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(database),
            cravingClockProvider.overrideWithValue(() => now),
          ],
          child: const MaterialApp(home: CravingSosPage()),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Mulai 5 menit'));
      await tester.pump();
      await tester.pump();
      expect(find.text('Bernapas'), findsWidgets);

      now = now.add(const Duration(minutes: 5));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Sudah lewat'), findsOneWidget);

      await tester.tap(find.text('Sudah lewat'));
      await tester.pump();
      await tester.pump();

      final session = await database
          .select(database.cravingSessions)
          .getSingle();
      expect(session.outcome, 'passed');
      expect(session.finalIntensity, 3);
    },
  );
}
