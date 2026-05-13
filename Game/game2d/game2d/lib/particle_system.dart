import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'nine_souls_game.dart';

class ParticleSystem extends Component with HasGameRef<NineSoulsGame> {
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void update(double dt) {
    _particles.removeWhere((p) {
      p.update(dt);
      return p.isDead;
    });
  }

  @override
  void render(Canvas canvas) {
    for (final p in _particles) {
      p.render(canvas);
    }
  }

  void _addParticle(Particle particle) {
    _particles.add(particle);
  }

  // ── Dust particles (landing/jump) ──────────────────────────
  void spawnDust(Vector2 pos) {
    for (int i = 0; i < 6; i++) {
      _addParticle(
        DustParticle(
          position: pos + Vector2(
            _random.nextDouble() * 20 - 10,
            _random.nextDouble() * 8,
          ),
          velocity: Vector2(
            _random.nextDouble() * 100 - 50,
            _random.nextDouble() * 50,
          ),
          size: 3 + _random.nextDouble() * 4,
        ),
      );
    }
  }

  // ── Dash particles ─────────────────────────────────────────
  void spawnDash(Vector2 pos, int dir) {
    for (int i = 0; i < 12; i++) {
      _addParticle(
        DashParticle(
          position: pos + Vector2(
            _random.nextDouble() * 30 - 15,
            _random.nextDouble() * 20 - 10,
          ),
          velocity: Vector2(
            dir * (50 + _random.nextDouble() * 100),
            _random.nextDouble() * 100 - 50,
          ),
          size: 2 + _random.nextDouble() * 4,
        ),
      );
    }
  }

  // ── Slash particles (attacks) ──────────────────────────────
  void spawnSlash(Vector2 pos, int dir, {bool heavy = false}) {
    final count = heavy ? 12 : 7;
    for (int i = 0; i < count; i++) {
      _addParticle(
        SlashParticle(
          position: pos + Vector2(
            _random.nextDouble() * 40 - 20,
            _random.nextDouble() * 30 - 15,
          ),
          velocity: Vector2(
            dir * (80 + _random.nextDouble() * 150),
            _random.nextDouble() * 200 - 100,
          ),
          size: 2 + _random.nextDouble() * 6,
          heavy: heavy,
        ),
      );
    }
  }

  // ── Parry particles ────────────────────────────────────────
  void spawnParry(Vector2 pos) {
    for (int i = 0; i < 20; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 100 + _random.nextDouble() * 150;
      _addParticle(
        ParryParticle(
          position: pos + Vector2(
            _random.nextDouble() * 30 - 15,
            _random.nextDouble() * 30 - 15,
          ),
          velocity: Vector2(cos(angle) * speed, sin(angle) * speed),
          size: 2 + _random.nextDouble() * 4,
        ),
      );
    }
  }

  // ── Hit particles (enemy hit) ──────────────────────────────
  void spawnHit(Vector2 pos) {
    for (int i = 0; i < 8; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 80 + _random.nextDouble() * 120;
      _addParticle(
        HitParticle(
          position: pos + Vector2(
            _random.nextDouble() * 20 - 10,
            _random.nextDouble() * 20 - 10,
          ),
          velocity: Vector2(cos(angle) * speed, sin(angle) * speed),
          size: 2 + _random.nextDouble() * 4,
        ),
      );
    }
  }

  // ── Hurt particles (player hurt) ───────────────────────────
  void spawnHurt(Vector2 pos) {
    for (int i = 0; i < 12; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 100 + _random.nextDouble() * 150;
      _addParticle(
        HurtParticle(
          position: pos + Vector2(
            _random.nextDouble() * 25 - 12.5,
            _random.nextDouble() * 25 - 12.5,
          ),
          velocity: Vector2(cos(angle) * speed, sin(angle) * speed),
          size: 2 + _random.nextDouble() * 5,
        ),
      );
    }
  }

  // ── Heal particles ─────────────────────────────────────────
  void spawnHeal(Vector2 pos) {
    for (int i = 0; i < 15; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 50 + _random.nextDouble() * 100;
      _addParticle(
        HealParticle(
          position: pos + Vector2(
            _random.nextDouble() * 30 - 15,
            _random.nextDouble() * 30 - 15,
          ),
          velocity: Vector2(cos(angle) * speed, sin(angle) * speed),
          size: 2 + _random.nextDouble() * 4,
        ),
      );
    }
  }

  // ── Enemy death particles ──────────────────────────────────
  void spawnEnemyDeath(Vector2 pos) {
    for (int i = 0; i < 20; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 100 + _random.nextDouble() * 200;
      _addParticle(
        DeathParticle(
          position: pos + Vector2(
            _random.nextDouble() * 40 - 20,
            _random.nextDouble() * 40 - 20,
          ),
          velocity: Vector2(cos(angle) * speed, sin(angle) * speed),
          size: 2 + _random.nextDouble() * 6,
        ),
      );
    }
  }
}

// ── Base Particle Class ─────────────────────────────────────
abstract class Particle {
  Vector2 position;
  Vector2 velocity;
  double life;
  double maxLife;
  bool isDead = false;

  Particle({
    required this.position,
    required this.velocity,
    required this.life,
  }) : maxLife = life;

  void update(double dt) {
    position += velocity * dt;
    velocity.y += 500 * dt; // gravity
    velocity.x *= 0.98;
    life -= dt;
    if (life <= 0) isDead = true;
  }

  void render(Canvas canvas);
}

// ── Dust Particle ───────────────────────────────────────────
class DustParticle extends Particle {
  final double size;
  DustParticle({
    required super.position,
    required super.velocity,
    required this.size,
  }) : super(life: 0.3);

  @override
  void render(Canvas canvas) {
    final alpha = (life / maxLife).clamp(0.0, 1.0);
    canvas.drawCircle(
      position.toOffset(),
      size,
      Paint()..color = Color.fromARGB((80 * alpha).round(), 150, 140, 120),
    );
  }
}

// ── Dash Particle ───────────────────────────────────────────
class DashParticle extends Particle {
  final double size;
  DashParticle({
    required super.position,
    required super.velocity,
    required this.size,
  }) : super(life: 0.25);

  @override
  void render(Canvas canvas) {
    final alpha = (life / maxLife).clamp(0.0, 1.0);
    canvas.drawCircle(
      position.toOffset(),
      size,
      Paint()..color = Color.fromARGB((120 * alpha).round(), 100, 180, 255),
    );
  }
}

// ── Slash Particle ──────────────────────────────────────────
class SlashParticle extends Particle {
  final double size;
  final bool heavy;
  SlashParticle({
    required super.position,
    required super.velocity,
    required this.size,
    this.heavy = false,
  }) : super(life: heavy ? 0.25 : 0.2);

  @override
  void render(Canvas canvas) {
    final alpha = (life / maxLife).clamp(0.0, 1.0);
    final color = heavy
        ? Color.fromARGB((180 * alpha).round(), 255, 150, 0)
        : Color.fromARGB((150 * alpha).round(), 200, 220, 255);
    canvas.drawCircle(position.toOffset(), size, Paint()..color = color);
  }
}

// ── Parry Particle ──────────────────────────────────────────
class ParryParticle extends Particle {
  final double size;
  ParryParticle({
    required super.position,
    required super.velocity,
    required this.size,
  }) : super(life: 0.3);

  @override
  void render(Canvas canvas) {
    final alpha = (life / maxLife).clamp(0.0, 1.0);
    canvas.drawCircle(
      position.toOffset(),
      size,
      Paint()..color = Color.fromARGB((180 * alpha).round(), 255, 220, 80),
    );
  }
}

// ── Hit Particle ────────────────────────────────────────────
class HitParticle extends Particle {
  final double size;
  HitParticle({
    required super.position,
    required super.velocity,
    required this.size,
  }) : super(life: 0.2);

  @override
  void render(Canvas canvas) {
    final alpha = (life / maxLife).clamp(0.0, 1.0);
    canvas.drawCircle(
      position.toOffset(),
      size,
      Paint()..color = Color.fromARGB((200 * alpha).round(), 255, 100, 50),
    );
  }
}

// ── Hurt Particle ───────────────────────────────────────────
class HurtParticle extends Particle {
  final double size;
  HurtParticle({
    required super.position,
    required super.velocity,
    required this.size,
  }) : super(life: 0.25);

  @override
  void render(Canvas canvas) {
    final alpha = (life / maxLife).clamp(0.0, 1.0);
    canvas.drawCircle(
      position.toOffset(),
      size,
      Paint()..color = Color.fromARGB((180 * alpha).round(), 255, 60, 60),
    );
  }
}

// ── Heal Particle ───────────────────────────────────────────
class HealParticle extends Particle {
  final double size;
  HealParticle({
    required super.position,
    required super.velocity,
    required this.size,
  }) : super(life: 0.4);

  @override
  void render(Canvas canvas) {
    final alpha = (life / maxLife).clamp(0.0, 1.0);
    canvas.drawCircle(
      position.toOffset(),
      size,
      Paint()..color = Color.fromARGB((160 * alpha).round(), 80, 255, 100),
    );
  }
}

// ── Death Particle ──────────────────────────────────────────
class DeathParticle extends Particle {
  final double size;
  DeathParticle({
    required super.position,
    required super.velocity,
    required this.size,
  }) : super(life: 0.5);

  @override
  void render(Canvas canvas) {
    final alpha = (life / maxLife).clamp(0.0, 1.0);
    canvas.drawCircle(
      position.toOffset(),
      size,
      Paint()..color = Color.fromARGB((200 * alpha).round(), 100, 80, 60),
    );
  }
}