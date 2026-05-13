import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'base_enemy.dart';
import '../player.dart';

class SkeletonEnemy extends BaseEnemy {
  double attackCooldown = 0;
  double _speed = 80;
  double _range = 100;
  int _faceDir = 1;
  
  SkeletonEnemy({required super.position})
      : super(
          size: Vector2(40, 40),
          maxHp: 50,
        );
  
  @override
  void aiUpdate(double dt) {
    if (attackCooldown > 0) attackCooldown -= dt;

    // Verificar se o player existe e é do tipo correto
    final playerComponent = gameRef.player;
    if (playerComponent == null) return;
    
    // Acessar a posição corretamente
    final diff = playerComponent.position.x - position.x;
    _faceDir = diff >= 0 ? 1 : -1;

    if (diff.abs() > _range) {
      velocity.x = _faceDir * _speed;
    } else {
      velocity.x = 0;
      if (attackCooldown <= 0) {
        attackCooldown = 1.8;
        _attackPlayer(playerComponent);
      }
    }
  }
  
  void _attackPlayer(Player playerComponent) {
    playerComponent.takeDamage(10);
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final bodyPaint = Paint()..color = const Color(0xFFE8E8E8);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), bodyPaint);
    
    final bonePaint = Paint()..color = const Color(0xFFC0C0C0);
    canvas.drawLine(
      Offset(size.x * 0.2, size.y * 0.3),
      Offset(size.x * 0.8, size.y * 0.3),
      bonePaint..strokeWidth = 3,
    );
    canvas.drawLine(
      Offset(size.x * 0.2, size.y * 0.5),
      Offset(size.x * 0.8, size.y * 0.5),
      bonePaint..strokeWidth = 3,
    );
    canvas.drawLine(
      Offset(size.x * 0.2, size.y * 0.7),
      Offset(size.x * 0.8, size.y * 0.7),
      bonePaint..strokeWidth = 3,
    );
    
    final eyePaint = Paint()..color = Colors.red;
    if (_faceDir == 1) {
      canvas.drawCircle(Offset(size.x - 10, size.y * 0.4), 4, eyePaint);
      canvas.drawCircle(Offset(size.x - 10, size.y * 0.6), 4, eyePaint);
    } else {
      canvas.drawCircle(Offset(10, size.y * 0.4), 4, eyePaint);
      canvas.drawCircle(Offset(10, size.y * 0.6), 4, eyePaint);
    }
    
    drawHpBar(canvas);
  }
}