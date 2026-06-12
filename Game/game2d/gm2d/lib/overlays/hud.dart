import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import '../main.dart'; // Ajustado para voltar uma pasta e achar o main.dart

class GameHUD extends PositionComponent with HasGameRef<AnimaSolsGame> {
  GameHUD() {
    position = Vector2(20, 20); // Distância do canto superior esquerdo
    size = Vector2(300, 60);
  }

  @override
  void render(Canvas canvas) {
    final player = gameRef.player;

    // Se o player ainda não foi criado pelo jogo, interrompe a renderização para evitar erros
    if (player == null) return;

    // --- 1. DESENHAR A BARRA DE CHI (ENERGIA) ---
    final chiBgPaint = Paint()..color = const Color(0xFF1F2937);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(0, 0, 200, 14), const Radius.circular(7)), chiBgPaint);

    final chiPaint = Paint()..color = const Color(0xFF00FFCC); 
    double chiWidth = (player.currentChi / player.maxChi) * 200;
    if (chiWidth > 0) {
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, chiWidth, 14), const Radius.circular(7)), chiPaint);
    }

    // --- 2. DESENHAR AS MÁSCARAS DE VIDA (HP) ---
    final healthPaint = Paint()..color = const Color(0xFFFF0055); 
    final healthEmptyPaint = Paint()
      ..color = const Color(0xFF374151)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double maskSize = 16.0;
    double maskSpacing = 6.0;

    for (int i = 0; i < player.maxHealth; i++) {
      double xPos = i * (maskSize + maskSpacing);
      double yPos = 24.0; 

      if (i < player.currentHealth) {
        canvas.save();
        canvas.translate(xPos + maskSize / 2, yPos + maskSize / 2);
        canvas.rotate(0.785398); 
        canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: maskSize - 2, height: maskSize - 2), healthPaint);
        canvas.restore();
      } else {
        canvas.save();
        canvas.translate(xPos + maskSize / 2, yPos + maskSize / 2);
        canvas.rotate(0.785398);
        canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: maskSize - 2, height: maskSize - 2), healthEmptyPaint);
        canvas.restore();
      }
    }
  }
}
