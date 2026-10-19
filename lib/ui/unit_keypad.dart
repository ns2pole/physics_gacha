import 'package:flutter/material.dart';

import '../models/physics_problem.dart';
import 'calculator_frame.dart';
import 'math_expression_view.dart';
import 'unit_expression_view.dart';

const _unitLabelStyle = TextStyle(fontSize: 18, color: Colors.black87);

class UnitKeypad extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final preview = _preview;
    return CalculatorFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _UnitPreview(
            value: value.trim(),
            unit: preview.unit,
            hint: preview.hint,
          ),
          const SizedBox(height: 12),
          if (problem.unitInputKind == UnitInputKind.base)
            _BaseKeys(text: text, onTextChanged: onTextChanged)
          else
            _ChoiceKeys(
              choices: problem.unitChoices,
              selected: selectedChoice,
              onChoice: onChoice,
            ),
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
                    onPressed: onBack,
                    child: const Text('数値へ戻る'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: onConfirm == null
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
                    onPressed: onConfirm,
                    child: const Text('確定'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ({String unit, String hint}) get _preview {
    if (problem.unitInputKind == UnitInputKind.choices) {
      final selected = selectedChoice;
      if (selected == null) return (unit: '', hint: '単位を選ぶ');
      return (unit: selected, hint: '');
    }
    if (text.isEmpty) return (unit: '', hint: 'kg m s^-1 のように組み立てる');
    return (unit: text, hint: '');
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
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
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
