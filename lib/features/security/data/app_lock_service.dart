import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pfm_budget_app/core/preferences/app_preferences.dart';

class AppLockService {
  AppLockService({
    required this._preferences,
    LocalAuthentication? localAuth,
  })  : _localAuth = localAuth ?? LocalAuthentication();

  final AppPreferencesRepository _preferences;
  final LocalAuthentication _localAuth;

  Future<bool> isBiometricsAvailable() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      return canCheck || isSupported;
    } on PlatformException {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to unlock your Personal Budget',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> verifyPin(String pin) => _preferences.verifyPin(pin);
}
