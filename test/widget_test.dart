import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serenity_app/app/app.dart';

void main() {
  testWidgets('renders Serenity foundation screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SerenityApp()));

    expect(find.text('Serenity'), findsOneWidget);
    expect(
      find.text('Langkah kecil, ruang yang lebih tenang.'),
      findsOneWidget,
    );
  });
}
