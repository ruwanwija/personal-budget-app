import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pfm_budget_app/app/router.dart';
import 'package:pfm_budget_app/app/theme.dart';
import 'package:pfm_budget_app/core/providers/app_providers.dart';
import 'package:pfm_budget_app/features/security/presentation/app_lock_screen.dart';

class PfmBudgetApp extends ConsumerStatefulWidget {
  const PfmBudgetApp({super.key});

  @override
  ConsumerState<PfmBudgetApp> createState() => _PfmBudgetAppState();
}

class _PfmBudgetAppState extends ConsumerState<PfmBudgetApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = buildAppRouter();
  }

  @override
  Widget build(BuildContext context) {
    final bootstrap = ref.watch(appBootstrapProvider);
    final prefs = ref.watch(preferencesProvider);
    final isUnlocked = ref.watch(isUnlockedProvider);

    return MaterialApp.router(
      title: 'Personal Budget',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: prefs.themeMode,
      routerConfig: _router,
      builder: (context, child) {
        return bootstrap.when(
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (err, _) => Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Startup error: $err'),
              ),
            ),
          ),
          data: (_) {
            if (prefs.appLockEnabled && !isUnlocked) {
              return const AppLockScreen();
            }
            return child ?? const SizedBox.shrink();
          },
        );
      },
    );
  }
}
