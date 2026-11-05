import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import '../l10n/app_localizations.dart';
import 'background_image.dart';

/// 高校物理の公式集（beginner_sale.pdf）。
class FormulaSheetPage extends StatelessWidget {
  const FormulaSheetPage({super.key});

  static const assetPath = 'assets/docs/beginner_sale.pdf';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        forceMaterialTransparency: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: const Color(0xFF1565C0),
        title: Text(
          l10n.formulaSheet,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: BackgroundImage()),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + kToolbarHeight,
            ),
            child: ColoredBox(
              color: Colors.white.withValues(alpha: 0.92),
              child: PdfViewer.asset(assetPath),
            ),
          ),
        ],
      ),
    );
  }
}
