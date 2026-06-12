import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../main.dart';
import '../player.dart';
import '../chiorbs.dart';

class RewardChest extends PositionComponent with HasGameRef<AnimaSolsGame>, CollisionCallbacks {
  bool isOpened = false;
  double animationTime = 0.0;

  RewardChest({required Vector2 position}) {
    this.position = position;
    size = Vector2(50, 40);
    anchor = Anchor.bottomCenter; 
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    animationTime += 0.05;
    
    Color chestColor = isOpened ? const Color(0xFF7F8C8D) : const Color(0xFF2C3E50);
    Color neonColor = isOpened ? const Color(0xFF3F72AF).withOpacity(0.4) : const Color(0xFF00FFCC);

    canvas.save();

    if (!isOpened) {
      double pulse = 6.0 + (animationTime.toInt() % 3);
      Paint glowPaint = Paint()
        ..color = neonColor.withOpacity(0.25)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, pulse);
      canvas.drawRect(size.toRect(), glowPaint);
    }

    Paint bodyPaint = Paint()..color = chestColor;
    canvas.drawRect(Rect.fromLTWH(0, size.y * 0.4, size.x, size.y * 0.6), bodyPaint);

    Paint lidPaint = Paint()..color = isOpened ? const Color(0xFF95A5A6) : const Color(0xFF34495E);
    if (!isOpened) {
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0, 0, size.x, size.y * 0.4),
          topLeft: const Radius.circular(8),
          topRight: const Radius.circular(8),
        ),
        lidPaint,
      );

      Paint lockPaint = Paint()..color = neonColor;
      canvas.drawRect(Rect.fromLTWH(size.x / 2 - 4, size.y * 0.35, 8, 8), lockPaint);
    } else {
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(-4, -size.y * 0.2, size.x + 8, size.y * 0.3),
          topLeft: const Radius.circular(4),
          topRight: const Radius.circular(4),
        ),
        lidPaint,
      );
    }

    Paint ironPaint = Paint()..color = const Color(0xFF1A252F);
    canvas.drawRect(Rect.fromLTWH(4, size.y * 0.4, 4, size.y * 0.6), ironPaint);
    canvas.drawRect(Rect.fromLTWH(size.x - 8, size.y * 0.4, 4, size.y * 0.6), ironPaint);

    canvas.restore();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Proteção essencial contra o erro Null Safety caso o player não tenha sido criado
    if (gameRef.player == null) return;

    if (!isOpened && gameRef.player!.isAttacking) {
      final player = gameRef.player!;
      double distanceX = (position.x - player.position.x).abs();
      double distanceY = (position.y - player.position.y).abs();

      if (distanceX < 55 && distanceY < 60) {
        openChest();
      }
    }
  }

  void openChest() {
    isOpened = true;
    
    gameRef.add(ChiOrb(position: Vector2(position.x - 30, position.y - 30)));
    gameRef.add(ChiOrb(position: Vector2(position.x, position.y - 50)));
    gameRef.add(ChiOrb(position: Vector2(position.x + 30, position.y - 30)));

    gameRef.updateHUDText("PORTÃO DA DIREITA ABERTO! AVANCE!");
    gameRef.canChangeRoom = true; 
  }
}
