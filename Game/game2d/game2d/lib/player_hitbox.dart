import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../nine_souls_game.dart';
import 'base_enemy.dart';

enum HitboxType { light, heavy, finisher }

class PlayerHitbox extends RectangleComponent with HasGameRef<NineSoulsGame> {
  final Vector2 localPos;
  final int     damage;
  final double  knockback;
  final int     direction;
  final double  stunDuration;
  final HitboxType type;
  final Set<BaseEnemy> _hit = {};
  double _life = 0.22;

  PlayerHitbox({
    required this.localPos,
    required super.size,
    required this.damage,
    required this.knockback,
    required this.direction,
    required this.stunDuration,
    required this.type,
  }) : super(paint: Paint()..color = const Color(0x00000000));

  @override
  void onMount() {
    super.onMount();
    position = localPos;
  }

  @override
  void render(Canvas canvas) {
    // Visible hitbox outline that fades
    final alpha = (_life / 0.22).clamp(0.0, 1.0);
    final Color color = switch (type) {
      HitboxType.finisher => Color.fromARGB((180 * alpha).round(), 255, 200, 0),
      HitboxType.heavy    => Color.fromARGB((160 * alpha).round(), 255, 136, 0),
      HitboxType.light    => Color.fromARGB((130 * alpha).round(), 200, 220, 255),
    };

    // Filled glow
    canvas.drawRect(
      size.toRect(),
      Paint()..color = color.withOpacity(color.opacity * 0.25),
    );
    // Outline
    canvas.drawRect(
      size.toRect(),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Corner ticks
    const tick = 8.0;
    final corners = [
      [Offset(0, 0), Offset(tick, 0), Offset(0, tick)],
      [Offset(size.x, 0), Offset(size.x - tick, 0), Offset(size.x, tick)],
      [Offset(0, size.y), Offset(tick, size.y), Offset(0, size.y - tick)],
      [Offset(size.x, size.y), Offset(size.x - tick, size.y), Offset(size.x, size.y - tick)],
    ];
    for (final corner in corners) {
      canvas.drawLine(corner[0], corner[1], Paint()..color = color..strokeWidth = 2);
      canvas.drawLine(corner[0], corner[2], Paint()..color = color..strokeWidth = 2);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _life -= dt;
    _checkHits();
  }

  void _checkHits() {
    final absPos = absolutePosition;
    final myRect = Rect.fromLTWH(absPos.x, absPos.y, size.x, size.y);

    for (final c in gameRef.children) {
      if (c is BaseEnemy && !c.isDead && !_hit.contains(c)) {
        final er = Rect.fromLTWH(c.position.x, c.position.y, c.size.x, c.size.y);
        if (myRect.overlaps(er)) {
          _hit.add(c);
          c.takeDamage(
            damage,
            fromDir: direction,
            stunDuration: stunDuration,
            knockback: knockback,
          );
        }
      }
    }
  }
}