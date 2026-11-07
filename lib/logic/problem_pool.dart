import 'dart:math';

import '../data/gacha_suspended_ids.dart';
import '../models/learning_record.dart';
import '../models/physics_domain.dart';
import '../models/physics_problem.dart';

bool acceptsDomains(PhysicsProblem problem, Set<PhysicsDomain> enabled) {
  return enabled.containsAll(problem.domains);
}

/// 修正待ちで止めている問題は、ガチャにも一覧にも出さない。
bool isAvailableProblem(PhysicsProblem problem, Set<PhysicsDomain> enabled) {
  return !gachaSuspendedProblemIds.contains(problem.id) &&
      acceptsDomains(problem, enabled);
}

List<PhysicsProblem> eligibleProblems({
  required List<PhysicsProblem> problems,
  required Set<PhysicsDomain> enabled,
  required ExclusionMode exclusion,
  required Map<String, History> histories,
}) {
  return [
    for (final problem in problems)
      if (isAvailableProblem(problem, enabled) &&
          !isExcluded(histories[problem.id] ?? History.empty(), exclusion))
        problem,
  ];
}

/// 候補が2問以上あるときは、直前と同じ問題を続けて出さない。
PhysicsProblem? drawProblem({
  required List<PhysicsProblem> candidates,
  required String? avoidingId,
  required Random random,
}) {
  if (candidates.isEmpty) return null;
  final pool = avoidingId != null && candidates.length >= 2
      ? candidates.where((problem) => problem.id != avoidingId).toList()
      : candidates;
  return pool[random.nextInt(pool.length)];
}
