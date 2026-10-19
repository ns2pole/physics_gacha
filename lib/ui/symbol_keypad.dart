import 'package:flutter/material.dart';

import 'calculator_frame.dart';

/// 記号を左から順に並べる解答欄。
class SymbolKeypad extends StatelessWidget {
  const SymbolKeypad({
    super.key,
    required this.choices,
    required this.entered,
    required this.onEntered,
    required this.onConfirm,
  });

  final List<String> choices;
  final String entered;
  final ValueChanged<String> onEntered;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final preview = entered.split('').join(' ');
    return CalculatorFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            preview.isEmpty ? '短い順に左から' : preview,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: preview.isEmpty ? Colors.black38 : const Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var i = 0; i < choices.length; i++) ...[
                if (i > 0) const SizedBox(width: 6),
                Expanded(child: _symbol(choices[i])),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 72,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle: const TextStyle(fontSize: 22),
                  ),
                  onPressed: entered.isEmpty
                      ? null
                      : () => onEntered(entered.substring(0, entered.length - 1)),
                  child: const Text('⌫'),
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

  Widget _symbol(String symbol) {
    final used = entered.contains(symbol);
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: used ? Colors.grey.shade200 : Colors.white,
          foregroundColor: used ? Colors.black38 : Colors.black87,
          side: BorderSide(color: Colors.grey.shade400),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        onPressed: used ? null : () => onEntered(entered + symbol),
        child: Text(symbol),
      ),
    );
  }
}
