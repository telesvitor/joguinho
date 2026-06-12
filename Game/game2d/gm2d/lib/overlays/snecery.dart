import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

// ADICIONADO: 'with CollisionCallbacks' para o Flame processar as colisões corretamente
class GamePlatform extends PositionComponent with CollisionCallbacks {
  final Color color;

  GamePlatform({
    required Vector2 position,
    required Vector2 size,
    this.color = const Color(0xFF1E222B), 
  }) {
    this.position = position;
    this.size = size;
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad(); // ADICIONADO: Boa prática chamar o super.onLoad()

    // CORRIGIDO: Agora passamos o tamanho real (size) explicitamente no construtor.
    // Isso força o Flame a criar uma caixa sólida exatamente do tamanho da plataforma!
    add(RectangleHitbox(
      position: Vector2.zero(),
      size: size,
    )..collisionType = CollisionType.passive);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = color;
    canvas.drawRect(size.toRect(), paint);

    final detailPaint = Paint()
      ..color = const Color(0xFF3F72AF).withOpacity(0.3)
      ..strokeWidth = 1.5;

    for (double i = 0; i < size.x; i += 32) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.y), detailPaint);
    }
    for (double j = 0; j < size.y; j += 16) {
      canvas.drawLine(Offset(0, j), Offset(size.x, j), detailPaint);
    }

    final topNeon = Paint()
      ..color = const Color(0xFF3F72AF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawLine(Offset.zero, Offset(size.x, 0), topNeon);
  }
}
