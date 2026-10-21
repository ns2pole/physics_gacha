import 'package:flutter/material.dart';

import '../models/learning_record.dart';
import '../models/physics_domain.dart';
import '../l10n/app_localizations.dart';

/// 単元のオン／オフ。色がついていればオン、灰色ならオフ。
class DomainChips extends StatelessWidget {
  const DomainChips({super.key, required this.enabled, required this.onDomain});

  final Set<PhysicsDomain> enabled;
  final void Function(PhysicsDomain domain, bool selected) onDomain;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        children: [
          for (var i = 0; i < PhysicsDomain.values.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            _DomainPill(
              domain: PhysicsDomain.values[i],
              selected: enabled.contains(PhysicsDomain.values[i]),
              onTap: () => onDomain(
                PhysicsDomain.values[i],
                !enabled.contains(PhysicsDomain.values[i]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DomainPill extends StatelessWidget {
  const _DomainPill({
    required this.domain,
    required this.selected,
    required this.onTap,
  });

  final PhysicsDomain domain;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final paint = _DomainPaint.of(domain);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? paint.color : Colors.grey.shade200,
          gradient: selected ? paint.gradient : null,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? paint.border : Colors.grey.shade400,
            width: 2,
          ),
        ),
        child: Text(
          domain.label(context),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _DomainPaint {
  const _DomainPaint({required this.border, this.color, this.gradient});

  final Color border;
  final Color? color;
  final Gradient? gradient;

  static _DomainPaint of(PhysicsDomain domain) => switch (domain) {
    PhysicsDomain.mechanics => _DomainPaint(
      color: Colors.purple,
      border: Colors.purple.shade700,
    ),
    PhysicsDomain.thermodynamics => const _DomainPaint(
      border: Color(0xFFFF5722),
      gradient: LinearGradient(
        colors: [Color(0xFFFF5722), Color(0xFFFF9800)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    PhysicsDomain.waves => _DomainPaint(
      color: Colors.cyan,
      border: Colors.cyan.shade700,
    ),
    PhysicsDomain.electromagnetism => _DomainPaint(
      color: Colors.amber,
      border: Colors.amber.shade700,
    ),
    PhysicsDomain.atom => _DomainPaint(
      color: Colors.green,
      border: Colors.green.shade700,
    ),
  };
}

/// 一覧・問題文カードの薄い単元色。
class DomainTintCard extends StatelessWidget {
  const DomainTintCard({super.key, required this.domains, required this.child});

  final Set<PhysicsDomain> domains;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ordered = orderedDomains(domains);
    final tint = ordered.isEmpty
        ? Colors.white
        : domainCardTint(ordered.first);
    final gradient = ordered.length > 1
        ? LinearGradient(
            colors: [for (final domain in ordered) domainCardTint(domain)],
          )
        : null;
    return Card(
      margin: EdgeInsets.zero,
      color: tint,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: gradient == null ? null : BoxDecoration(gradient: gradient),
        child: child,
      ),
    );
  }
}

/// 単位ガチャの青い除外ガジェット。タップでメニューが開く。
class ExclusionFilterCard extends StatefulWidget {
  const ExclusionFilterCard({
    super.key,
    required this.mode,
    required this.remaining,
    required this.total,
    required this.enabled,
    required this.onDomain,
    required this.onChanged,
  });

  final ExclusionMode mode;
  final int remaining;
  final int total;
  final Set<PhysicsDomain> enabled;
  final void Function(PhysicsDomain domain, bool selected) onDomain;
  final ValueChanged<ExclusionMode> onChanged;

  @override
  State<ExclusionFilterCard> createState() => _ExclusionFilterCardState();
}

class _ExclusionFilterCardState extends State<ExclusionFilterCard> {
  final _key = GlobalKey();

  Future<void> _openMenu() async {
    final target = _key.currentContext?.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (target == null || overlay == null) return;
    final origin = target.localToGlobal(Offset.zero, ancestor: overlay);
    final selected = await showMenu<ExclusionMode>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(origin.dx, origin.dy + target.size.height, target.size.width, 0),
        Offset.zero & overlay.size,
      ),
      items: [
        for (final mode in ExclusionMode.values)
          PopupMenuItem(value: mode, child: _ExclusionLabel(mode: mode, compact: true)),
      ],
    );
    if (selected != null) widget.onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final countText = widget.mode == ExclusionMode.none
        ? l10n.exclusionNoneWithTotal(widget.total)
        : l10n.remainingProblems(widget.remaining, widget.total);
    return Container(
      key: _key,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE6F4FF), Color(0xFFF0F9FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _openMenu,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.filterSettings,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[700]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    countText,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue[700]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          DomainChips(enabled: widget.enabled, onDomain: widget.onDomain),
          const SizedBox(height: 6),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _openMenu,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ExclusionLabel(mode: widget.mode, compact: false),
                  const SizedBox(width: 4),
                  Icon(Icons.expand_more, size: 20, color: Colors.blue[600]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExclusionLabel extends StatelessWidget {
  const _ExclusionLabel({required this.mode, required this.compact});

  final ExclusionMode mode;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 14,
      fontWeight: compact ? FontWeight.normal : FontWeight.bold,
      color: compact ? Colors.grey[900] : Colors.blue[600],
    );
    final l10n = AppLocalizations.of(context)!;
    if (mode == ExclusionMode.none) {
      return Text(l10n.exclusionNone, style: style);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l10n.exclusionLatestPrefix(mode.neededGreens), style: style),
        const SizedBox(width: 4),
        const _SolvedBadge(),
        const SizedBox(width: 4),
        Text(l10n.exclusionThenRemoveFromGacha, style: style),
      ],
    );
  }
}

class _SolvedBadge extends StatelessWidget {
  const _SolvedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: const Icon(Icons.check_circle, size: 11, color: Colors.white),
    );
  }
}
