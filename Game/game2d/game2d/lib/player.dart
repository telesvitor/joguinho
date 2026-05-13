import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'nine_souls_game.dart';

class Player extends RectangleComponent with HasGameRef<NineSoulsGame> {
  int health = 100;
  int maxHealth = 100;
  int souls = 0;
  int nineSoulsCollected = 0;
  
  Player() : super(
    size: Vector2(32, 32),
    position: Vector2(100, 500),
    paint: Paint()..color = Colors.blue,
  );
  
  void reset() {
    health = maxHealth;
    souls = 0;
    nineSoulsCollected = 0;
    position = Vector2(100, 500);
  }
  
  void takeDamage(int amount) {
    health -= amount;
    if (health <= 0) {
      gameRef.gameOver();
    }
  }
  
  void heal(int amount) {
    health = (health + amount).clamp(0, maxHealth);
  }
  
  void addSouls(int amount) {
    souls += amount;
  }
  
  void collectNineSoul() {
    nineSoulsCollected++;
    if (nineSoulsCollected >= 9) {
      gameRef.victory();
    }
  }
  
  Rect toAbsoluteRect() {
    return Rect.fromLTWH(position.x, position.y, size.x, size.y);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final paint = Paint()..color = Colors.blue;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
    
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(8, 8), 3, eyePaint);
    canvas.drawCircle(const Offset(24, 8), 3, eyePaint);
  }
}