import 'dart:ui';

import 'package:flame/components.dart';

/// A platform tile drawn with stone-texture shading.
class Platform extends RectangleComponent {
  final bool isBossRoom;

  Platform({
    required super.position,
    required super.size,
    this.isBossRoom = false,
  }) : super(paint: Paint()..color = const Color(0xFF1a1428));

  @override
  void render(Canvas canvas) {
    // Base fill
    final basePaint = Paint()
      ..color = isBossRoom ? const Color(0xFF2a0808) : const Color(0xFF1a1428);
    canvas.drawRect(size.toRect(), basePaint);

    // Top edge highlight
    final edgePaint = Paint()
      ..color = isBossRoom ? const Color(0xFF551010) : const Color(0xFF2a2060);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, 3), edgePaint);

    // Stone seam lines
    final seamPaint = Paint()
      ..color = const Color(0x33000000)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final seams = (size.x / 48).floor();
    for (int i = 1; i <= seams; i++) {
      final x = i * 48.0;
      canvas.drawLine(Offset(x, 0), Offset(x, size.y), seamPaint);
    }

    // Bottom shadow
    final shadowPaint = Paint()
      ..color = const Color(0x44000000);
    canvas.drawRect(
      Rect.fromLTWH(0, size.y - 4, size.x, 4),
      shadowPaint,
    );
  }
}