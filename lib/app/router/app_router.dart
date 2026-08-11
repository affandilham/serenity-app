import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/foundation/presentation/pages/foundation_page.dart';

abstract final class AppRoutes {
  static const home = '/';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const FoundationPage(),
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
