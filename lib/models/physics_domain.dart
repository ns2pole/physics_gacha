/// 高校物理の5単元。融合問題は複数を持つ。
enum PhysicsDomain {
  mechanics,
  thermodynamics,
  waves,
  electromagnetism,
  atom,
}

extension PhysicsDomainLabel on PhysicsDomain {
  String get label => switch (this) {
    PhysicsDomain.mechanics => '力学',
    PhysicsDomain.thermodynamics => '熱力学',
    PhysicsDomain.waves => '波動',
    PhysicsDomain.electromagnetism => '電磁気学',
    PhysicsDomain.atom => '原子',
  };
}
