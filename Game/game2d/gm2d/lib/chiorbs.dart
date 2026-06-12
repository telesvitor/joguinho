import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../main.dart';
import 'player.dart';

class ChiOrb extends PositionComponent with HasGameRef<AnimaSolsGame>, CollisionCallbacks {
  double animationTime = 0.0;

  ChiOrb({required Vector2 position}) {
    this.position = position;
    size = Vector2(20, 20);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
  }

  @override
  void render(Canvas canvas) {
    animationTime += 0.05;
    double hover = (animationTime.toInt() % 2 == 0) ? 1.5 : -1.5;

    canvas.save();
    canvas.translate(0, hover);

    Paint glowPaint = Paint()
      ..color = const Color(0xFF00FFCC).withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 10, glowPaint);

    Paint corePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 5, corePaint);

    canvas.restore();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is PlayerCharacter) {
      other.gainChi(20); 
      removeFromParent();
    }
  }
}
