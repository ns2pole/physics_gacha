import 'dart:math';

import '../data/sample_problems.dart';
import '../logic/problem_pool.dart';
import '../models/learning_record.dart';
import '../models/physics_domain.dart';
import '../models/physics_problem.dart';

class GachaSession {
  GachaSession({
    List<PhysicsProblem>? problems,
    Random? random,
    Set<PhysicsDomain>? enabled,
    this.exclusion = ExclusionMode.latest1,
    this.recordMode = AutoRecordMode.both,
    Map<String, History>? histories,
    this.current,
  }) : problems = List.unmodifiable(problems ?? sampleProblems),
       random = random ?? Random(),
       enabled = {...(enabled ?? PhysicsDomain.values)},
       histories = {...?histories};

  final List<PhysicsProblem> problems;
  final Random random;
  Set<PhysicsDomain> enabled;
  ExclusionMode exclusion;
  AutoRecordMode recordMode;
  final Map<String, History> histories;
  PhysicsProblem? current;

  List<PhysicsProblem> get eligible => eligibleProblems(
    problems: problems,
    enabled: enabled,
    exclusion: exclusion,
    histories: histories,
  );

  History historyOf(PhysicsProblem problem) =>
      histories[problem.id] ?? History.empty();

  /// 今の問題が候補に残っていればそのまま、外れていれば引き直す。
  void ensureCurrent() {
    final shown = current;
    if (shown != null && eligible.any((problem) => problem.id == shown.id)) {
      return;
    }
    current = drawProblem(
      candidates: eligible,
      avoidingId: shown?.id,
      random: random,
    );
  }

  void redraw() {
    current = drawProblem(
      candidates: eligible,
      avoidingId: current?.id,
      random: random,
    );
  }

  void setEnabled(Set<PhysicsDomain> next) {
    enabled = {...next};
    ensureCurrent();
  }

  void setExclusion(ExclusionMode next) {
    exclusion = next;
    ensureCurrent();
  }

  void setRecordMode(AutoRecordMode next) {
    recordMode = next;
  }

  /// 一覧から選んだ問題を、除外されていても出す。
  void showProblem(PhysicsProblem problem) {
    current = problem;
  }

  AutoRecordResult record(PhysicsProblem problem, bool correct, bool? already) {
    final result = autoRecord(
      history: historyOf(problem),
      mode: recordMode,
      correct: correct,
      alreadyRecorded: already,
    );
    histories[problem.id] = result.history;
    return result;
  }

  void cycle(PhysicsProblem problem, int index) {
    final next = cycleSlot(historyOf(problem), index);
    if (next == null) return;
    histories[problem.id] = next;
    if (!eligible.any((item) => item.id == problem.id)) {
      ensureCurrent();
    }
  }
}
