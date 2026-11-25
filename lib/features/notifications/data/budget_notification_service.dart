import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pfm_budget_app/core/formatting/currency_formatter.dart';
import 'package:pfm_budget_app/core/preferences/app_preferences.dart';
import 'package:pfm_budget_app/features/budget/domain/variance_calculator.dart';

class BudgetNotificationService {
  BudgetNotificationService([FlutterLocalNotificationsPlugin? plugin])
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;
  final Set<String> _sentThresholdKeys = {};

  static const _channelId = 'pfm_budget_alerts';
  static const _channelName = 'Budget Alerts & Cycle Reminders';
  static const _channelDesc =
      'Notifications for custom budget cycle starts and 80%/100% subsection thresholds.';

  Future<void> initialize() async {
    if (_initialized || kIsWeb) return;
    try {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const settings = InitializationSettings(android: android, iOS: ios);
      await _plugin.initialize(settings);
      _initialized = true;
    } catch (e) {
      debugPrint('Notification initialization skipped: $e');
    }
  }

  Future<void> showCycleStartedNotification({
    required String cycleRangeLabel,
    required AppPreferencesState prefs,
  }) async {
    if (!prefs.notifyCycleStart) return;
    await _show(
      id: 1001,
      title: 'New Budget Cycle Started',
      body: 'Your active budget period ($cycleRangeLabel) is now live.',
    );
  }

  Future<void> checkAndNotifyThreshold({
    required int cycleId,
    required int subsectionId,
    required String subsectionName,
    required VarianceMetrics variance,
    required AppPreferencesState prefs,
  }) async {
    if (variance.thresholdAlert == BudgetThresholdAlert.none) return;

    if (variance.thresholdAlert == BudgetThresholdAlert.warning80 &&
        !prefs.notifyThreshold80) {
      return;
    }
    if (variance.thresholdAlert == BudgetThresholdAlert.exceeded100 &&
        !prefs.notifyThreshold100) {
      return;
    }

    final dedupKey = '$cycleId:$subsectionId:${variance.thresholdAlert.name}';
    if (_sentThresholdKeys.contains(dedupKey)) return;
    _sentThresholdKeys.add(dedupKey);

    final actualStr = CurrencyFormatter.format(
      variance.actual,
      style: prefs.currencyFormat,
    );
    final allocStr = CurrencyFormatter.format(
      variance.allocated,
      style: prefs.currencyFormat,
    );

    if (variance.thresholdAlert == BudgetThresholdAlert.exceeded100) {
      await _show(
        id: 2000 + subsectionId,
        title: '$subsectionName reached 100% of budget',
        body: 'Spent $actualStr of $allocStr allocated.',
      );
    } else {
      await _show(
        id: 3000 + subsectionId,
        title: '$subsectionName reached 80% of budget',
        body: 'Spent $actualStr of $allocStr allocated.',
      );
    }
  }

  Future<void> _show({
    required int id,
    required String title,
    required String body,
  }) async {
    if (kIsWeb) return;
    if (!_initialized) {
      await initialize();
    }
    if (!_initialized) return;
    try {
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      );
      await _plugin.show(id, title, body, details);
    } catch (e) {
      debugPrint('Failed to display notification: $e');
    }
  }
}
