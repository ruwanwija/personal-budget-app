import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:pfm_budget_app/app/theme.dart';
import 'package:pfm_budget_app/core/formatting/currency_formatter.dart';
import 'package:pfm_budget_app/features/budget/domain/variance_calculator.dart';

class SubsectionRow extends StatefulWidget {
  const SubsectionRow({
    super.key,
    required this.node,
    required this.currencyFormat,
    required this.readOnly,
    required this.onValuesChanged,
    this.onOpenEntries,
    this.onOpenMeals,
    this.onAddChild,
    this.onRename,
    this.onDelete,
    this.indent = false,
  });

  final SubsectionNode node;
  final CurrencyFormatStyle currencyFormat;
  final bool readOnly;
  final void Function(double? allocated, double? actual) onValuesChanged;
  final VoidCallback? onOpenEntries;
  final VoidCallback? onOpenMeals;
  final VoidCallback? onAddChild;
  final VoidCallback? onRename;
  final VoidCallback? onDelete;
  final bool indent;

  @override
  State<SubsectionRow> createState() => _SubsectionRowState();
}

class _SubsectionRowState extends State<SubsectionRow> {
  late final TextEditingController _allocatedCtrl;
  late final TextEditingController _actualCtrl;
  final FocusNode _allocatedFocus = FocusNode();
  final FocusNode _actualFocus = FocusNode();
  Timer? _debounce;

  late double _localAllocated;
  late double _localActual;

  @override
  void initState() {
    super.initState();
    _localAllocated = widget.node.rawAllocated;
    _localActual = widget.node.rawActual;
    _allocatedCtrl = TextEditingController(
      text: CurrencyFormatter.formatCompactInput(_localAllocated),
    );
    _actualCtrl = TextEditingController(
      text: CurrencyFormatter.formatCompactInput(_localActual),
    );
  }

  @override
  void didUpdateWidget(covariant SubsectionRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_allocatedFocus.hasFocus &&
        (widget.node.rawAllocated - _localAllocated).abs() > 0.001) {
      _localAllocated = widget.node.rawAllocated;
      _allocatedCtrl.text = CurrencyFormatter.formatCompactInput(_localAllocated);
    }
    if (!_actualFocus.hasFocus &&
        (widget.node.rawActual - _localActual).abs() > 0.001) {
      _localActual = widget.node.rawActual;
      _actualCtrl.text = CurrencyFormatter.formatCompactInput(_localActual);
    }
  }

  void _onAllocatedEdited(String raw) {
    final parsed = double.tryParse(raw.trim()) ?? 0.0;
    if (parsed < 0) return;
    setState(() => _localAllocated = parsed);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 120), () {
      widget.onValuesChanged(parsed, null);
    });
  }

  void _onActualEdited(String raw) {
    final parsed = double.tryParse(raw.trim()) ?? 0.0;
    if (parsed < 0) return;
    setState(() => _localActual = parsed);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 120), () {
      widget.onValuesChanged(null, parsed);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _allocatedCtrl.dispose();
    _actualCtrl.dispose();
    _allocatedFocus.dispose();
    _actualFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metrics = VarianceCalculator.compute(_localAllocated, _localActual);
    final diffColor = AppTheme.varianceColor(context, metrics.difference);
    final diffBg = AppTheme.varianceBackground(context, metrics.difference);

    return Container(
      padding: EdgeInsets.only(
        left: widget.indent ? 20 : 12,
        right: 8,
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.16)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.indent)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    Icons.subdirectory_arrow_right_rounded,
                    size: 16,
                    color: Colors.grey.shade500,
                  ),
                ),
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      widget.node.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (widget.node.isFoodLinked)
                      InkWell(
                        onTap: widget.onOpenMeals,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.brandMint,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.restaurant_menu,
                                size: 12,
                                color: AppColors.brandDeepGreen,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Meal Sync',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.brandDeepGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (widget.node.entryCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${widget.node.entryCount} logged',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                  ],
                ),
              ),
              if (!widget.readOnly && widget.onOpenEntries != null)
                IconButton(
                  tooltip: 'Itemized expense entries',
                  icon: const Icon(Icons.receipt_long_outlined, size: 19),
                  visualDensity: VisualDensity.compact,
                  onPressed: widget.onOpenEntries,
                ),
              if (!widget.readOnly)
                PopupMenuButton<String>(
                  iconSize: 19,
                  padding: EdgeInsets.zero,
                  onSelected: (value) {
                    if (value == 'child') widget.onAddChild?.call();
                    if (value == 'rename') widget.onRename?.call();
                    if (value == 'delete') widget.onDelete?.call();
                  },
                  itemBuilder: (context) => [
                    if (!widget.indent && widget.onAddChild != null)
                      const PopupMenuItem(
                        value: 'child',
                        child: Text('Add Nested Sub-item'),
                      ),
                    if (widget.onRename != null)
                      const PopupMenuItem(
                        value: 'rename',
                        child: Text('Rename'),
                      ),
                    if (widget.onDelete != null)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete',
                          style: TextStyle(color: AppColors.negativeRed),
                        ),
                      ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  key: Key('alloc_${widget.node.id}'),
                  controller: _allocatedCtrl,
                  focusNode: _allocatedFocus,
                  enabled: !widget.readOnly,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [NonNegativeDecimalInputFormatter()],
                  onChanged: _onAllocatedEdited,
                  style: const TextStyle(fontSize: 13),
                  decoration: const InputDecoration(
                    labelText: 'Allocated',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: TextFormField(
                  key: Key('actual_${widget.node.id}'),
                  controller: _actualCtrl,
                  focusNode: _actualFocus,
                  enabled: !widget.readOnly,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [NonNegativeDecimalInputFormatter()],
                  onChanged: _onActualEdited,
                  style: const TextStyle(fontSize: 13),
                  decoration: const InputDecoration(
                    labelText: 'Actual',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: Container(
                  key: Key('diff_${widget.node.id}'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: diffBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Difference',
                        style: TextStyle(
                          fontSize: 10,
                          color: diffColor.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(
                          metrics.difference,
                          style: widget.currencyFormat,
                          showPlusSign: true,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: diffColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NestedSubsectionTile extends StatelessWidget {
  const NestedSubsectionTile({
    super.key,
    required this.parentNode,
    required this.currencyFormat,
    required this.readOnly,
    required this.childBuilder,
    this.onAddChild,
    this.onRenameParent,
    this.onDeleteParent,
  });

  final SubsectionNode parentNode;
  final CurrencyFormatStyle currencyFormat;
  final bool readOnly;
  final Widget Function(SubsectionNode child) childBuilder;
  final VoidCallback? onAddChild;
  final VoidCallback? onRenameParent;
  final VoidCallback? onDeleteParent;

  @override
  Widget build(BuildContext context) {
    final v = parentNode.variance;
    final diffColor = AppTheme.varianceColor(context, v.difference);
    final diffBg = AppTheme.varianceBackground(context, v.difference);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.16)),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          childrenPadding: const EdgeInsets.only(bottom: 6),
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          parentNode.name,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '(${parentNode.children.length} items)',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Alloc: ${CurrencyFormatter.format(v.allocated, style: currencyFormat)}  •  Actual: ${CurrencyFormatter.format(v.actual, style: currencyFormat)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: diffBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  CurrencyFormatter.format(
                    v.difference,
                    style: currencyFormat,
                    showPlusSign: true,
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: diffColor,
                  ),
                ),
              ),
            ],
          ),
          children: [
            ...parentNode.children.map(childBuilder),
            if (!readOnly)
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 12, top: 4),
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: onAddChild,
                      icon: const Icon(Icons.add, size: 16),
                      label: Text('Add to ${parentNode.name}'),
                    ),
                    const Spacer(),
                    if (onRenameParent != null)
                      IconButton(
                        tooltip: 'Rename group',
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        onPressed: onRenameParent,
                      ),
                    if (onDeleteParent != null)
                      IconButton(
                        tooltip: 'Delete group',
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: AppColors.negativeRed,
                        ),
                        onPressed: onDeleteParent,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
