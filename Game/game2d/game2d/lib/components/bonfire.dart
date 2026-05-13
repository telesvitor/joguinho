import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../nine_souls_game.dart';

class Bonfire extends RectangleComponent with HasGameRef<NineSoulsGame> {
  bool isLit = true;
  double _flameTimer = 0;
  double _particleTimer = 0;
  final List<FireParticle> _fireParticles = [];
  final Random _random = Random();

  Bonfire({
    required super.position,
    this.isLit = true,
  }) : super(
          size: Vector2(32, 24),
          paint: Paint()..color = Colors.transparent,
        );

  @override
  void onLoad() {
    super.onLoad();
    // Spawn initial particles
    for (int i = 0; i < 8; i++) {
      _fireParticles.add(FireParticle(
        position: position + Vector2(size.x / 2, size.y / 2),
        velocity: Vector2(
          _random.nextDouble() * 40 - 20,
          _random.nextDouble() * 60 - 100,
        ),
        size: 2 + _random.nextDouble() * 4,
        life: 0.3 + _random.nextDouble() * 0.3,
      ));
    }
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    
    // Stone base
    final basePaint = Paint()..color = const Color(0xFF444444);
    final basePath = Path()
      ..moveTo(4, size.y - 4)
      ..lineTo(size.x - 4, size.y - 4)
      ..lineTo(size.x - 8, size.y - 8)
      ..lineTo(8, size.y - 8)
      ..close();
    canvas.drawPath(basePath, basePaint);
    
    // Stone details
    final stonePaint = Paint()..color = const Color(0xFF555555);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(6, size.y - 12, 20, 6),
        const Radius.circular(2),
      ),
      stonePaint,
    );
    
    if (!isLit) {
      // Cold ashes
      final ashPaint = Paint()..color = const Color(0xFF333333);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(10, size.y - 10, 12, 4),
          const Radius.circular(2),
        ),
        ashPaint,
      );
      return;
    }
    
    // Fire glow (outer)
    final glowAlpha = (0.5 + sin(_flameTimer * 8) * 0.3).clamp(0.3, 0.8);
    final glowPaint = Paint()
      ..color = Color.fromARGB((80 * glowAlpha).round(), 255, 100, 0)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(center, size.x * 1.2, glowPaint);
    
    // Inner glow
    final innerGlowPaint = Paint()
      ..color = Color.fromARGB((120 * glowAlpha).round(), 255, 180, 0)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center, size.x * 0.8, innerGlowPaint);
    
    // Fire shapes
    final flameHeight = 10 + sin(_flameTimer * 12) * 3;
    final flamePaint = Paint()..color = const Color(0xFFFF6600);
    final flamePath = Path()
      ..moveTo(center.dx - 4, center.dy - 2)
      ..quadraticBezierTo(
        center.dx - 2, center.dy - flameHeight,
        center.dx, center.dy - flameHeight - 2,
      )
      ..quadraticBezierTo(
        center.dx + 2, center.dy - flameHeight,
        center.dx + 4, center.dy - 2,
      )
      ..close();
    canvas.drawPath(flamePath, flamePaint);
    
    // Flame core (yellow/white)
    final corePaint = Paint()..color = const Color(0xFFFFAA44);
    final corePath = Path()
      ..moveTo(center.dx - 2, center.dy - 2)
      ..quadraticBezierTo(
        center.dx - 1, center.dy - flameHeight * 0.6,
        center.dx, center.dy - flameHeight * 0.8,
      )
      ..quadraticBezierTo(
        center.dx + 1, center.dy - flameHeight * 0.6,
        center.dx + 2, center.dy - 2,
      )
      ..close();
    canvas.drawPath(corePath, corePaint);
    
    // Ember particles
    for (final p in _fireParticles) {
      p.render(canvas, position);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (!isLit) return;
    
    _flameTimer += dt;
    _particleTimer += dt;
    
    // Update particles
    _fireParticles.removeWhere((p) {
      p.update(dt);
      return p.isDead;
    });
    
    // Spawn new particles
    if (_particleTimer > 0.05) {
      _particleTimer = 0;
      _fireParticles.add(FireParticle(
        position: position + Vector2(size.x / 2, size.y / 2),
        velocity: Vector2(
          _random.nextDouble() * 60 - 30,
          _random.nextDouble() * 80 - 120,
        ),
        size: 1 + _random.nextDouble() * 4,
        life: 0.2 + _random.nextDouble() * 0.3,
      ));
    }
  }
  
  Rect toAbsoluteRect() => Rect.fromLTWH(position.x, position.y, size.x, size.y);
}

class FireParticle {
  Vector2 position;
  Vector2 velocity;
  double size;
  double life;
  double maxLife;
  bool isDead = false;
  final Random _random = Random();

  FireParticle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.life,
  }) : maxLife = life;

  void update(double dt) {
    position += velocity * dt;
    velocity.y += 60 * dt; // slight upward drift
    velocity.x *= 0.98;
    life -= dt;
    if (life <= 0) isDead = true;
  }

  void render(Canvas canvas, Vector2 parentPos) {
    final alpha = (life / maxLife).clamp(0.0, 1.0);
    final screenPos = position;
    
    // Ember color based on age
    final age = 1.0 - (life / maxLife);
    final Color color;
    if (age < 0.3) {
      color = Color.fromARGB((200 * alpha).round(), 255, 100, 0);
    } else if (age < 0.6) {
      color = Color.fromARGB((180 * alpha).round(), 255, 60, 0);
    } else {
      color = Color.fromARGB((120 * alpha).round(), 100, 40, 0);
    }
    
    canvas.drawCircle(
      Offset(screenPos.x - parentPos.x, screenPos.y - parentPos.y),
      size,
      Paint()..color = color,
    );
  }
}