import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// App Store 用スクショの自動ツアー。`--dart-define=STORE_SHOTS=true` のときだけ動く。
///
/// 各ステップでフレーム描画後に `STORE_SHOT ready:<id>` を出し、
/// ホストが撮るまで [hold] 秒待つ。
class StoreShotTour {
  StoreShotTour({
    required this.openCalculator,
    required this.closeCalculator,
    required this.showHint,
    required this.showAnswer,
    required this.pushProblemList,
    required this.popToRoot,
    this.openAi,
  });

  final VoidCallback openCalculator;
  final VoidCallback closeCalculator;
  final VoidCallback showHint;
  final VoidCallback showAnswer;
  final VoidCallback pushProblemList;
  final VoidCallback popToRoot;
  final VoidCallback? openAi;

  /// ホスト側のポーリング＋screenshot に余裕を持たせる。
  static const hold = Duration(seconds: 8);

  Future<void> run() async {
    await _shot('01_home');
    openCalculator();
    await _shot('02_calculator');
    closeCalculator();
    showHint();
    await _shot('03_hint');
    showAnswer();
    await _shot('04_answer');
    pushProblemList();
    await _shot('05_problem_list');
    popToRoot();
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    openAi?.call();
    await _shot('06_ask_ai');
    // ignore: avoid_print
    print('STORE_SHOT done');
  }

  Future<void> _shot(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await SchedulerBinding.instance.endOfFrame;
    await Future<void>.delayed(const Duration(milliseconds: 700));
    // print は debugPrint よりバッファが浅く、ホスト側が拾いやすい。
    // ignore: avoid_print
    print('STORE_SHOT ready:$id');
    await Future<void>.delayed(hold);
  }
}

/// `STORE_LOCALE=ja|en` で UI 言語を固定する。
Locale? storeShotLocale() {
  const raw = String.fromEnvironment('STORE_LOCALE');
  if (raw == 'ja') return const Locale('ja');
  if (raw == 'en') return const Locale('en');
  return null;
}

bool get storeShotsEnabled =>
    const bool.fromEnvironment('STORE_SHOTS', defaultValue: false);
