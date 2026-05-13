import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../nine_souls_game.dart';
import 'platform.dart';
import 'soul_orb_pickup.dart';
import 'particle_system.dart';
import '../player.dart'; // Adicionar import do player

const double kGravity = 980.0;

abstract class BaseEnemy extends RectangleComponent
    with HasGameRef<NineSoulsGame> {
  int maxHp;
  int hp;
  Vector2 velocity = Vector2.zero();
  bool isStunned = false;
  double stunTimer = 0;
  bool isDead = false;
  double hurtFlash = 0;
  double animTimer = 0;

  BaseEnemy({
    required super.position,
    required super.size,
    required this.maxHp,
  })  : hp = maxHp,
        super(paint: Paint()..color = const Color(0x00000000));

  // Getter para acessar o player de forma segura
  Object? get player {
    try {
      return gameRef.player;
    } catch (e) {
      return null;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isDead) return;

    animTimer += dt;

    if (hurtFlash > 0) hurtFlash -= dt;

    if (stunTimer > 0) {
      stunTimer -= dt;
      velocity.x *= 0.82;
      if (stunTimer <= 0) {
        isStunned = false;
        onStunEnd();
      }
    }

    velocity.y += kGravity * dt;
    position += velocity * dt;
    _resolveGround();
    position.x = position.x.clamp(0, gameRef.size.x - size.x);

    if (!isStunned) aiUpdate(dt);
  }

  void aiUpdate(double dt);
  void onStunEnd() {}

  void takeDamage(
    int amount, {
    int fromDir = 1,
    double stunDuration = 0.35,
    double knockback = 400,
  }) {
    if (isDead) return;
    hp -= amount;
    isStunned = true;
    stunTimer = stunDuration;
    velocity.x = fromDir * knockback;
    velocity.y = -150;
    hurtFlash = 0.18;

    gameRef.children.whereType<ParticleSystem>().firstOrNull
        ?.spawnHit(position + Vector2(size.x / 2, size.y / 2));

    if (hp <= 0) die();
  }

  void die() {
    if (isDead) return;
    isDead = true;
    gameRef.children.whereType<ParticleSystem>().firstOrNull
        ?.spawnEnemyDeath(position + Vector2(size.x / 2, size.y / 2));
    gameRef.add(SoulOrbPickup(position: position.clone() + Vector2(size.x / 2, 0)));
    
    if (gameRef.roomManager != null) {
      gameRef.roomManager.onEnemyDefeated(this);
    }
    
    removeFromParent();
  }

  void _resolveGround() {
    for (final c in gameRef.children) {
      if (c is Platform) {
        final pr = c.toAbsoluteRect();
        final myBottom = position.y + size.y;
        if (velocity.y >= 0 &&
            myBottom >= pr.top &&
            myBottom <= pr.top + 26 &&
            position.x + size.x > pr.left + 4 &&
            position.x < pr.right - 4) {
          position.y = pr.top - size.y;
          velocity.y = 0;
          break;
        }
      }
    }
  }

  void drawHpBar(Canvas canvas) {
    final pct = (hp / maxHp).clamp(0.0, 1.0);
    canvas.drawRect(Rect.fromLTWH(0, -10, size.x, 5),
        Paint()..color = const Color(0xFF222222));
    final barColor = pct > 0.5
        ? const Color(0xFF44AA44)
        : pct > 0.25
            ? const Color(0xFFAAAA00)
            : const Color(0xFFCC2244);
    canvas.drawRect(Rect.fromLTWH(0, -10, size.x * pct, 5),
        Paint()..color = barColor);
  }

  Rect toAbsoluteRect() =>
      Rect.fromLTWH(position.x, position.y, size.x, size.y);
}