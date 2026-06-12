import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../main.dart';
import '../player.dart';
import '../collision_manager.dart'; // Importação do gerenciador adicionada

class SpikeHazard extends PositionComponent with HasGameRef<AnimaSolsGame>, CollisionCallbacks {
  SpikeHazard({required Vector2 position, required Vector2 size}) {
    this.position = position;
    this.size = size;
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFFFF3333); // Vermelho Neon Sangue
    final glowPaint = Paint()
      ..color = const Color(0xFFFF3333).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Desenha o brilho atrás dos espinhos
    canvas.drawRect(size.toRect(), glowPaint);

    // Desenha triângulos (espinhos) preenchendo a largura do bloco
    double spikeWidth = 20.0;
    double spikeHeight = size.y;

    for (double i = 0; i < size.x; i += spikeWidth) {
      Path spikePath = Path();
      spikePath.moveTo(i, size.y); // Base esquerda
      spikePath.lineTo(i + (spikeWidth / 2), size.y - spikeHeight); // Ponta do espinho
      spikePath.lineTo(i + spikeWidth, size.y); // Base direita
      spikePath.close();
      canvas.drawPath(spikePath, paint);
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    // Se bater no jogador, o gerenciador centralizado resolve a física (Pogo ou Dano)
    if (other is PlayerCharacter) {
      GameCollisionManager.handleSpikeCollision(other, this);
    }
  }
}
