import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

import '../models/physics_problem.dart';
import 'calculator_frame.dart';
import 'math_expression_view.dart';
import 'unit_expression_view.dart';

const _unitLabelStyle = TextStyle(fontSize: 18, color: Colors.black87);

const _unitPrefixes = ['p', 'n', 'μ', 'm', 'k'];

class UnitKeypad extends StatefulWidget {
  const UnitKeypad({
    super.key,
    required this.problem,
    required this.value,
    required this.text,
    required this.selectedChoice,
    required this.onTextChanged,
    required this.onChoice,
    required this.onBack,
    required this.onConfirm,
  });

  final PhysicsProblem problem;
  final String value;
  final String text;
  final String? selectedChoice;
  final ValueChanged<String> onTextChanged;
  final ValueChanged<String> onChoice;
  final VoidCallback onBack;
  final VoidCallback? onConfirm;

  @override
  State<UnitKeypad> createState() => _UnitKeypadState();
}

class _UnitKeypadState extends State<UnitKeypad> {
  String _prefix = '';

  @override
  void initState() {
    super.initState();
    _prefix = _prefixOf(widget.selectedChoice);
  }

  @override
  void didUpdateWidget(UnitKeypad oldWidget) {
    super.didUpdateWidget(oldWidget);
    final problemChanged = widget.problem.id != oldWidget.problem.id;
    final choiceChanged = widget.selectedChoice != oldWidget.selectedChoice;
    if (problemChanged || (choiceChanged && widget.selectedChoice != null)) {
      _prefix = _prefixOf(widget.selectedChoice);
    }
  }

  @override
  Widget build(BuildContext context) {
    final preview = _preview(context);
    final selectedBase = _baseOf(widget.selectedChoice);
    return CalculatorFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _UnitPreview(
            value: widget.value.trim(),
            unit: preview.unit,
            hint: preview.hint,
          ),
          const SizedBox(height: 12),
          if (widget.problem.unitInputKind == UnitInputKind.base)
            _BaseKeys(text: widget.text, onTextChanged: widget.onTextChanged)
          else ...[
            _PrefixKeys(
              selected: _prefix,
              onPrefix: _tapPrefix,
              onClear: _prefix.isEmpty ? null : _clearPrefix,
            ),
            const SizedBox(height: 6),
            _ChoiceKeys(
              choices: widget.problem.unitChoices,
              selected: selectedBase,
              onChoice: _tapChoice,
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: widget.onBack,
                    child: Text(AppLocalizations.of(context)!.backToNumbers),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.onConfirm == null
                          ? Colors.grey.shade300
                          : Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: widget.onConfirm,
                    child: Text(AppLocalizations.of(context)!.confirm),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _tapPrefix(String prefix) {
    if (_prefix == prefix) return;
    setState(() => _prefix = prefix);
    final base = _baseOf(widget.selectedChoice);
    if (base != null) widget.onChoice(_compose(prefix, base));
  }

  void _clearPrefix() {
    if (_prefix.isEmpty) return;
    setState(() => _prefix = '');
    final base = _baseOf(widget.selectedChoice);
    if (base != null) widget.onChoice(base);
  }

  void _tapChoice(String choice) {
    widget.onChoice(_compose(_prefix, choice));
  }

  ({String unit, String hint}) _preview(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.problem.unitInputKind == UnitInputKind.choices) {
      final selected = widget.selectedChoice;
      if (selected == null) return (unit: '', hint: l10n.selectUnit);
      return (unit: selected, hint: '');
    }
    if (widget.text.isEmpty) return (unit: '', hint: l10n.assembleUnitHint);
    return (unit: widget.text, hint: '');
  }

  String _compose(String prefix, String base) {
    if (prefix.isEmpty || base == '1' || base == '無次元') return base;
    return '$prefix$base';
  }

  String _prefixOf(String? selected) {
    final base = _baseOf(selected);
    if (selected == null || base == null || selected == base) return '';
    for (final prefix in _unitPrefixes) {
      if (selected == '$prefix$base') return prefix;
    }
    return '';
  }

  String? _baseOf(String? selected) {
    if (selected == null || selected.isEmpty) return null;
    final choices = widget.problem.unitChoices;
    if (choices.contains(selected)) return selected;
    for (final prefix in _unitPrefixes) {
      if (!selected.startsWith(prefix)) continue;
      final base = selected.substring(prefix.length);
      if (choices.contains(base)) return base;
    }
    return null;
  }
}

class _UnitPreview extends StatelessWidget {
  const _UnitPreview({
    required this.value,
    required this.unit,
    required this.hint,
  });

  final String value;
  final String unit;
  final String hint;

  static const _valueStyle = TextStyle(fontSize: 26, color: Colors.black87);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (value.isNotEmpty)
              MathExpressionView(expression: value, style: _valueStyle),
            if (value.isNotEmpty && (unit.isNotEmpty || hint.isNotEmpty))
              const SizedBox(width: 8),
            if (unit.isNotEmpty)
              UnitExpressionView(unit: unit, style: _valueStyle)
            else if (hint.isNotEmpty)
              Text(
                hint,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
              ),
          ],
        ),
      ),
    );
  }
}

class _PrefixKeys extends StatelessWidget {
  const _PrefixKeys({
    required this.selected,
    required this.onPrefix,
    required this.onClear,
  });

  final String selected;
  final ValueChanged<String> onPrefix;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    const perRow = 4;
    final labels = [..._unitPrefixes, '×'];
    while (labels.length % perRow != 0) {
      labels.insert(labels.length - 1, '');
    }
    final rowCount = labels.length ~/ perRow;
    return Column(
      children: [
        for (var row = 0; row < rowCount; row++) ...[
          if (row > 0) const SizedBox(height: 6),
          Row(
            children: [
              for (var column = 0; column < perRow; column++) ...[
                if (column > 0) const SizedBox(width: 6),
                Expanded(child: _cell(labels[row * perRow + column])),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _cell(String label) {
    if (label.isEmpty) return const SizedBox(height: 48);
    if (label == '×') {
      return _UnitButton(
        key: const ValueKey('unit-prefix-clear'),
        label: '×',
        background: onClear == null ? Colors.grey.shade300 : Colors.orange,
        foreground: Colors.white,
        bold: true,
        onPressed: onClear,
      );
    }
    return _UnitButton(
      key: ValueKey('unit-prefix-$label'),
      label: label,
      background: selected == label ? Colors.lightBlue.shade300 : Colors.white,
      onPressed: () => onPrefix(label),
    );
  }
}

class _ChoiceKeys extends StatelessWidget {
  const _ChoiceKeys({
    required this.choices,
    required this.selected,
    required this.onChoice,
  });

  final List<String> choices;
  final String? selected;
  final ValueChanged<String> onChoice;

  @override
  Widget build(BuildContext context) {
    const perRow = 4;
    final rowCount = (choices.length / perRow).ceil();
    return Column(
      children: [
        for (var row = 0; row < rowCount; row++) ...[
          if (row > 0) const SizedBox(height: 6),
          Row(
            children: [
              for (var column = 0; column < perRow; column++) ...[
                if (column > 0) const SizedBox(width: 6),
                Expanded(child: _slot(row * perRow + column)),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _slot(int index) {
    if (index >= choices.length) return const SizedBox(height: 48);
    final choice = choices[index];
    final selectedThis = selected == choice;
    return _UnitButton(
      key: ValueKey('unit-choice-$choice'),
      label: choice,
      background: selectedThis ? Colors.lightBlue.shade300 : Colors.white,
      onPressed: () => onChoice(choice),
    );
  }
}

class _BaseKeys extends StatelessWidget {
  const _BaseKeys({required this.text, required this.onTextChanged});

  final String text;
  final ValueChanged<String> onTextChanged;

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['kg', 'm', 'kg^-1', 'm^-1'],
      ['s', 'A', 's^-1', 'A^-1'],
    ];
    return Column(
      children: [
        for (final row in rows) ...[
          Row(
            children: [
              for (var i = 0; i < row.length; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(
                  child: _UnitButton(
                    label: row[i],
                    background: Colors.white,
                    onPressed: () => onTextChanged(_append(row[i])),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
        ],
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 72,
            child: _UnitButton(
              label: '⌫',
              background: Colors.orange,
              foreground: Colors.white,
              bold: true,
              onPressed: () => onTextChanged(_dropLast()),
            ),
          ),
        ),
      ],
    );
  }

  String _append(String token) => text.isEmpty ? token : '$text $token';

  String _dropLast() {
    final tokens = text
        .split(RegExp(r'\s+'))
        .where((token) => token.isNotEmpty)
        .toList();
    if (tokens.isEmpty) return '';
    tokens.removeLast();
    return tokens.join(' ');
  }
}

class _UnitButton extends StatelessWidget {
  const _UnitButton({
    super.key,
    required this.label,
    required this.background,
    required this.onPressed,
    this.foreground = Colors.black87,
    this.bold = false,
  });

  final String label;
  final Color background;
  final Color foreground;
  final bool bold;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          disabledBackgroundColor: background,
          foregroundColor: foreground,
          disabledForegroundColor: foreground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: background == Colors.white
                  ? Colors.grey.shade300
                  : background,
            ),
          ),
        ),
        onPressed: onPressed,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: UnitExpressionView(
            unit: label,
            style: _unitLabelStyle.copyWith(
              color: foreground,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              fontSize: bold ? 20 : 18,
            ),
          ),
        ),
      ),
    );
  }
}
