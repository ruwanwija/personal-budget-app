import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfm_budget_app/app/theme.dart';
import 'package:pfm_budget_app/core/providers/app_providers.dart';

class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  final _pinCtrl = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometrics());
  }

  Future<void> _tryBiometrics() async {
    final prefs = ref.read(preferencesProvider);
    if (!prefs.biometricsEnabled) return;
    final ok =
        await ref.read(appLockServiceProvider).authenticateWithBiometrics();
    if (ok && mounted) {
      ref.read(isUnlockedProvider.notifier).state = true;
    }
  }

  Future<void> _submitPin() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await ref
        .read(appLockServiceProvider)
        .verifyPin(_pinCtrl.text.trim());
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      ref.read(isUnlockedProvider.notifier).state = true;
    } else {
      setState(() => _error = 'Incorrect PIN. Please try again.');
      _pinCtrl.clear();
    }
  }

  @override
  void dispose() {
    _pinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(preferencesProvider);

    return Scaffold(
      backgroundColor: AppColors.brandDeepGreen,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 48,
                      color: AppColors.brandDeepGreen,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Unlock Personal Budget',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 18),
                    if (prefs.hasPin) ...[
                      TextField(
                        controller: _pinCtrl,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        onSubmitted: (_) => _submitPin(),
                        decoration: InputDecoration(
                          labelText: 'Enter PIN',
                          errorText: _error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _busy ? null : _submitPin,
                          child: const Text('Unlock with PIN'),
                        ),
                      ),
                    ],
                    if (prefs.biometricsEnabled) ...[
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _tryBiometrics,
                        icon: const Icon(Icons.fingerprint),
                        label: const Text('Use Biometrics'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
