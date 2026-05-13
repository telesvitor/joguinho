import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game2d/particle_system.dart';
import '/nine_souls_game.dart';
import 'player_stats.dart';

class SoulOrbPickup extends RectangleComponent
    with HasGameRef<NineSoulsGame> {
  final Random _random = Random();
  double _bobOffset = 0;
  double _lifeTimer = 30.0; // auto-remove after 30 seconds
  bool _collected = false;

  SoulOrbPickup({
    required super.position,
  }) : super(
          size: Vector2(14, 14),
          paint: Paint()..color = Colors.transparent,
        );

  @override
  void update(double dt) {
    if (_collected) return;

    _lifeTimer -= dt;
    if (_lifeTimer <= 0) {
      removeFromParent();
      return;
    }

    _bobOffset += dt * 4;

    // Check collection by player
    final player = gameRef.player;
    final playerRect = player.toAbsoluteRect();
    final orbRect = toAbsoluteRect();

    if (playerRect.overlaps(orbRect)) {
      _collect();
    }
  }

  void _collect() {
    if (_collected) return;
    _collected = true;

    gameRef.stats.collectOrb();

    // Spawn collection particles
    gameRef.children.whereType<ParticleSystem>().firstOrNull
        ?.spawnHeal(position + Vector2(size.x / 2, size.y / 2));

    removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final bobY = sin(_bobOffset) * 3;
    final center = Offset(size.x / 2, size.y / 2 + bobY);
    final radius = size.x / 2;

    // Outer glow
    final glowPaint = Paint()
      ..color = const Color(0x66AA88FF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(center, radius + 4, glowPaint);

    // Core orb
    final orbPaint = Paint()
      ..shader = RadialGradient(
        colors: const [
          Color(0xFFAA88FF),
          Color(0xFF6644CC),
          Color(0xFF4422AA),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, orbPaint);

    // Inner shine
    final shinePaint = Paint()
      ..color = const Color(0xCCFFFFFF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(
      center + Offset(-2, -2),
      radius * 0.3,
      shinePaint,
    );

    // Orbiting particles
    final particleCount = 3;
    for (int i = 0; i < particleCount; i++) {
      final angle = _bobOffset * 3 + (i * 2 * pi / particleCount);
      final px = center.dx + cos(angle) * (radius + 3);
      final py = center.dy + sin(angle) * (radius + 3);
      canvas.drawCircle(
        Offset(px, py),
        2,
        Paint()..color = const Color(0xCCAA88FF),
      );
    }
  }

  Rect toAbsoluteRect() => Rect.fromLTWH(position.x, position.y, size.x, size.y);
}