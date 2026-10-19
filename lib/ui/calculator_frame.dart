import 'package:flutter/material.dart';

/// 問題カードとは別の、背景を塗った電卓の枠。
class CalculatorFrame extends StatelessWidget {
  const CalculatorFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }
}
