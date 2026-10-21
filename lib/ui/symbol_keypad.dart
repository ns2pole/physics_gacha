import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/l10n_utils.dart';

import 'calculator_frame.dart';

/// 名称や記号を左から順に並べる解答欄。
class SymbolKeypad extends StatelessWidget {
  const SymbolKeypad({
    super.key,
    required this.choices,
    required this.entered,
    required this.onEntered,
    required this.onConfirm,
  });

  final List<String> choices;
  final List<String> entered;
  final ValueChanged<List<String>> onEntered;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final preview = formatSymbolOrder(entered, context);
    return CalculatorFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            preview.isEmpty
                ? AppLocalizations.of(context)!.symbolOrderHint
                : preview,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: preview.isEmpty ? 28 : 20,
              fontWeight: FontWeight.w600,
              color: preview.isEmpty ? Colors.black38 : const Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [for (final symbol in choices) _symbol(symbol)],
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
                      : () => onEntered(entered.sublist(0, entered.length - 1)),
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

  Widget _symbol(String symbol) {
    final used = entered.contains(symbol);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 52, minWidth: 72),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: used ? Colors.grey.shade200 : Colors.white,
          foregroundColor: used ? Colors.black38 : Colors.black87,
          side: BorderSide(color: Colors.grey.shade400),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        onPressed: used ? null : () => onEntered([...entered, symbol]),
        child: Text(symbol, textAlign: TextAlign.center),
      ),
    );
  }
}
