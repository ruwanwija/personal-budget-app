import 'dart:convert';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pfm_budget_app/core/formatting/currency_formatter.dart';
import 'package:pfm_budget_app/features/budget/data/budget_repository.dart';
import 'package:pfm_budget_app/features/budget/domain/variance_calculator.dart';
import 'package:pfm_budget_app/features/meals/data/meal_repository.dart';
import 'package:pfm_budget_app/features/meals/domain/meal_calculator.dart';
import 'package:share_plus/share_plus.dart';

class ReportExportService {
  static final DateFormat _dateFmt = DateFormat('yyyy-MM-dd');
  static final DateFormat _prettyDate = DateFormat('MMM d, yyyy');

  /// Generates a CSV string containing cycle summary, variance table,
  /// shortfall notes, and weekly meal schedule.
  String buildCsvContent({
    required CycleBudgetSnapshot budget,
    required CycleMealPlanSnapshot meals,
    required CurrencyFormatStyle currencyFormat,
  }) {
    final rows = <List<dynamic>>[
      ['Personal Financial Management — Monthly Cycle Report'],
      [
        'Cycle Window',
        '${_prettyDate.format(budget.cycle.startDate)} - ${_prettyDate.format(budget.cycle.endDate)}',
      ],
      ['Status', budget.cycle.isClosed ? 'Archived (Closed)' : 'Active'],
      ['Base Salary', budget.cycle.salaryAmount],
      ['Supplementary Income', budget.guardrail.supplementaryIncome],
      ['Total Income', budget.totalIncome],
      ['Total Allocated', budget.totalCategoryAllocated],
      ['Total Actual', budget.totalActualSpend],
      ['Total Difference', budget.totalDifference],
      [],
      ['CATEGORY & SUBSECTION VARIANCE TABLE'],
      ['Category', 'Subsection', 'Parent Group', 'Allocated', 'Actual', 'Difference', 'Status'],
    ];

    void appendNode(String categoryName, SubsectionNode node, String parentName) {
      rows.add([
        categoryName,
        node.name,
        parentName,
        node.effectiveAllocated,
        node.effectiveActual,
        node.variance.difference,
        node.variance.isOverspent ? 'Overspent' : 'On/Under Budget',
      ]);
      for (final child in node.children) {
        appendNode(categoryName, child, node.name);
      }
    }

    for (final cat in budget.categories) {
      rows.add([
        cat.name,
        '(Category Total)',
        '',
        cat.allocatedAmount,
        cat.actualTotal,
        cat.variance.difference,
        cat.variance.isOverspent ? 'Overspent' : 'On/Under Budget',
      ]);
      for (final sub in cat.subsections) {
        appendNode(cat.name, sub, '');
      }
    }

    rows.add([]);
    rows.add(['SAVINGS SHORTFALL ACCOUNTABILITY']);
    rows.add([
      'Shortfall Active',
      budget.shortfall.isShortfallActive ? 'Yes' : 'No',
    ]);
    rows.add(['Shortfall Amount', budget.shortfall.shortfallAmount]);
    rows.add(['Reason for Shortfall', budget.shortfall.reasonText]);

    rows.add([]);
    rows.add(['WEEKLY MEAL SCHEDULE SUMMARY']);
    rows.add(['Week', 'Assigned Mode', 'Weekly Total']);
    for (final w in meals.weeks) {
      rows.add(['Week ${w.weekIndex}', w.modeName, w.effectiveTotal]);
    }
    rows.add(['Monthly Meal Rollup Total', '', meals.monthlyTotal]);

    return const ListToCsvConverter().convert(rows);
  }

  /// Builds a clean multi-section PDF document ready for sharing or saving.
  Future<Uint8List> buildPdfBytes({
    required CycleBudgetSnapshot budget,
    required CycleMealPlanSnapshot meals,
    required CurrencyFormatStyle currencyFormat,
  }) async {
    final doc = pw.Document();
    final headerColor = PdfColor.fromHex('#1B3B36');
    final greenColor = PdfColor.fromHex('#15803D');
    final redColor = PdfColor.fromHex('#DC2626');
    final lightBg = PdfColor.fromHex('#F4F7F6');

    String money(double v, {bool showPlus = false}) => CurrencyFormatter.format(
          v,
          style: currencyFormat,
          showPlusSign: showPlus,
        );

    final varianceRows = <List<String>>[];
    void collectNode(String catName, SubsectionNode node, int depth) {
      final indent = depth > 0 ? '  - ' : '';
      varianceRows.add([
        depth == 0 ? catName : '',
        '$indent${node.name}',
        money(node.effectiveAllocated),
        money(node.effectiveActual),
        money(node.variance.difference, showPlus: true),
      ]);
      for (final c in node.children) {
        collectNode(catName, c, depth + 1);
      }
    }

    for (final cat in budget.categories) {
      varianceRows.add([
        cat.name,
        'Category Total (${CurrencyFormatter.formatPercent(cat.shareOfIncome)})',
        money(cat.allocatedAmount),
        money(cat.actualTotal),
        money(cat.variance.difference, showPlus: true),
      ]);
      for (final sub in cat.subsections) {
        collectNode(cat.name, sub, 0);
      }
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: headerColor,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'PERSONAL FINANCIAL MANAGEMENT',
                      style: pw.TextStyle(
                        color: PdfColors.teal100,
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Monthly Budget Cycle Report',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      '${_prettyDate.format(budget.cycle.startDate)} - ${_prettyDate.format(budget.cycle.endDate)}',
                      style: const pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'TOTAL INCOME',
                      style: const pw.TextStyle(
                        color: PdfColors.teal100,
                        fontSize: 9,
                      ),
                    ),
                    pw.Text(
                      money(budget.totalIncome),
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 14),
          pw.Row(
            children: [
              _summaryBox('Allocated', money(budget.totalCategoryAllocated), lightBg),
              pw.SizedBox(width: 8),
              _summaryBox('Actual Spend', money(budget.totalActualSpend), lightBg),
              pw.SizedBox(width: 8),
              _summaryBox(
                'Net Variance',
                money(budget.totalDifference, showPlus: true),
                lightBg,
                valueColor: budget.totalDifference >= 0 ? greenColor : redColor,
              ),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            'Budget Breakdown & Variance',
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.TableHelper.fromTextArray(
            headers: ['Category', 'Item', 'Allocated', 'Actual', 'Difference'],
            data: varianceRows,
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 9,
            ),
            headerDecoration: pw.BoxDecoration(color: headerColor),
            cellStyle: const pw.TextStyle(fontSize: 8.5),
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
            },
          ),
          if (budget.shortfall.isShortfallActive) ...[
            pw.SizedBox(height: 16),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#FEF2F2'),
                border: pw.Border.all(color: redColor, width: 0.8),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Savings Shortfall Note (${money(budget.shortfall.shortfallAmount)} below target)',
                    style: pw.TextStyle(
                      color: redColor,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    budget.shortfall.reasonText.isEmpty
                        ? '(No reason recorded)'
                        : budget.shortfall.reasonText,
                    style: const pw.TextStyle(fontSize: 9.5),
                  ),
                ],
              ),
            ),
          ],
          pw.SizedBox(height: 16),
          pw.Text(
            'Mode-Wise Weekly Meal Schedule',
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.TableHelper.fromTextArray(
            headers: ['Week', 'Assigned Mode', 'Weekly Cost'],
            data: [
              for (final w in meals.weeks)
                ['Week ${w.weekIndex}', w.modeName, money(w.effectiveTotal)],
              ['Total', 'Synced to Food', money(meals.monthlyTotal)],
            ],
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 9,
            ),
            headerDecoration: pw.BoxDecoration(color: headerColor),
            cellStyle: const pw.TextStyle(fontSize: 9),
          ),
          pw.SizedBox(height: 14),
          for (final mode in meals.modes) ...[
            pw.Text(
              'Mode Template: ${mode.name} (Weekly: ${money(MealCalculator.computeTemplateWeeklyTotal(meals.templateByMode[mode.id] ?? const {}))})',
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.TableHelper.fromTextArray(
              headers: ['Meal', ...MealCalculator.shortDayNames],
              data: [
                for (final slot in MealSlot.values)
                  [
                    slot.label,
                    for (var d = 1; d <= 7; d++)
                      meals.templateByMode[mode.id]?[MealCellKey(d, slot)] == null
                          ? '-'
                          : money(
                              meals.templateByMode[mode.id]![MealCellKey(d, slot)]!,
                            ),
                  ],
              ],
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
                fontSize: 8,
              ),
              headerDecoration: pw.BoxDecoration(color: headerColor),
              cellStyle: const pw.TextStyle(fontSize: 8),
            ),
            pw.SizedBox(height: 10),
          ],
        ],
      ),
    );

    return doc.save();
  }

  pw.Widget _summaryBox(
    String label,
    String value,
    PdfColor bg, {
    PdfColor? valueColor,
  }) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: bg,
          borderRadius: pw.BorderRadius.circular(6),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(label, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
            pw.SizedBox(height: 3),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: valueColor ?? PdfColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> exportAndShareCsv({
    required CycleBudgetSnapshot budget,
    required CycleMealPlanSnapshot meals,
    required CurrencyFormatStyle currencyFormat,
  }) async {
    final csvStr = buildCsvContent(
      budget: budget,
      meals: meals,
      currencyFormat: currencyFormat,
    );
    final filename =
        'budget_report_${_dateFmt.format(budget.cycle.startDate)}.csv';
    final file = XFile.fromData(
      Uint8List.fromList(utf8.encode(csvStr)),
      name: filename,
      mimeType: 'text/csv',
    );
    await Share.shareXFiles(
      [file],
      subject: 'Monthly Budget Report (CSV)',
    );
  }

  Future<void> exportAndSharePdf({
    required CycleBudgetSnapshot budget,
    required CycleMealPlanSnapshot meals,
    required CurrencyFormatStyle currencyFormat,
  }) async {
    final bytes = await buildPdfBytes(
      budget: budget,
      meals: meals,
      currencyFormat: currencyFormat,
    );
    final filename =
        'budget_report_${_dateFmt.format(budget.cycle.startDate)}.pdf';
    final file = XFile.fromData(
      bytes,
      name: filename,
      mimeType: 'application/pdf',
    );
    await Share.shareXFiles(
      [file],
      subject: 'Monthly Budget Report (PDF)',
    );
  }
}
