import 'package:flutter/material.dart';

import 'calculator_frame.dart';
import 'expression_editor.dart';
import 'math_expression_view.dart';

const _keyLabelStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w500,
  height: 1.1,
  color: Colors.black87,
);

class NumericKeypad extends StatelessWidget {
  const NumericKeypad({
    super.key,
    required this.editor,
    required this.onChanged,
    required this.onNext,
  });

  final ExpressionEditor editor;
  final VoidCallback onChanged;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return CalculatorFrame(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _ExpressionPreview(editor: editor)),
              const SizedBox(width: 6),
              SizedBox(
                width: 52,
                height: 52,
                child: _KeyButton(
                  keyData: _Key('−', editor.toggleSign),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _KeyRow(
            onChanged: onChanged,
            keys: [
              _Key('7', () => editor.insert('7')),
              _Key('8', () => editor.insert('8')),
              _Key('9', () => editor.insert('9')),
              _Key(
                'AC',
                editor.clear,
                filled: true,
                color: const Color(0xFFD32F2F),
              ),
            ],
          ),
          _KeyRow(
            onChanged: onChanged,
            keys: [
              _Key('4', () => editor.insert('4')),
              _Key('5', () => editor.insert('5')),
              _Key('6', () => editor.insert('6')),
              _Key('', editor.backspace, icon: Icons.backspace_outlined),
            ],
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _KeyRow(
                        onChanged: onChanged,
                        keys: [
                          _Key('1', () => editor.insert('1')),
                          _Key('2', () => editor.insert('2')),
                          _Key('3', () => editor.insert('3')),
                        ],
                      ),
                      _KeyRow(
                        onChanged: onChanged,
                        keys: [
                          _Key('0', () => editor.insert('0')),
                          _Key('.', () => editor.insert('.')),
                          _Key('×10^□', editor.insertPowerOfTen),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: _KeyButton(
                      keyData: _Key('単位へ', onNext, filled: true),
                      onChanged: onChanged,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Key {
  const _Key(
    this.label,
    this.onPressed, {
    this.filled = false,
    this.icon,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool filled;
  final IconData? icon;
  final Color? color;

  Widget get face {
    if (icon != null) {
      return Icon(icon, size: 26, color: color ?? Colors.black87);
    }
    final style = _keyLabelStyle.copyWith(color: filled ? Colors.white : color);
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: label == '×10^□'
          ? _PowerOfTenLabel(style: style)
          : Text(label, style: style),
    );
  }
}

class _PowerOfTenLabel extends StatelessWidget {
  const _PowerOfTenLabel({required this.style});

  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final fontSize = style.fontSize ?? 22;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('×10', style: style.copyWith(height: 1)),
        Padding(
          padding: EdgeInsets.only(bottom: fontSize * 0.42),
          child: Text(
            '□',
            style: style.copyWith(fontSize: fontSize * 0.62, height: 1),
          ),
        ),
      ],
    );
  }
}

class _KeyRow extends StatelessWidget {
  const _KeyRow({required this.keys, required this.onChanged});

  final List<_Key> keys;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final key in keys)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: SizedBox(
                height: 44,
                child: _KeyButton(keyData: key, onChanged: onChanged),
              ),
            ),
          ),
      ],
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({required this.keyData, required this.onChanged});

  final _Key keyData;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final pressed = keyData.onPressed == null
        ? null
        : () {
            keyData.onPressed!.call();
            onChanged();
          };
    final button = keyData.filled
        ? FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: keyData.color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: _keyLabelStyle,
            ),
            onPressed: pressed,
            child: keyData.face,
          )
        : OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: keyData.color ?? Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: BorderSide(color: keyData.color ?? Colors.grey.shade400),
            ),
            onPressed: pressed,
            child: keyData.face,
          );
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: button,
    );
  }
}

class _ExpressionPreview extends StatelessWidget {
  const _ExpressionPreview({required this.editor});

  final ExpressionEditor editor;

  @override
  Widget build(BuildContext context) {
    final cursor = editor.cursor.clamp(0, editor.text.length);
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: MathExpressionView(expression: editor.text, cursor: cursor),
      ),
    );
  }
}
