import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../main.dart';
import '../player.dart';

class VictoryPortal extends PositionComponent with HasGameRef<AnimaSolsGame>, CollisionCallbacks {
  double animationTime = 0.0;

  VictoryPortal({required Vector2 position}) {
    this.position = position;
    size = Vector2(50, 80);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    animationTime += 0.05;
    // Efeito de pulsação neon
    double pulse = 4.0 + (animationTime.toInt() % 3);

    // Brilho Neon Ciano/Verde do portal
    Paint glowPaint = Paint()
      ..color = const Color(0xFF00FFCC).withOpacity(0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, pulse);
    canvas.drawOval(size.toRect(), glowPaint);

    // Linha externa firme do portal
    Paint borderPaint = Paint()
      ..color = const Color(0xFF00FFCC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawOval(size.toRect(), borderPaint);

    // Núcleo escuro gótico
    Paint corePaint = Paint()..color = const Color(0xFF0D1117);
    canvas.drawOval(Rect.fromLTWH(6, 10, size.x - 12, size.y - 20), corePaint);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    
    if (other is PlayerCharacter) {
      // Quando o jogador toca no portal, ativa a tela de vitória
      gameRef.pauseEngine();
      gameRef.overlays.add('VictoryScreen');
    }
  }
}
