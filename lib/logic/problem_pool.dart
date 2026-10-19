import 'dart:math';

import '../models/learning_record.dart';
import '../models/physics_domain.dart';
import '../models/physics_problem.dart';

bool acceptsDomains(PhysicsProblem problem, Set<PhysicsDomain> enabled) {
  return enabled.containsAll(problem.domains);
}

List<PhysicsProblem> eligibleProblems({
  required List<PhysicsProblem> problems,
  required Set<PhysicsDomain> enabled,
  required ExclusionMode exclusion,
  required Map<String, History> histories,
}) {
  return [
    for (final problem in problems)
      if (acceptsDomains(problem, enabled) &&
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
