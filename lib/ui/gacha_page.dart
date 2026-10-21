import 'package:flutter/material.dart';

import '../logic/grading.dart';
import '../logic/problem_pool.dart';
import '../models/learning_record.dart';
import '../models/physics_domain.dart';
import '../models/physics_problem.dart';
import '../services/auth/cloud_sign_in_flow.dart';
import '../services/auth/cloud_sync_coordinator.dart';
import '../services/auth/cloud_sync_preference_service.dart';
import '../services/auth/firebase_auth_service.dart';
import '../state/gacha_session.dart';
import '../state/gacha_store.dart';
import '../integrations/ai_chat/physics_ai_chat_launcher.dart';
import 'account_deletion_flow.dart';
import 'ac_resistor_figure.dart';
import 'battery_resistor_figure.dart';
import 'beats_figure.dart';
import 'bridge_voltage_drop_figure.dart';
import 'background_image.dart';
import 'compressed_spring_figure.dart';
import 'connected_vessels_figure.dart';
import 'expression_editor.dart';
import 'math_expression_view.dart';
import 'unit_expression_view.dart';
import 'filter_bar.dart';
import 'fixed_end_reflection_figure.dart';
import 'gas_cylinder_figure.dart';
import 'incline_pull_figure.dart';
import 'kepler_orbits_figure.dart';
import 'free_end_reflection_figure.dart';
import 'numeric_keypad.dart';
import 'problem_list_page.dart';
import 'open_pipe_figure.dart';
import 'resistor_current_figure.dart';
import 'series_circuit_figure.dart';
import 'parallel_current_figure.dart';
import 'series_current_figure.dart';
import 'simple_pendulum_figure.dart';
import 'sliding_comparison_figure.dart';
import 'spring_pulleys_figure.dart';
import 'stacked_blocks_figure.dart';
import 'store_shot_tour.dart';
import 'symbol_keypad.dart';
import 'unit_keypad.dart';
import 'vertical_spring_oscillation_figure.dart';
import '../l10n/app_localizations.dart';
import '../utils/l10n_utils.dart';

bool _isDimensionlessChoice(String? choice, AppLocalizations l10n) {
  if (choice == null || choice.isEmpty) return true;
  return choice == '無次元' || choice == l10n.dimensionless || choice == '1';
}

enum _Phase { closed, value, unit, judged }

const _actionBlue = Color(0xFF1565C0);

final _problemActionStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  foregroundColor: _actionBlue,
  elevation: 0,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  side: const BorderSide(color: _actionBlue),
  shape: const StadiumBorder(),
);

class GachaPage extends StatefulWidget {
  const GachaPage({super.key});

  @override
  State<GachaPage> createState() => _GachaPageState();
}

class _GachaPageState extends State<GachaPage> with TickerProviderStateMixin {
  final _store = GachaStore();
  late final _sync = CloudSyncCoordinator(store: _store);
  final _expression = ExpressionEditor();
  GachaSession? _session;
  _Phase _phase = _Phase.closed;
  String _unitText = '';
  List<String> _symbolOrder = [];
  String? _choice;
  AnswerGrade? _grade;
  String _submittedAnswer = '';
  bool _showAnswer = false;
  bool _showHint = false;
  bool? _alreadyRecorded;
  bool _syncBusy = false;
  bool _storeShotStarted = false;
  AnimationController? _roll;
  List<PhysicsProblem> _rollFrames = [];

  bool get _rolling => _roll != null;

  bool get _rollsVisually {
    if (storeShotsEnabled) return false;
    return !WidgetsBinding.instance.runtimeType.toString().contains(
      'TestWidgetsFlutterBinding',
    );
  }

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _roll?.dispose();
    super.dispose();
  }

  void _maybeStartStoreShotTour() {
    if (!storeShotsEnabled || _storeShotStarted || _session == null) return;
    _storeShotStarted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await StoreShotTour(
        openCalculator: () {
          if (!mounted) return;
          setState(() {
            _showAnswer = false;
            _showHint = false;
            _phase = _Phase.value;
          });
        },
        closeCalculator: () {
          if (!mounted) return;
          setState(() => _phase = _Phase.closed);
        },
        showHint: () {
          if (!mounted) return;
          setState(() {
            _showHint = true;
            _showAnswer = false;
            _phase = _Phase.closed;
          });
        },
        showAnswer: () {
          if (!mounted) return;
          setState(() {
            _showAnswer = true;
            _showHint = false;
            _phase = _Phase.closed;
          });
        },
        pushProblemList: () {
          final session = _session;
          if (session == null || !mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => ProblemListPage(
                session: session,
                onHistoryChanged: () {
                  setState(() {});
                  _save();
                },
              ),
            ),
          );
        },
        popToRoot: () {
          if (!mounted) return;
          Navigator.of(context).popUntil((route) => route.isFirst);
          setState(() {
            _showAnswer = false;
            _showHint = false;
            _phase = _Phase.closed;
          });
        },
        openAi: () {
          final problem = _session?.current;
          if (problem == null || !mounted) return;
          PhysicsAiChatLauncher.open(
            context: context,
            problem: problem,
            hintShown: false,
            answerShown: false,
          );
        },
      ).run();
    });
  }

  Future<void> _bootstrap() async {
    await CloudSyncPreferenceService.refreshForUser(FirebaseAuthService.userId);
    await _sync.refreshAuthAndMaybeSwitch();
    if (FirebaseAuthService.isAuthenticated &&
        await CloudSyncPreferenceService.isEnabledForCurrentUser()) {
      try {
        final merged = await _sync.pullMergeAndSave();
        if (merged != null) {
          await _applySnapshot(merged);
          _maybeStartStoreShotTour();
          return;
        }
      } catch (e) {
        debugPrint('Initial cloud pull failed: $e');
      }
    }
    await _loadLocal();
  }

  Future<void> _loadLocal() async {
    final snapshot = await _store.load();
    final session = GachaSession(
      enabled: snapshot?.enabled,
      exclusion: snapshot?.exclusion ?? ExclusionMode.latest1,
      // 設定は一旦止める。保存値は読まず、正解は緑・不正解は赤で登録する。
      // recordMode: snapshot?.recordMode ?? AutoRecordMode.both,
      recordMode: AutoRecordMode.both,
      histories: snapshot?.histories,
    );
    session.ensureCurrent();
    if (!mounted) return;
    setState(() => _session = session);
    _maybeStartStoreShotTour();
  }

  Future<void> _applySnapshot(GachaSnapshot snapshot) async {
    final session = _sync.sessionFromSnapshot(snapshot);
    session.ensureCurrent();
    if (!mounted) return;
    setState(() {
      _session = session;
      _resetAttempt();
    });
    _maybeStartStoreShotTour();
  }

  Future<void> _save() async {
    final session = _session;
    if (session == null) return;
    await _store.save(session);
    await _sync.pushAfterLocalSave();
  }

  void _resetAttempt() {
    _phase = _Phase.closed;
    _expression.clear();
    _unitText = '';
    _symbolOrder = [];
    _choice = null;
    _grade = null;
    _submittedAnswer = '';
    _showAnswer = false;
    _showHint = false;
    _alreadyRecorded = null;
  }

  void _redraw() {
    final session = _session;
    if (session == null || _rolling) return;
    session.redraw();
    _resetAttempt();
    _save();
    final chosen = session.current;
    if (_rollsVisually &&
        chosen != null &&
        session.eligible.length >= 2) {
      _prepareRoll(session, chosen);
    }
    setState(() {});
    _roll?.forward().whenComplete(() {
      if (!mounted) return;
      _stopRoll();
      setState(() {});
    });
  }

  void _stopRoll() {
    _roll?.dispose();
    _roll = null;
    _rollFrames = [];
  }

  void _prepareRoll(GachaSession session, PhysicsProblem chosen) {
    final others = [
      for (final problem in session.eligible)
        if (problem.id != chosen.id) problem,
    ];
    if (others.isEmpty) return;
    final frames = <PhysicsProblem>[];
    PhysicsProblem? previous;
    for (var i = 0; i < 16; i++) {
      var next = others[session.random.nextInt(others.length)];
      if (others.length > 1 && previous != null) {
        while (next.id == previous.id) {
          next = others[session.random.nextInt(others.length)];
        }
      }
      frames.add(next);
      previous = next;
    }
    frames.add(chosen);
    _rollFrames = frames;
    _roll = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..addListener(() {
        if (mounted) setState(() {});
      });
  }

  PhysicsProblem? _visibleProblem(GachaSession session) {
    if (_rolling && _rollFrames.isNotEmpty) {
      final t = Curves.easeOutCubic.transform(_roll!.value);
      final last = _rollFrames.length - 1;
      final index = (t * last).floor().clamp(0, last);
      return _rollFrames[index];
    }
    return session.current;
  }

  void _changeFilter(void Function(GachaSession session) change) {
    final session = _session;
    if (session == null) return;
    _stopRoll();
    final previous = session.current?.id;
    change(session);
    if (session.current?.id != previous) _resetAttempt();
    setState(() {});
    _save();
  }

  void _openCalculator() {
    setState(() {
      _showAnswer = false;
      final keypadOpen = _phase == _Phase.value || _phase == _Phase.unit;
      _phase = keypadOpen ? _Phase.closed : _Phase.value;
    });
  }

  void _toggleAnswer() {
    setState(() {
      _showAnswer = !_showAnswer;
      if (_showAnswer) _phase = _Phase.closed;
    });
  }

  void _toggleHint() {
    setState(() => _showHint = !_showHint);
  }

  Widget _buildAccountAction() {
    const iconColor = Color(0xFF1565C0);
    if (!FirebaseAuthService.isAuthenticated) {
      return IconButton(
        tooltip: AppLocalizations.of(context)!.cloudLogin,
        onPressed: _syncBusy ? null : _onCloudSignIn,
        icon: const Icon(Icons.cloud_outlined, color: iconColor, size: 28),
      );
    }

    final email = FirebaseAuthService.userEmail;
    final name = FirebaseAuthService.displayName;
    final accountInfo = (email != null && email.isNotEmpty)
        ? email
        : (name != null && name.isNotEmpty
              ? name
              : AppLocalizations.of(context)!.signedIn);
    final syncOn = CloudSyncPreferenceService.enabledListenable.value;

    return PopupMenuButton<String>(
      tooltip: AppLocalizations.of(context)!.account,
      icon: const Icon(Icons.account_circle, color: iconColor, size: 28),
      onSelected: _onAccountMenuSelected,
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Text(
            accountInfo,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        PopupMenuItem(
          value: 'toggleSync',
          child: Row(
            children: [
              Icon(
                syncOn ? Icons.cloud_done : Icons.cloud_off,
                size: 20,
                color: iconColor,
              ),
              const SizedBox(width: 8),
              Text(
                syncOn
                    ? AppLocalizations.of(context)!.cloudSyncOn
                    : AppLocalizations.of(context)!.cloudSyncOff,
              ),
            ],
          ),
        ),
        if (syncOn)
          PopupMenuItem(
            value: 'manualSync',
            child: Row(
              children: [
                const Icon(Icons.sync, size: 20),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.syncNow),
              ],
            ),
          ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'deleteAccount',
          child: Row(
            children: [
              const Icon(Icons.delete_forever, size: 20, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.deleteAccount,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout, size: 20),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)!.signOut),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onCloudSignIn() async {
    setState(() => _syncBusy = true);
    try {
      final signedIn = await CloudSignInFlow.signIn(
        context,
        coordinator: _sync,
      );
      if (!signedIn || !mounted) return;
      final snapshot = await _store.load();
      if (snapshot != null) {
        await _applySnapshot(snapshot);
      } else {
        setState(() {});
      }
    } finally {
      if (mounted) setState(() => _syncBusy = false);
    }
  }

  Future<void> _onAccountMenuSelected(String value) async {
    switch (value) {
      case 'toggleSync':
        final uid = FirebaseAuthService.userId;
        if (uid == null) return;
        final next = !CloudSyncPreferenceService.enabledListenable.value;
        setState(() => _syncBusy = true);
        try {
          await _sync.setSyncEnabled(next);
          if (next) {
            final snapshot = await _store.load();
            if (snapshot != null) await _applySnapshot(snapshot);
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  next
                      ? AppLocalizations.of(context)!.cloudSyncEnabled
                      : AppLocalizations.of(context)!.cloudSyncDisabled,
                ),
              ),
            );
          }
        } finally {
          if (mounted) setState(() => _syncBusy = false);
        }
      case 'manualSync':
        setState(() => _syncBusy = true);
        try {
          final merged = await _sync.pullMergeAndSave();
          if (merged != null) await _applySnapshot(merged);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.synced)),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.syncFailed('$e')),
                backgroundColor: Colors.red,
              ),
            );
          }
        } finally {
          if (mounted) setState(() => _syncBusy = false);
        }
      case 'deleteAccount':
        final deleted = await AccountDeletionFlow.show(context);
        if (deleted && mounted) {
          await _loadLocal();
          setState(() {});
        }
      case 'logout':
        await FirebaseAuthService.signOut();
        await CloudSyncPreferenceService.refreshForUser(null);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.signedOut),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {});
        }
    }
  }

  void _confirm(PhysicsProblem problem) {
    final session = _session;
    if (session == null) return;
    final AnswerGrade grade;
    final String submitted;
    final l10n = AppLocalizations.of(context)!;
    if (problem.isSymbolOrder) {
      final expected = problem.getLocalizedSymbolOrder(context);
      submitted = formatSymbolOrder(_symbolOrder, context);
      final passed = orderMatches(expected, submitted);
      grade = AnswerGrade(valueCorrect: passed, unitCorrect: true);
    } else {
      final userUnit = switch (problem.unitInputKind) {
        UnitInputKind.omitted => problem.answerUnit,
        UnitInputKind.choices =>
          _isDimensionlessChoice(_choice, l10n) ? '' : (_choice ?? ''),
        UnitInputKind.base => _unitText,
      };
      grade = gradeAnswer(
        expectedValue: problem.answerValue,
        expectedUnit: problem.answerUnit,
        userExpression: _expression.text,
        userUnit: userUnit,
      );
      final submittedUnit = switch (problem.unitInputKind) {
        UnitInputKind.omitted => problem.getLocalizedAnswerUnitLabel(context),
        UnitInputKind.choices => _choice ?? '',
        UnitInputKind.base => _unitText,
      };
      submitted = _formatSubmitted(_expression.text, submittedUnit);
    }
    final recorded = session.record(problem, grade.passed, _alreadyRecorded);
    setState(() {
      _grade = grade;
      _submittedAnswer = submitted;
      _phase = _Phase.judged;
      _alreadyRecorded = recorded.alreadyRecorded;
    });
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
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
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.appTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        actions: [
          _buildAccountAction(),
          if (session != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1565C0),
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    side: const BorderSide(color: Color(0xFF1565C0)),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    minimumSize: const Size(0, 40),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () => _openProblemList(session),
                  child: Text(
                    AppLocalizations.of(context)!.problemList,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: BackgroundImage()),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + kToolbarHeight,
            ),
            child: session == null
                ? const Center(child: CircularProgressIndicator())
                : _GachaBody(
                    session: session,
                    displayProblem: _visibleProblem(session),
                    rolling: _rolling,
                    phase: _phase,
                    expression: _expression,
                    unitText: _unitText,
                    choice: _choice,
                    symbolOrder: _symbolOrder,
                    grade: _grade,
                    submittedAnswer: _submittedAnswer,
                    showAnswer: _showAnswer,
                    showHint: _showHint,
                    onRedraw: session.eligible.isEmpty || _rolling
                        ? null
                        : _redraw,
                    onDomain: (domain, selected) {
                      _changeFilter((session) {
                        final next = {...session.enabled};
                        selected ? next.add(domain) : next.remove(domain);
                        session.setEnabled(next);
                      });
                    },
                    onExclusion: (mode) =>
                        _changeFilter((session) => session.setExclusion(mode)),
                    onCalculator: _openCalculator,
                    onAnswer: _toggleAnswer,
                    onHint: _toggleHint,
                    onAi: () {
                      final problem = session.current;
                      if (problem == null) return;
                      PhysicsAiChatLauncher.open(
                        context: context,
                        problem: problem,
                        hintShown: _showHint,
                        answerShown: _showAnswer,
                      );
                    },
                    onExpressionChanged: () => setState(() {}),
                    onNextToUnit: () => setState(() => _phase = _Phase.unit),
                    onUnitText: (text) => setState(() => _unitText = text),
                    onChoice: (choice) => setState(() => _choice = choice),
                    onSymbolOrder: (order) =>
                        setState(() => _symbolOrder = order),
                    onBackToValue: () => setState(() => _phase = _Phase.value),
                    onConfirm: session.current == null
                        ? null
                        : () => _confirm(session.current!),
                  ),
          ),
        ],
      ),
    );
  }

  // 設定画面は一旦閉じる。戻すときはこのメソッドと歯車を戻す。
  // Future<void> _editRecordMode(GachaSession session) async {
  //   final selected = await showDialog<AutoRecordMode>(
  //     context: context,
  //     builder: (context) {
  //       return SimpleDialog(
  //         title: const Text('電卓 自動正誤登録の設定'),
  //         children: [
  //           for (final mode in AutoRecordMode.values)
  //             SimpleDialogOption(
  //               onPressed: () => Navigator.pop(context, mode),
  //               child: Row(
  //                 children: [
  //                   Icon(
  //                     session.recordMode == mode
  //                         ? Icons.radio_button_checked
  //                         : Icons.radio_button_off,
  //                   ),
  //                   const SizedBox(width: 8),
  //                   Expanded(child: Text(mode.label)),
  //                 ],
  //               ),
  //             ),
  //         ],
  //       );
  //     },
  //   );
  //   if (selected == null) return;
  //   setState(() => session.setRecordMode(selected));
  //   _save();
  // }

  Future<void> _openProblemList(GachaSession session) async {
    _stopRoll();
    setState(() {});
    final previous = session.current?.id;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ProblemListPage(
          session: session,
          onHistoryChanged: () {
            setState(() {});
            _save();
          },
        ),
      ),
    );
    if (!mounted) return;
    if (session.current?.id != previous) setState(_resetAttempt);
  }
}

class _GachaBody extends StatelessWidget {
  const _GachaBody({
    required this.session,
    required this.displayProblem,
    required this.rolling,
    required this.phase,
    required this.expression,
    required this.unitText,
    required this.choice,
    required this.symbolOrder,
    required this.grade,
    required this.submittedAnswer,
    required this.showAnswer,
    required this.showHint,
    required this.onRedraw,
    required this.onDomain,
    required this.onExclusion,
    required this.onCalculator,
    required this.onAnswer,
    required this.onHint,
    required this.onAi,
    required this.onExpressionChanged,
    required this.onNextToUnit,
    required this.onUnitText,
    required this.onChoice,
    required this.onSymbolOrder,
    required this.onBackToValue,
    required this.onConfirm,
  });

  final GachaSession session;
  final PhysicsProblem? displayProblem;
  final bool rolling;
  final _Phase phase;
  final ExpressionEditor expression;
  final String unitText;
  final String? choice;
  final List<String> symbolOrder;
  final AnswerGrade? grade;
  final String submittedAnswer;
  final bool showAnswer;
  final bool showHint;
  final VoidCallback? onRedraw;
  final void Function(PhysicsDomain domain, bool selected) onDomain;
  final ValueChanged<ExclusionMode> onExclusion;
  final VoidCallback onCalculator;
  final VoidCallback onAnswer;
  final VoidCallback onHint;
  final VoidCallback onAi;
  final VoidCallback onExpressionChanged;
  final VoidCallback onNextToUnit;
  final ValueChanged<String> onUnitText;
  final ValueChanged<String> onChoice;
  final ValueChanged<List<String>> onSymbolOrder;
  final VoidCallback onBackToValue;
  final VoidCallback? onConfirm;

  bool get _keypadOpen => phase == _Phase.value || phase == _Phase.unit;

  @override
  Widget build(BuildContext context) {
    final problem = displayProblem;
    final judged = problem != null && grade != null && !rolling;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, judged ? 8 : 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _GachaButton(onPressed: onRedraw),
              const SizedBox(height: 10),
              ExclusionFilterCard(
                mode: session.exclusion,
                remaining: session.eligible.length,
                total: session.problems
                    .where(
                      (problem) => acceptsDomains(problem, session.enabled),
                    )
                    .length,
                enabled: session.enabled,
                onDomain: onDomain,
                onChanged: onExclusion,
              ),
              const SizedBox(height: 10),
              if (problem == null)
                Text(AppLocalizations.of(context)!.noProblemsAvailable)
              else ...[
                AnimatedSwitcher(
                  duration: Duration(milliseconds: rolling ? 70 : 0),
                  child: _ProblemCard(
                    key: ValueKey(problem.id),
                    problem: problem,
                    showHint: showHint && !rolling,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      IconButton(
                        tooltip: _keypadOpen
                            ? AppLocalizations.of(context)!.closeCalculator
                            : AppLocalizations.of(context)!.calculator,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _keypadOpen
                              ? Colors.teal
                              : _actionBlue,
                          side: BorderSide(
                            color: _keypadOpen ? Colors.teal : _actionBlue,
                          ),
                        ),
                        onPressed: rolling ? null : onCalculator,
                        icon: Icon(
                          Icons.calculate_outlined,
                          color: _keypadOpen ? Colors.teal : _actionBlue,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: rolling ? null : onHint,
                        style: _problemActionStyle,
                        child: Text(
                          showHint
                              ? AppLocalizations.of(context)!.hideHint
                              : AppLocalizations.of(context)!.hint,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: rolling ? null : onAnswer,
                        style: _problemActionStyle,
                        child: Text(
                          showAnswer
                              ? AppLocalizations.of(context)!.hideAnswer
                              : AppLocalizations.of(context)!.showAnswer,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: rolling ? null : onAi,
                        style: _problemActionStyle,
                        child: Text(AppLocalizations.of(context)!.askAi),
                      ),
                    ],
                  ),
                ),
                if (showAnswer) ...[
                  const SizedBox(height: 8),
                  _AnswerCard(problem: problem),
                ],
                if (phase == _Phase.value) ...[
                  const SizedBox(height: 8),
                  if (problem.isSymbolOrder)
                    SymbolKeypad(
                      choices: problem.getLocalizedSymbolChoices(context),
                      entered: symbolOrder,
                      onEntered: onSymbolOrder,
                      onConfirm:
                          symbolOrder.length ==
                              problem.getLocalizedSymbolChoices(context).length
                          ? onConfirm
                          : null,
                    )
                  else
                    NumericKeypad(
                      editor: expression,
                      onChanged: onExpressionChanged,
                      nextLabel: problem.unitObvious
                          ? AppLocalizations.of(context)!.confirm
                          : AppLocalizations.of(context)!.toUnits,
                      onNext: expression.text.trim().isEmpty
                          ? null
                          : (problem.unitObvious ? onConfirm : onNextToUnit),
                    ),
                ],
                if (phase == _Phase.unit) ...[
                  const SizedBox(height: 8),
                  UnitKeypad(
                    problem: problem,
                    value: expression.text,
                    text: unitText,
                    selectedChoice: choice,
                    onTextChanged: onUnitText,
                    onChoice: onChoice,
                    onBack: onBackToValue,
                    onConfirm: _canConfirm(problem) ? onConfirm : null,
                  ),
                ],
              ],
            ]),
          ),
        ),
        if (judged)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _Verdict(
              problem: problem,
              grade: grade!,
              submitted: submittedAnswer,
            ),
          ),
      ],
    );
  }

  bool _canConfirm(PhysicsProblem problem) {
    if (problem.unitInputKind == UnitInputKind.base)
      return unitText.trim().isNotEmpty;
    return choice != null;
  }
}

Widget _problemFigure(
  ProblemFigure figure, {
  required HintReveal reveal,
  required double hintProgress,
}) {
  return switch (figure) {
    ProblemFigure.stackedBlocks => StackedBlocksFigure(
      groupProgress: reveal == HintReveal.groupUpperBlocks ? hintProgress : 0,
    ),
    ProblemFigure.seriesCircuit => const SeriesCircuitFigure(),
    ProblemFigure.openPipe => const OpenPipeFigure(),
    ProblemFigure.slidingComparison => const SlidingComparisonFigure(),
    ProblemFigure.resistorCurrent => const ResistorCurrentFigure(),
    ProblemFigure.springPulleys => const SpringPulleysFigure(),
    ProblemFigure.compressedSpring => const CompressedSpringFigure(),
    ProblemFigure.acResistor => const AcResistorFigure(),
    ProblemFigure.inclinePull => const InclinePullFigure(),
    ProblemFigure.batteryResistor => const BatteryResistorFigure(),
    ProblemFigure.seriesCurrent => const SeriesCurrentFigure(),
    ProblemFigure.parallelCurrent => const ParallelCurrentFigure(),
    ProblemFigure.bridgeVoltageDrop => const BridgeVoltageDropFigure(),
    ProblemFigure.isothermalGas => const GasCylinderFigure(
      process: GasCylinderProcess.isothermal,
    ),
    ProblemFigure.isobaricGas => const GasCylinderFigure(
      process: GasCylinderProcess.isobaric,
    ),
    ProblemFigure.isochoricGas => const GasCylinderFigure(
      process: GasCylinderProcess.isochoric,
    ),
    ProblemFigure.adiabaticGas => const GasCylinderFigure(
      process: GasCylinderProcess.adiabatic,
    ),
    ProblemFigure.connectedVessels => const ConnectedVesselsFigure(),
    ProblemFigure.diatomicVessels => const ConnectedVesselsFigure(
      leftInside: '2.0 mol',
      leftBelow: '300 K',
      rightInside: '1.0 mol',
      rightBelow: '900 K',
    ),
    ProblemFigure.verticalSpringOscillation =>
      const VerticalSpringOscillationFigure(),
    ProblemFigure.simplePendulum => const SimplePendulumFigure(),
    ProblemFigure.keplerOrbits => const KeplerOrbitsFigure(),
    ProblemFigure.beats => const BeatsFigure(),
  };
}

class _ProblemCard extends StatefulWidget {
  const _ProblemCard({
    super.key,
    required this.problem,
    required this.showHint,
  });

  final PhysicsProblem problem;
  final bool showHint;

  @override
  State<_ProblemCard> createState() => _ProblemCardState();
}

class _ProblemCardState extends State<_ProblemCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _reveal;

  @override
  void initState() {
    super.initState();
    _reveal = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    if (widget.showHint) _reveal.value = 1;
  }

  @override
  void didUpdateWidget(_ProblemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showHint == oldWidget.showHint) return;
    if (widget.showHint) {
      _reveal.forward();
    } else {
      _reveal.reverse();
    }
  }

  @override
  void dispose() {
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final problem = widget.problem;
    return DomainTintCard(
      domains: problem.domains,
      child: AnimatedBuilder(
        animation: _reveal,
        builder: (context, _) {
          final progress = Curves.easeOutCubic.transform(_reveal.value);
          final open = _reveal.value > 0;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (problem.figure != null) ...[
                  Center(
                    child: _problemFigure(
                      problem.figure!,
                      reveal: problem.hintReveal,
                      hintProgress: progress,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                Text(
                  problem.getLocalizedStatement(context),
                  style: const TextStyle(fontSize: 16, height: 1.6),
                ),
                if (open)
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: progress,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _hintBody(context, problem),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 問題ごとのヒント。文章が基本で、種類によっては図のアニメも同時に進む。
Widget _hintBody(BuildContext context, PhysicsProblem problem) {
  final hint = problem.getLocalizedHint(context);
  return switch (problem.hintReveal) {
    HintReveal.message ||
    HintReveal.groupUpperBlocks => _HintMessage(text: hint),
    HintReveal.freeEndReflection => _reflectionHint(
      const FreeEndReflectionFigure(),
      hint,
    ),
    HintReveal.fixedEndReflection => _reflectionHint(
      const FixedEndReflectionFigure(),
      hint,
    ),
  };
}

Widget _reflectionHint(Widget figure, String text) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Center(child: figure),
      const SizedBox(height: 10),
      _HintMessage(text: text),
    ],
  );
}

class _HintMessage extends StatelessWidget {
  const _HintMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(left: BorderSide(color: _actionBlue, width: 3)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, height: 1.6, color: _actionBlue),
        ),
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  const _AnswerCard({required this.problem});

  final PhysicsProblem problem;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AnswerLine(
              text: AppLocalizations.of(context)!.answerWithValue(
                '${problem.getLocalizedAnswerDisplay(context)} ${problem.getLocalizedAnswerUnitLabel(context)}'
                    .trim(),
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              problem.getLocalizedExplanation(context),
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _Verdict extends StatelessWidget {
  const _Verdict({
    required this.problem,
    required this.grade,
    required this.submitted,
  });

  final PhysicsProblem problem;
  final AnswerGrade grade;
  final String submitted;

  static const _answerStyle = TextStyle(
    fontSize: 40,
    height: 1.15,
    fontWeight: FontWeight.w600,
    color: Color(0xFF212121),
  );

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final markSize = width * (grade.passed ? 0.75 : 0.5);
    final correction = _correction(context);
    return Center(
      child: SizedBox(
        width: markSize,
        height: markSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size.square(markSize),
              painter: _GradeMarkPainter(passed: grade.passed),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _AnswerLine(text: submitted, style: _answerStyle),
                    if (correction != null) ...[
                      const SizedBox(height: 8),
                      _AnswerLine(
                        text: correction,
                        style: _answerStyle.copyWith(
                          color: const Color(0xFFD32F2F),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 間違えた部分だけを、送った解答と同じ大きさの赤文字にする。
  String? _correction(BuildContext context) {
    if (grade.passed) return null;
    final value = problem.getLocalizedAnswerDisplay(context);
    final unit = problem.getLocalizedAnswerUnitLabel(context);
    if (!grade.valueCorrect && !grade.unitCorrect) return '$value $unit'.trim();
    if (!grade.valueCorrect) return value;
    return unit;
  }
}

class _AnswerLine extends StatelessWidget {
  const _AnswerLine({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final typed = _typedUnitSuffix(text);
    if (typed != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _value(typed.$1),
          SizedBox(width: (style.fontSize ?? 28) * 0.25),
          UnitExpressionView(unit: typed.$2, style: style),
        ],
      );
    }
    if (unitNeedsTypesetting(text)) {
      return UnitExpressionView(unit: text, style: style);
    }
    if (text.contains('^')) {
      return MathExpressionView(expression: text, style: style);
    }
    return Text(text, textAlign: TextAlign.center, style: style);
  }

  Widget _value(String value) {
    if (value.contains('^')) {
      return MathExpressionView(expression: value, style: style);
    }
    return Text(value, style: style);
  }

  /// `40 m^-1` のように、数値のうしろの単位だけ組み直す。
  (String, String)? _typedUnitSuffix(String source) {
    final index = source.indexOf(' ');
    if (index <= 0) return null;
    final head = source.substring(0, index);
    final tail = source.substring(index + 1);
    final headIsValue = RegExp(r'^[0-9.]').hasMatch(head) || head.contains('×');
    if (!headIsValue || !unitNeedsTypesetting(tail)) return null;
    return (head, tail);
  }
}

class _GradeMarkPainter extends CustomPainter {
  const _GradeMarkPainter({required this.passed});

  final bool passed;

  @override
  void paint(Canvas canvas, Size size) {
    final color = (passed ? const Color(0xFF2E7D32) : const Color(0xFFD32F2F))
        .withValues(alpha: 0.45);
    final stroke = size.shortestSide * 0.055;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    if (passed) {
      canvas.drawCircle(
        size.center(Offset.zero),
        (size.shortestSide - stroke) / 2,
        paint,
      );
      return;
    }
    final inset = size.shortestSide * 0.12;
    canvas.drawLine(
      Offset(inset, inset),
      Offset(size.width - inset, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(inset, size.height - inset),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GradeMarkPainter oldDelegate) =>
      oldDelegate.passed != passed;
}

String _formatSubmitted(String expression, String unit) {
  final value = expression.trim();
  final label = unit.trim();
  if (label.isEmpty) return value;
  return '$value $label';
}

class _GachaButton extends StatelessWidget {
  const _GachaButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              gradient: enabled
                  ? const LinearGradient(
                      colors: [Colors.blue, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: enabled ? null : Colors.blue.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.casino,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  AppLocalizations.of(context)!.spinGacha,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
