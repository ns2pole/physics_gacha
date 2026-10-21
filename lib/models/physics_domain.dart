import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

/// 高校物理の5単元。融合問題は複数を持つ。
enum PhysicsDomain {
  mechanics,
  thermodynamics,
  waves,
  electromagnetism,
  atom,
}

extension PhysicsDomainLabel on PhysicsDomain {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      PhysicsDomain.mechanics => l10n.domainMechanics,
      PhysicsDomain.thermodynamics => l10n.domainThermodynamics,
      PhysicsDomain.waves => l10n.domainWaves,
      PhysicsDomain.electromagnetism => l10n.domainElectromagnetism,
      PhysicsDomain.atom => l10n.domainAtom,
    };
  }
}

/// フィルタと同じ順。融合は「力学・熱力学」。
String joinedDomainLabels(BuildContext context, Set<PhysicsDomain> domains) {
  return [
    for (final domain in PhysicsDomain.values)
      if (domains.contains(domain)) domain.label(context),
  ].join('・');
}

/// フィルタの単元色を、一覧カード用に薄くした塗り。
Color domainCardTint(PhysicsDomain domain) => switch (domain) {
  PhysicsDomain.mechanics => const Color(0xFFF3E5F5),
  PhysicsDomain.thermodynamics => const Color(0xFFFFF3E0),
  PhysicsDomain.waves => const Color(0xFFE0F7FA),
  PhysicsDomain.electromagnetism => const Color(0xFFFFF8E1),
  PhysicsDomain.atom => const Color(0xFFE8F5E9),
};

List<PhysicsDomain> orderedDomains(Set<PhysicsDomain> domains) => [
  for (final domain in PhysicsDomain.values)
    if (domains.contains(domain)) domain,
];
