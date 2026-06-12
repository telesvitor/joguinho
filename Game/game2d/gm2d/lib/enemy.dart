import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'main.dart';
import 'player.dart';
import 'chiorbs.dart'; 
import 'collision_manager.dart'; 

class SimpleEnemy extends PositionComponent with HasGameRef<AnimaSolsGame>, CollisionCallbacks {
  Vector2 velocity = Vector2.zero();
  double patrolSpeed = 60.0;
  double chaseSpeed = 130.0; 
  double direction = 1.0;
  
  double startX;
  double patrolRange = 120.0;
  
  bool isHit = false;
  double hitTimer = 0.0;
  double animationTime = 0.0;

  // --- ATRIBUTOS DE RESISTÊNCIA ---
  int hp = 3;

  final double detectionRange = 200.0;

  SimpleEnemy({required Vector2 position}) : startX = position.x {
    this.position = position;
    size = Vector2(40, 50);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayerCharacter) {
      if (other.isAttacking && other.attackDirection != 1 && !isHit) {
        takeDamage();
      } else {
        GameCollisionManager.handleEnemyCollision(other, this);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (gameRef.player == null) return;
    
    animationTime += 0.05;
    double hover = (animationTime.toInt() % 2 == 0) ? 2.0 : -2.0;

    canvas.save();
    canvas.translate(0, hover);

    Paint bodyPaint = Paint()..color = isHit ? Colors.white : const Color(0xFF2C3E50);
    canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)), bodyPaint);

    Paint cloakPaint = Paint()..color = const Color(0xFF7F8C8D);
    canvas.drawRect(Rect.fromLTWH(2, size.y - 15, size.x - 4, 15), cloakPaint);

    final player = gameRef.player!;
    double distanceToPlayer = (position.x - player.position.x).abs();
    bool isChasing = distanceToPlayer < detectionRange;

    Paint eyePaint = Paint()..color = isChasing ? const Color(0xFFFFCC00) : const Color(0xFFFF0055);
    double eyeX = direction == 1 ? size.x - 12 : 4;
    canvas.drawOval(Rect.fromLTWH(eyeX, 12, 8, 8), eyePaint);

    canvas.restore();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.player == null) return;

    if (isHit) {
      hitTimer -= dt;
      if (hitTimer <= 0) isHit = false;
    }

    final player = gameRef.player!;
    double distanceToPlayer = (position.x - player.position.x).abs();
    double heightDifference = (position.y - player.position.y).abs();

    if (distanceToPlayer < detectionRange && heightDifference < 80) {
      direction = player.position.x > position.x ? 1.0 : -1.0;
      velocity.x = chaseSpeed * direction;
    } else {
      if (position.x > startX + patrolRange) {
        direction = -1.0;
      } else if (position.x < startX - patrolRange) {
        direction = 1.0;
      }
      velocity.x = patrolSpeed * direction;
    }

    position += velocity * dt;
  }

  void takeDamage() {
    if (gameRef.player == null) return;
    
    isHit = true;
    hitTimer = 0.15;
    position.x += gameRef.player!.facingDirection * 15;
    gameRef.player!.onSuccessfulHit();

    hp--;
    if (hp <= 0) {
      die();
    }
  }

  void die() {
    gameRef.checkVictoryConditions();
    gameRef.add(ChiOrb(position: position.clone()));
    removeFromParent(); 
  }
}
