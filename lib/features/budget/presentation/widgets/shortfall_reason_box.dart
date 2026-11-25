import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:pfm_budget_app/app/theme.dart';
import 'package:pfm_budget_app/core/formatting/currency_formatter.dart';
import 'package:pfm_budget_app/features/budget/domain/shortfall_validator.dart';

class ShortfallReasonBox extends StatefulWidget {
  const ShortfallReasonBox({
    super.key,
    required this.shortfall,
    required this.currencyFormat,
    required this.onReasonChanged,
    this.readOnly = false,
  });

  final ShortfallEvaluation shortfall;
  final CurrencyFormatStyle currencyFormat;
  final ValueChanged<String> onReasonChanged;
  final bool readOnly;

  @override
  State<ShortfallReasonBox> createState() => _ShortfallReasonBoxState();
}

class _ShortfallReasonBoxState extends State<ShortfallReasonBox> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.shortfall.reasonText);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant ShortfallReasonBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus &&
        widget.shortfall.reasonText != _controller.text) {
      _controller.text = widget.shortfall.reasonText;
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _debounce?.cancel();
      widget.onReasonChanged(_controller.text);
    }
  }

  void _handleTextChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      widget.onReasonChanged(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.shortfall.isShortfallActive;
    final shortfallFormatted = CurrencyFormatter.format(
      widget.shortfall.shortfallAmount,
      style: widget.currencyFormat,
    );

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active
              ? AppTheme.varianceBackground(context, -1)
              : Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active
                ? AppColors.negativeRed.withValues(alpha: 0.6)
                : Colors.grey.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  active
                      ? Icons.warning_amber_rounded
                      : Icons.verified_outlined,
                  size: 18,
                  color: active
                      ? AppColors.negativeRed
                      : AppColors.positiveGreen,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    active
                        ? 'Savings Shortfall: $shortfallFormatted below target'
                        : 'Savings target met — shortfall reason disabled',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: active
                              ? AppColors.negativeRed
                              : AppColors.positiveGreen,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('shortfall_reason_field'),
              controller: _controller,
              focusNode: _focusNode,
              enabled: active && !widget.readOnly,
              readOnly: widget.readOnly,
              minLines: active ? 2 : 1,
              maxLines: active ? 4 : 1,
              onChanged: _handleTextChanged,
              decoration: InputDecoration(
                labelText: 'Reason for Shortfall',
                hintText: active
                    ? 'Explain why actual savings fell below your allocated target...'
                    : 'Automatically enabled if actual savings < allocated target',
                errorText: active && _controller.text.trim().isEmpty
                    ? 'Required before closing this budget cycle'
                    : null,
                fillColor: active
                    ? Theme.of(context).colorScheme.surface
                    : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
