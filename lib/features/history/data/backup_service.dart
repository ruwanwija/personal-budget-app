import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pfm_budget_app/core/database/app_database.dart';
import 'package:share_plus/share_plus.dart';

class BackupService {
  BackupService(this._db);

  final AppDatabase _db;
  static const int backupFormatVersion = 1;

  /// Serializes the entire SQLite database into a portable JSON string.
  Future<String> exportToJsonString() async {
    final payload = {
      'version': backupFormatVersion,
      'exported_at': DateTime.now().toIso8601String(),
      'budget_cycles': (await _db.select(_db.budgetCycles).get())
          .map((e) => e.toJson())
          .toList(),
      'supplementary_incomes':
          (await _db.select(_db.supplementaryIncomes).get())
              .map((e) => e.toJson())
              .toList(),
      'categories': (await _db.select(_db.categories).get())
          .map((e) => e.toJson())
          .toList(),
      'subsections': (await _db.select(_db.subsections).get())
          .map((e) => e.toJson())
          .toList(),
      'subsection_entries': (await _db.select(_db.subsectionEntries).get())
          .map((e) => e.toJson())
          .toList(),
      'savings_shortfall_logs':
          (await _db.select(_db.savingsShortfallLogs).get())
              .map((e) => e.toJson())
              .toList(),
      'meal_modes': (await _db.select(_db.mealModes).get())
          .map((e) => e.toJson())
          .toList(),
      'meal_schedule_entries':
          (await _db.select(_db.mealScheduleEntries).get())
              .map((e) => e.toJson())
              .toList(),
      'weekly_mode_assignments':
          (await _db.select(_db.weeklyModeAssignments).get())
              .map((e) => e.toJson())
              .toList(),
      'weekly_meal_overrides':
          (await _db.select(_db.weeklyMealOverrides).get())
              .map((e) => e.toJson())
              .toList(),
      'default_category_templates':
          (await _db.select(_db.defaultCategoryTemplates).get())
              .map((e) => e.toJson())
              .toList(),
      'default_subsection_templates':
          (await _db.select(_db.defaultSubsectionTemplates).get())
              .map((e) => e.toJson())
              .toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  /// Restores a complete JSON backup transactionally, preserving IDs & foreign keys.
  Future<void> restoreFromJsonString(String jsonContent) async {
    final decoded = jsonDecode(jsonContent);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid backup format: root must be a JSON object.');
    }
    if (decoded['version'] != backupFormatVersion) {
      throw const FormatException('Unsupported backup format version.');
    }

    await _db.transaction(() async {
      // Clear tables in reverse FK dependency order
      await _db.delete(_db.weeklyMealOverrides).go();
      await _db.delete(_db.weeklyModeAssignments).go();
      await _db.delete(_db.mealScheduleEntries).go();
      await _db.delete(_db.mealModes).go();
      await _db.delete(_db.savingsShortfallLogs).go();
      await _db.delete(_db.subsectionEntries).go();
      await _db.delete(_db.subsections).go();
      await _db.delete(_db.categories).go();
      await _db.delete(_db.supplementaryIncomes).go();
      await _db.delete(_db.budgetCycles).go();
      await _db.delete(_db.defaultSubsectionTemplates).go();
      await _db.delete(_db.defaultCategoryTemplates).go();

      List<Map<String, dynamic>> listOf(String key) {
        final raw = decoded[key];
        if (raw is! List) return const [];
        return raw.cast<Map<String, dynamic>>();
      }

      for (final row in listOf('budget_cycles')) {
        await _db.into(_db.budgetCycles).insert(BudgetCycle.fromJson(row));
      }
      for (final row in listOf('supplementary_incomes')) {
        await _db
            .into(_db.supplementaryIncomes)
            .insert(SupplementaryIncome.fromJson(row));
      }
      for (final row in listOf('categories')) {
        await _db.into(_db.categories).insert(Category.fromJson(row));
      }

      // Insert parent subsections before child subsections to satisfy self-FK
      final subRows = listOf('subsections');
      final parents = subRows.where((r) => r['parentId'] == null).toList();
      final children = subRows.where((r) => r['parentId'] != null).toList();
      for (final row in parents) {
        await _db.into(_db.subsections).insert(Subsection.fromJson(row));
      }
      for (final row in children) {
        await _db.into(_db.subsections).insert(Subsection.fromJson(row));
      }

      for (final row in listOf('subsection_entries')) {
        await _db
            .into(_db.subsectionEntries)
            .insert(SubsectionEntry.fromJson(row));
      }
      for (final row in listOf('savings_shortfall_logs')) {
        await _db
            .into(_db.savingsShortfallLogs)
            .insert(SavingsShortfallLog.fromJson(row));
      }
      for (final row in listOf('meal_modes')) {
        await _db.into(_db.mealModes).insert(MealMode.fromJson(row));
      }
      for (final row in listOf('meal_schedule_entries')) {
        await _db
            .into(_db.mealScheduleEntries)
            .insert(MealScheduleEntry.fromJson(row));
      }
      for (final row in listOf('weekly_mode_assignments')) {
        await _db
            .into(_db.weeklyModeAssignments)
            .insert(WeeklyModeAssignment.fromJson(row));
      }
      for (final row in listOf('weekly_meal_overrides')) {
        await _db
            .into(_db.weeklyMealOverrides)
            .insert(WeeklyMealOverride.fromJson(row));
      }
      for (final row in listOf('default_category_templates')) {
        await _db
            .into(_db.defaultCategoryTemplates)
            .insert(DefaultCategoryTemplate.fromJson(row));
      }

      final tplRows = listOf('default_subsection_templates');
      final tplParents =
          tplRows.where((r) => r['parentTemplateId'] == null).toList();
      final tplChildren =
          tplRows.where((r) => r['parentTemplateId'] != null).toList();
      for (final row in tplParents) {
        await _db
            .into(_db.defaultSubsectionTemplates)
            .insert(DefaultSubsectionTemplate.fromJson(row));
      }
      for (final row in tplChildren) {
        await _db
            .into(_db.defaultSubsectionTemplates)
            .insert(DefaultSubsectionTemplate.fromJson(row));
      }
    });
  }

  Future<void> exportAndShareJsonBackup() async {
    final jsonStr = await exportToJsonString();
    final stamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = XFile.fromData(
      Uint8List.fromList(utf8.encode(jsonStr)),
      name: 'pfm_budget_backup_$stamp.json',
      mimeType: 'application/json',
    );
    await Share.shareXFiles(
      [file],
      subject: 'PFM Budget Backup (JSON)',
    );
  }
}
