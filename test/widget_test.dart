import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pfm_budget_app/app/app.dart';
import 'package:pfm_budget_app/app/theme.dart';
import 'package:pfm_budget_app/core/database/app_database.dart';
import 'package:pfm_budget_app/core/formatting/currency_formatter.dart';
import 'package:pfm_budget_app/core/preferences/app_preferences.dart';
import 'package:pfm_budget_app/core/providers/app_providers.dart';
import 'package:pfm_budget_app/features/budget/domain/shortfall_validator.dart';
import 'package:pfm_budget_app/features/budget/domain/variance_calculator.dart';
import 'package:pfm_budget_app/features/budget/presentation/widgets/shortfall_reason_box.dart';
import 'package:pfm_budget_app/features/budget/presentation/widgets/subsection_row.dart';

void main() {
  group('ShortfallReasonBox widget', () {
    testWidgets('disables field when target met and enables when shortfall occurs',
        (tester) async {
      final met = ShortfallValidator.evaluate(
        allocatedSavings: 15000,
        actualSavings: 15000,
        reasonText: '',
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: ShortfallReasonBox(
              shortfall: met,
              currencyFormat: CurrencyFormatStyle.slashEquals,
              onReasonChanged: (_) {},
            ),
          ),
        ),
      );

      var field = tester.widget<TextFormField>(
        find.byKey(const Key('shortfall_reason_field')),
      );
      expect(field.enabled, isFalse);
      expect(find.textContaining('Savings target met'), findsOneWidget);

      // Update to shortfall state
      final shortfall = ShortfallValidator.evaluate(
        allocatedSavings: 15000,
        actualSavings: 10000,
        reasonText: '',
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: ShortfallReasonBox(
              shortfall: shortfall,
              currencyFormat: CurrencyFormatStyle.slashEquals,
              onReasonChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      field = tester.widget<TextFormField>(
        find.byKey(const Key('shortfall_reason_field')),
      );
      expect(field.enabled, isTrue);
      expect(find.textContaining('5,000/='), findsOneWidget);
      expect(
        find.text('Required before closing this budget cycle'),
        findsOneWidget,
      );
    });
  });

  group('SubsectionRow widget', () {
    testWidgets('updates difference live and rejects negative input',
        (tester) async {
      const node = SubsectionNode(
        id: 1,
        categoryId: 2,
        parentId: null,
        name: 'Transport',
        rawAllocated: 8000,
        rawActual: 5000,
        isFoodLinked: false,
        sortOrder: 0,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: SubsectionRow(
              node: node,
              currencyFormat: CurrencyFormatStyle.slashEquals,
              readOnly: false,
              onValuesChanged: (_, _) {},
            ),
          ),
        ),
      );

      expect(find.text('+3,000/='), findsOneWidget);

      // Enter overspent actual value -> negative difference appears immediately
      await tester.enterText(find.byKey(const Key('actual_1')), '9500');
      await tester.pump();
      expect(find.text('-1,500/='), findsOneWidget);

      // Negative input attempt should be rejected by NonNegativeDecimalInputFormatter
      await tester.enterText(find.byKey(const Key('actual_1')), '-200');
      await tester.pump();
      final actualField =
          tester.widget<TextFormField>(find.byKey(const Key('actual_1')));
      expect(actualField.controller!.text.contains('-'), isFalse);

      // Flush debounce timer cleanly
      await tester.pump(const Duration(milliseconds: 200));
    });
  });

  group('PfmBudgetApp navigation smoke test', () {
    testWidgets('boots with seeded data and switches across bottom tabs',
        (tester) async {
      final db = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            keyValueStoreProvider.overrideWithValue(InMemoryKeyValueStore()),
          ],
          child: const PfmBudgetApp(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      // Dashboard renders starter 72,000/= salary and 3 categories
      expect(find.text('72,000/='), findsWidgets);
      expect(find.text('Savings and Investments'), findsOneWidget);

      // Navigate to Budget tab
      await tester.tap(find.text('Budget'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Budget Breakdown'), findsOneWidget);
      expect(find.byKey(const Key('shortfall_reason_field')), findsOneWidget);

      // Navigate to Meals tab
      await tester.tap(find.text('Meals'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Weekly Meal Planner'), findsOneWidget);
      expect(find.text('Not Go Home'), findsWidgets);
      expect(find.text('Go Home'), findsWidgets);

      // Navigate to History & Settings tabs
      await tester.tap(find.text('History'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('History & Reports'), findsOneWidget);

      await tester.tap(find.text('Settings'));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Custom Month Start Day'), findsOneWidget);

      // Unmount widget tree and close DB synchronously
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      await db.close();
    });
  });
}
