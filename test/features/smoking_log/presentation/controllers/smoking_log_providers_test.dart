import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/core/database/app_database.dart';
import 'package:serenity_app/core/database/database_provider.dart';
import 'package:serenity_app/features/smoking_log/presentation/controllers/smoking_log_providers.dart';

void main() {
  test(
    'quick-log controller updates the scoped today-count provider',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
          smokingLogClockProvider.overrideWithValue(
            () => DateTime(2026, 8, 11, 8, 12),
          ),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(database.close);

      final countUpdates = <int>[];
      final countIsOne = Completer<void>();
      final subscription = container.listen<AsyncValue<int>>(
        todaySmokingCountProvider,
        (_, next) {
          final count = next.valueOrNull;
          if (count == null) {
            return;
          }
          countUpdates.add(count);
          if (count == 1 && !countIsOne.isCompleted) {
            countIsOne.complete();
          }
        },
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      await container
          .read(smokingLogControllerProvider.notifier)
          .addQuickLog(triggerIds: {'coffee'}, cravingLevel: 3);

      await countIsOne.future.timeout(const Duration(seconds: 1));
      expect(countUpdates, containsAllInOrder([0, 1]));
      expect(
        container.read(smokingLogControllerProvider),
        isA<AsyncData<void>>(),
      );
    },
  );
}
